local QUEUE = {}
QUEUE.TitleHeight = 64
QUEUE.QueueHeight = 48

function QUEUE:Init()
	self:SetZPos(1)
	self:SetSize(256, 512)
	self:SetPos(8, ScrH() / 2 - (self:GetTall() / 2))

	self.Title = Label(translations:Format("Queue_Title"), self)
	self.Title:SetFont("ScoreboardTitle")
	self.Title:SetColor(Color(255, 255, 255))

	self.NextUpdate = 0.0

	self.Videos = {}

	self.VideoList = vgui.Create("TheaterList", self)
	self.VideoList:DockMargin(0, self.TitleHeight + 2, 0, self.QueueHeight + 2)

	self.Options = vgui.Create("DPanelList", self)
	self.Options:SetDrawBackground(false)
	self.Options:SetPadding(4)
	self.Options:SetSpacing(4)

	-- Request a video
	local RequestButton = vgui.Create("TheaterButton")
	RequestButton:SetText(translations:Format("Request_Video"))
	RequestButton.DoClick = function()
		RunConsoleCommand("cinema_video_request")
	end
	self.Options:AddItem(RequestButton)

	-- Vote skip the current video
	local VoteSkipButton = vgui.Create("TheaterButton")
	VoteSkipButton:SetText(translations:Format("Vote_Skip"))
	VoteSkipButton.DoClick = function()
		RunConsoleCommand("cinema_voteskip")
	end
	self.Options:AddItem(VoteSkipButton)

	local FullscreenButton = vgui.Create("TheaterButton")
	FullscreenButton:SetText(translations:Format("Toggle_Fullscreen"))
	FullscreenButton.DoClick = function(self)
		RunConsoleCommand("cinema_fullscreen")
	end
	self.Options:AddItem(FullscreenButton)

	local RefreshButton = vgui.Create("TheaterButton")
	RefreshButton:SetText(translations:Format("Refresh_Theater"))
	RefreshButton.DoClick = function(self)
		RunConsoleCommand("cinema_refresh")
	end
	self.Options:AddItem(RefreshButton)

	self.RentButton = vgui.Create("TheaterButton")
	self.RentButton:SetText(translations:Format("Rent_RentTheater"))
	self.RentButton.DoClick = function()
		rent.CreateRentWindow()
	end
	self.RentButton:SetVisible(false)
	self.Options:AddItem(self.RentButton)
end

function QUEUE:AddVideo(vid)
	if self.Videos[vid.Id] then
		self.Videos[vid.Id]:SetVideo(vid)
	else
		local panel = vgui.Create("ScoreboardVideo", self)
		panel:SetVideo(vid)
		panel:SetVisible(true)
		self.Videos[vid.Id] = panel
		self.VideoList:AddItem(panel)
	end
end

function QUEUE:RemoveVideo(vid)
	if IsValid(self.Videos[vid.Id]) then
		self.VideoList:RemoveItem(self.Videos[vid.Id])
		self.Videos[vid.Id]:Remove()
		self.Videos[vid.Id] = nil
	end
end

function QUEUE:Update()
	local Theater = LocalPlayer():GetTheater() -- get player's theater from their location
	if not Theater then return end

	theater.PollServer()

	if IsValid(self.RentButton) then
		-- Prefer rent module state so the button reappears right after a refund,
		-- even if Theater._Owner is still briefly stale.
		local isRented
		if rent then
			isRented = rent.IsRented(Theater:GetLocation())
		else
			isRented = IsValid(Theater:GetOwner())
		end
		self.RentButton:SetVisible(Theater:IsPrivate() and not isRented)
	end
end

function QUEUE:UpdateList()
	local ids = {}
	for _, vid in pairs(theater.GetQueue()) do
		self:AddVideo(vid)
		table.insert(ids, vid.Id)
	end

	for k, panel in pairs(self.Videos) do
		if not table.HasValue(ids, k) then
			self:RemoveVideo(panel.Video)
		end
	end

	self:SortList()
end

function QUEUE:SortList()
	if theater.GetQueueMode() == QUEUE_CHRONOLOGICAL then
		self.VideoList:SortVideos(function(a, b)
			return a.Video:GetId() < b.Video:GetId()
		end)
	else
		self.VideoList:SortVideos(function(a, b)
			if a.Video:GetVotes() == b.Video:GetVotes() then
				return a.Video:GetId() < b.Video:GetId()
			else
				return a.Video:GetVotes() > b.Video:GetVotes()
			end
		end)
	end
end

function QUEUE:Think()
	if RealTime() > self.NextUpdate then
		self:Update()
		self:UpdateList()
		self.NextUpdate = RealTime() + 3.0
	end
end

local Background = Material("theater/banner.png")

function QUEUE:Paint(w, h)
	surface.SetDrawColor(26, 30, 38, 255)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	surface.SetDrawColor(141, 38, 33, 255)
	surface.DrawRect(0, 0, self:GetWide(), self.Title:GetTall())

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Background)
	surface.DrawTexturedRect(0, -1, 512, self.Title:GetTall() + 1)
end

function QUEUE:PerformLayout()
	self.Title:SizeToContents()
	self.Title:SetTall(self.TitleHeight)
	self.Title:CenterHorizontal()

	if self.Title:GetWide() > self:GetWide() and self.Title:GetFont() ~= "ScoreboardTitleSmall" then
		self.Title:SetFont("ScoreboardTitleSmall")
	end

	self.VideoList:Dock(FILL)

	self.Options:Dock(BOTTOM)
	self.Options:SetTall(self.QueueHeight)
	self.Options:SizeToContents()
end

vgui.Register("ScoreboardQueue", QUEUE)

-- Video panel
local VIDEO = {}
VIDEO.Height = 64

function VIDEO:Init()
	self:SetTall(self.Height)

	self.Title = Label("Unknown", self)
	self.Title:SetFont("ScoreboardVidTitle")
	self.Title:SetColor(Color(255, 255, 255))

	self.Duration = Label("0:00", self)
	self.Duration:SetFont("ScoreboardVidDuration")
	self.Duration:SetColor(Color(255, 255, 255))

	self.Controls = vgui.Create("ScoreboardVideoVote", self)
end

function VIDEO:Update()
	self.Title:SetText(self.Video:Title())
	self.Duration:SetText(self.Video:Duration() > 0 and string.FormatSeconds(self.Video:Duration()) or "")
	self.Controls:Update()
end

function VIDEO:SetVideo(vid)
	self.Video = vid
	self.Controls:SetVideo(vid)
	self:Update()
end

function VIDEO:PerformLayout()
	self.Controls:SizeToContents()
	self.Controls:CenterVertical()
	self.Controls:AlignRight(4)

	local x, y = self.Controls:GetPos()

	self.Title:SizeToContents()
	local w = math.Clamp(self.Title:GetWide(), 0, x - 12)
	self.Title:SetSize(w, 20)
	self.Title:AlignTop(4)
	self.Title:AlignLeft(8)

	self.Duration:SizeToContents()
	self.Duration:AlignTop(24)
	self.Duration:AlignLeft(8)
end

function VIDEO:Paint(w, h)
	surface.SetDrawColor(38, 41, 49, 255)
	surface.DrawRect(0, 0, self:GetSize())
end

vgui.Register("ScoreboardVideo", VIDEO)

local VIDEOVOTE = {}
VIDEOVOTE.Padding = 4

function VIDEOVOTE:Init()
	self.Votes = Label("0", self)
	self.Votes:SetFont("ScoreboardVidVotes")
	self.Votes:SetColor(Color(255, 255, 255))

	self.VoteUp = vgui.Create("DImageButton", self)
	self.VoteUp:SetSize(16, 16)
	self.VoteUp:SetImage("theater/up.png")
	self.VoteUp.DoClick = function()
		RunConsoleCommand("cinema_upvote", self.Video:GetId())

		if IsValid(self) then
			self:Update()

			local queue = self:GetParent():GetParent()
			queue.NextUpdate = (queue.NextUpdate or RealTime()) + 2 -- avoid race conditions with networking
		end
	end
	self.VoteUp.Think = function()
		if IsValid(self.Video) and LocalPlayer():GetVideoVote(self.Video:GetId()) > 0 then
			self.VoteUp:SetColor(Color(0, 255, 0))
		else
			self.VoteUp:SetColor(Color(255, 255, 255))
		end
	end

	self.VoteDown = vgui.Create("DImageButton", self)
	self.VoteDown:SetSize(16, 16)
	self.VoteDown:SetImage("theater/down.png")
	self.VoteDown.DoClick = function()
		RunConsoleCommand("cinema_downvote", self.Video:GetId())

		if IsValid(self) then
			self:Update()

			local queue = self:GetParent():GetParent()
			queue.NextUpdate = (queue.NextUpdate or RealTime()) + 2
		end
	end
	self.VoteDown.Think = function()
		if IsValid(self.Video) and LocalPlayer():GetVideoVote(self.Video:GetId()) < 0 then
			self.VoteDown:SetColor(Color(255, 0, 0))
		else
			self.VoteDown:SetColor(Color(255, 255, 255))
		end
	end

	self.RemoveBtn = vgui.Create("DImageButton", self)
	self.RemoveBtn:SetSize(16, 16)
	self.RemoveBtn:SetImage("theater/trashbin.png")
	self.RemoveBtn:SetVisible(false)
	self.RemoveBtn.DoClick = function()
		RunConsoleCommand("cinema_video_remove", self.Video:GetId())

		if IsValid(self) then
			local queue = self:GetParent():GetParent()
			queue:RemoveVideo(self.Video)
		end
	end
	self.RemoveBtn.Think = function()
		local Theater = LocalPlayer():GetTheater()
		if self.Video.Owner or LocalPlayer():IsAdmin() or
			(Theater and Theater:IsPrivate() and Theater:GetOwner() == LocalPlayer()) then
			self.RemoveBtn:SetVisible(true)
		else
			self.RemoveBtn:SetVisible(false)
		end
	end
end

function VIDEOVOTE:SetVideo(vid)
	self.Video = vid
	self:Update()
end

function VIDEOVOTE:Update()
	if not self.Video then return end
	self.Votes:SetText(self.Video:GetVotes())
	self:InvalidateLayout()
end

function VIDEOVOTE:PerformLayout()
	self.VoteUp:AlignTop(self.Padding)
	self.Votes:SizeToContents()

	if self.RemoveBtn:IsVisible() then
		self.VoteUp:CenterHorizontal(0.25)
		self.Votes:CenterHorizontal()
		self.VoteDown:CenterHorizontal(0.75)
		self.RemoveBtn:AlignRight()
	else
		self.VoteUp:CenterHorizontal(1 / 3)
		self.Votes:CenterHorizontal()
		self.VoteDown:CenterHorizontal(2 / 3)
	end

	self.VoteDown:AlignBottom(self.Padding)
	self.RemoveBtn:AlignBottom(self.Padding)

	self:SetSize(64, 32 + self.Padding * 2)
end

vgui.Register("ScoreboardVideoVote", VIDEOVOTE)

-- Alias used by older layouts
local VIDEOCONTROLS = table.Copy(VIDEOVOTE)

function VIDEOCONTROLS:Init()
	VIDEOVOTE.Init(self)
end

function VIDEOCONTROLS:SetVideo(vid)
	self.Video = vid
	self:Update()
end

function VIDEOCONTROLS:Update()
	if not self.Video then return end
	self.Votes:SetText(self.Video:GetVotes())

	local Theater = LocalPlayer():GetTheater()
	if self.Video.Owner or LocalPlayer():IsAdmin() or
		(Theater and Theater:IsPrivate() and Theater:GetOwner() == LocalPlayer()) then
		self.RemoveBtn:SetVisible(true)
	else
		self.RemoveBtn:SetVisible(false)
	end

	self:InvalidateLayout()
end

vgui.Register("ScoreboardVideoControls", VIDEOCONTROLS)
