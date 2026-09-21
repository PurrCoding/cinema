surface.CreateFont("ScoreboardVidTitle", { font = "Open Sans Condensed", size = 20, weight = 200 })
surface.CreateFont("ScoreboardVidDuration", { font = "Open Sans", size = 14, weight = 200 })
surface.CreateFont("ScoreboardVidVotes", { font = "Open Sans Condensed", size = 18, weight = 200 })

local QUEUE = {}
QUEUE.TitleHeight = 64
QUEUE.VidHeight = 32 -- 48

function QUEUE:Init()
	self:SetZPos(1)
	self:SetSize(256, 512)
	self:SetPos(8, ScrH() / 2 - (self:GetTall() / 2))

	self.Title = Label(translations:Format("Queue_Title"), self)
	self.Title:SetFont("ScoreboardTitle")
	self.Title:SetColor(Color(255, 255, 255))

	self.Videos = {}
	self.NextUpdate = 0.0

	self.VideoList = vgui.Create("TheaterList", self)
	self.VideoList:DockMargin(0, self.TitleHeight + 2, 0, 0)

	self.Options = vgui.Create("DPanelList", self)
	self.Options:SetPaintBackground(false)
	self.Options:SetPadding(4)
	self.Options:SetSpacing(4)

	-- Theater Options

	-- Volume slider (top of the options list)
	local VolumeSlider = vgui.Create("TheaterNumSlider")
	VolumeSlider:SetText(translations:Format("Volume"))
	VolumeSlider:SetConVar("cinema_volume")
	VolumeSlider:SetMinMax(0, 100)
	VolumeSlider:SetDecimals(0)
	VolumeSlider:SetTall(35)
	self.Options:AddItem(VolumeSlider)

	local RequestButton = vgui.Create("TheaterButton")
	RequestButton:SetText(translations:Format("Request_Video"))
	RequestButton.DoClick = function(self)
		local RequestFrame = vgui.Create("VideoRequestFrame")
		if IsValid(RequestFrame) then
			RequestFrame:Center()
			RequestFrame:MakePopup()
		end
	end
	self.Options:AddItem(RequestButton)

	local VoteSkipButton = vgui.Create("TheaterButton")
	VoteSkipButton:SetText(translations:Format("Vote_Skip"))
	VoteSkipButton.DoClick = function(self)
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
			return a.Id < b.Id
		end)
	else
		self.VideoList:SortVideos(function(a, b)
			if a.Votes == b.Votes then
				return a.Id < b.Id
			else
				return a.Votes > b.Votes
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
	-- Background
	surface.SetDrawColor(26, 30, 38, 255)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

	-- Title
	surface.SetDrawColor(141, 38, 33, 255)
	surface.DrawRect(0, 0, self:GetWide(), self.Title:GetTall())

	-- Title Background
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
	self.Options:SizeToContents()
end

vgui.Register("ScoreboardQueue", QUEUE)


local VIDEO = {}
VIDEO.Padding = 8

function VIDEO:Init()
	self:SetTall(QUEUE.VidHeight)

	self.Title = Label("Unknown", self)
	self.Title:SetFont("ScoreboardVidTitle")
	self.Title:SetColor(Color(255, 255, 255))

	self.Duration = Label("0:00", self)
	self.Duration:SetFont("ScoreboardVidDuration")
	self.Duration:SetColor(Color(255, 255, 255))

	local QueueMode = theater.GetQueueMode()

	if theater.IsVoteQueueMode() then
		-- Mode 1 (upvote only) and mode 3 (up/down)
		self.Controls = vgui.Create("ScoreboardVideoVote", self)
	elseif QueueMode == QUEUE_CHRONOLOGICAL then
		self.Controls = vgui.Create("ScoreboardVideoControls", self)
	end
end

function VIDEO:Update()
	self.Title:SetText(self.Video.Title)
	self:SetTooltip(self.Video.Title)
	self.Duration:SetText(string.FormatSeconds(self.Video.Duration))
	if IsValid(self.Controls) then
		self.Controls:Update()
	end
end

function VIDEO:SetVideo(vid)
	self.Video = vid
	if IsValid(self.Controls) then
		self.Controls:SetVideo(vid)
	end
	self:Update()
end

function VIDEO:PerformLayout()
	if not IsValid(self.Controls) then return end

	self.Controls:SizeToContents()
	self.Controls:CenterVertical()
	self.Controls:AlignRight(self.Padding)

	local x, y = self.Controls:GetPos()

	self.Title:SizeToContents()
	local w = self.Title:GetWide()

	-- Clip video title for voting controls
	w = math.Clamp(w, 0, x - self.Padding * 2)

	self.Title:SetSize(w, self.Title:GetTall())

	self.Title:AlignTop(-2)
	self.Title:AlignLeft(self.Padding)

	self.Duration:SizeToContents()
	self.Duration:AlignTop(self.Title:GetTall() - 4)
	self.Duration:AlignLeft(self.Padding)
end

function VIDEO:Paint(w, h)
	surface.SetDrawColor(38, 41, 49, 255)
	surface.DrawRect(0, 0, self:GetSize())
end

vgui.Register("ScoreboardVideo", VIDEO)


local VIDEOVOTE = {}
VIDEOVOTE.Padding = 4

function IsMouseOver(self)
	local x, y = self:CursorPos()
	return x >= 0 and y >= 0 and x <= self:GetWide() and y <= self:GetTall()
end

function VIDEOVOTE:Init()
	self.Votes = Label("0", self)
	self.Votes:SetFont("ScoreboardVidVotes")
	self.Votes:SetWide(18)
	self.Votes:SetContentAlignment(5) -- middle
	self.Votes:SetColor(Color(255, 255, 255))

	self.VoteUp = vgui.Create("DImageButton", self)
	self.VoteUp:SetSize(16, 16)
	self.VoteUp:SetImage("theater/up.png")
	self.VoteUp.DoClick = function()
		self:CastVote(true)
	end
	self.VoteUp.Think = function()
		if IsMouseOver(self.VoteUp) or self.VoteUp.Voted then
			self.VoteUp:SetAlpha(255)
		else
			self.VoteUp:SetAlpha(25)
		end
	end

	self.VoteDown = vgui.Create("DImageButton", self)
	self.VoteDown:SetSize(16, 16)
	self.VoteDown:SetImage("theater/down.png")
	self.VoteDown.DoClick = function()
		self:CastVote(false)
	end
	self.VoteDown.Think = function()
		if IsMouseOver(self.VoteDown) or self.VoteDown.Voted then
			self.VoteDown:SetAlpha(255)
		else
			self.VoteDown:SetAlpha(25)
		end
	end
end

-- Optimistic local update + server command (matches original 2014 vote toggle semantics)
function VIDEOVOTE:CastVote(positive)
	if not self.Video then return end
	if not positive and not theater.AllowsDownvote() then return end

	local cmd = positive and "cinema_voteup" or "cinema_votedown"
	RunConsoleCommand(cmd, self.Video.Id)

	if self.Video.Value then
		if (self.Video.Value > 0 and positive) or (self.Video.Value < 0 and not positive) then
			-- Toggle off same direction
			self.Video.Votes = self.Video.Votes - self.Video.Value
			self.Video.Value = nil
		else
			-- Switch direction: remove old contribution, add new
			self.Video.Votes = self.Video.Votes - self.Video.Value + (positive and 1 or -1)
			self.Video.Value = positive and 1 or -1
		end
	else
		self.Video.Value = positive and 1 or -1
		self.Video.Votes = self.Video.Votes + self.Video.Value
	end

	self:Update()

	local queue = self:GetParent():GetParent()
	if IsValid(queue) then
		queue.NextUpdate = (queue.NextUpdate or RealTime()) + 2 -- avoid race conditions with networking
	end
end

function VIDEOVOTE:AddRemoveButton()
	if IsValid(self.RemoveBtn) then return end

	self.RemoveBtn = vgui.Create("DImageButton", self)
	self.RemoveBtn:SetSize(16, 16)
	self.RemoveBtn:SetImage("theater/trashbin.png")
	self.RemoveBtn.DoClick = function()
		RunConsoleCommand("cinema_video_remove", self.Video.Id)
		if IsValid(GuiQueue) then
			GuiQueue:RemoveVideo(self.Video)
		end
	end
	self.RemoveBtn.Think = function()
		if IsMouseOver(self.RemoveBtn) or self.RemoveBtn.Voted then
			self.RemoveBtn:SetAlpha(255)
			self.RemoveBtn:SetColor(Color(255, 0, 0))
		else
			self.RemoveBtn:SetAlpha(25)
			self.RemoveBtn:SetColor(Color(255, 255, 255))
		end
	end
end

function VIDEOVOTE:Vote(up)
	if up == true then
		self.VoteUp:SetColor(Color(0, 255, 0))
		self.VoteUp.Voted = true
		self.VoteDown:SetColor(Color(255, 255, 255))
		self.VoteDown.Voted = nil
	elseif up == false then
		self.VoteUp:SetColor(Color(255, 255, 255))
		self.VoteUp.Voted = nil
		self.VoteDown:SetColor(Color(255, 0, 0))
		self.VoteDown.Voted = true
	else
		self.VoteUp:SetColor(Color(255, 255, 255))
		self.VoteUp.Voted = nil
		self.VoteDown:SetColor(Color(255, 255, 255))
		self.VoteDown.Voted = nil
	end

	hook.Run("OnVideoVote")
end

function VIDEOVOTE:Update()
	if not self.Video then return end

	self.Votes:SetText(self.Video.Votes)

	if self.Video.Value then
		if self.Video.Value > 0 then
			self:Vote(true)
		elseif self.Video.Value < 0 then
			self:Vote(false)
		end
	else
		self:Vote(nil)
	end

	-- Show down-arrow only in mode 3
	local allowDown = theater.AllowsDownvote()
	if IsValid(self.VoteDown) then
		self.VoteDown:SetVisible(allowDown)
	end

	local Theater = LocalPlayer():GetTheater()
	local canRemove = self.Video.Owner or LocalPlayer():IsAdmin() or
		(Theater and Theater:IsPrivate() and Theater:GetOwner() == LocalPlayer())

	if canRemove then
		self:AddRemoveButton()
		self:SetWide(allowDown and 72 or 54)
	else
		if IsValid(self.RemoveBtn) then
			self.RemoveBtn:SetVisible(false)
		end
		self:SetWide(allowDown and 52 or 34)
	end
end

function VIDEOVOTE:SetVideo(vid)
	self.Video = vid
	self:Update()
end

function VIDEOVOTE:PerformLayout()
	-- Horizontal layout fits original VidHeight = 32:
	-- [up] [votes] [down?] [trash?]
	self.VoteUp:CenterVertical()
	self.VoteUp:AlignLeft(0)

	self.Votes:CenterVertical()
	self.Votes:MoveRightOf(self.VoteUp, 2)

	if IsValid(self.VoteDown) and self.VoteDown:IsVisible() then
		self.VoteDown:CenterVertical()
		self.VoteDown:MoveRightOf(self.Votes, 2)
	end

	if IsValid(self.RemoveBtn) and self.RemoveBtn:IsVisible() then
		self.RemoveBtn:CenterVertical()
		self.RemoveBtn:AlignRight(0)
	end
end

vgui.Register("ScoreboardVideoVote", VIDEOVOTE)


local VIDEOCONTROLS = {}
VIDEOCONTROLS.Padding = 8

function VIDEOCONTROLS:Init()

end

function VIDEOCONTROLS:AddRemoveButton()
	if IsValid(self.RemoveBtn) then return end

	self.RemoveBtn = vgui.Create("DImageButton", self)
	self.RemoveBtn:SetSize(16, 16)
	self.RemoveBtn:SetImage("theater/trashbin.png")
	self.RemoveBtn.DoClick = function()
		RunConsoleCommand("cinema_video_remove", self.Video.Id)
		if IsValid(GuiQueue) then
			GuiQueue:RemoveVideo(self.Video)
		end
	end
	self.RemoveBtn.Think = function()
		if IsMouseOver(self.RemoveBtn) or self.RemoveBtn.Voted then
			self.RemoveBtn:SetAlpha(255)
			self.RemoveBtn:SetColor(Color(255, 0, 0))
		else
			self.RemoveBtn:SetAlpha(25)
			self.RemoveBtn:SetColor(Color(255, 255, 255))
		end
	end
end

function VIDEOCONTROLS:Update()
	if not self.Video then return end

	local Theater = LocalPlayer():GetTheater()
	if self.Video.Owner or LocalPlayer():IsAdmin() or
		(Theater and Theater:IsPrivate() and Theater:GetOwner() == LocalPlayer()) then
		self:AddRemoveButton()
		self:SetWide(16)
	else
		self:SetWide(0)
	end
end

function VIDEOCONTROLS:SetVideo(vid)
	self.Video = vid
	self:Update()
end

function VIDEOCONTROLS:PerformLayout()
	if IsValid(self.RemoveBtn) then
		self.RemoveBtn:Center()
		self.RemoveBtn:AlignRight()
	end
end

vgui.Register("ScoreboardVideoControls", VIDEOCONTROLS)
