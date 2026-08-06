surface.CreateFont("ScoreboardVidTitle", { font = "Open Sans Condensed", size = 20, weight = 200 })
surface.CreateFont("ScoreboardVidDuration", { font = "Open Sans", size = 14, weight = 200 })
surface.CreateFont("ScoreboardVidVotes", { font = "Open Sans Condensed", size = 18, weight = 200 })

local ADMIN = {}
ADMIN.TitleHeight = 64
ADMIN.VidHeight = 32 -- 48

function ADMIN:Init()
	local Theater = LocalPlayer():GetTheater()

	self:SetZPos(1)
	self:SetSize(256, 512)
	self:SetPos(ScrW() - (256 + 8), ScrH() / 2 - (self:GetTall() / 2))

	self.Title = Label("", self)
	self.Title:SetFont("ScoreboardTitle")
	self.Title:SetColor(Color(255, 255, 255))

	self.NextUpdate = 0.0

	self.Options = vgui.Create("DPanelList", self)
	self.Options:DockMargin(0, self.TitleHeight + 2, 0, 0)
	self.Options:SetPaintBackground(false)
	self.Options:SetPadding(4)
	self.Options:SetSpacing(4)

	if Theater and theater.IsVideoTimed(Theater._Video._VideoType) then
		-- SeekBox Panel
		local SeekBox = vgui.Create("TheaterSeekBox", self)
		self.Options:AddItem(SeekBox)

		local SeekButtons = vgui.Create("TheaterSeekButtons", self)
		self.Options:AddItem(SeekButtons)
	end

	-- Skip the current video
	local VoteSkipButton = vgui.Create("TheaterButton")
	VoteSkipButton:SetText(translations:Format("Theater_Skip"))
	VoteSkipButton.DoClick = function(self)
		RunConsoleCommand("cinema_forceskip")
	end
	self.Options:AddItem(VoteSkipButton)

	-- Play / Pause the current video (timed videos only)
	if Theater and theater.IsVideoTimed(Theater._Video._VideoType) then
		local PauseButton = vgui.Create("TheaterButton")
		PauseButton:SetText(translations:Format(Theater:IsPaused() and "Theater_Resume" or "Theater_Pause"))
		PauseButton.DoClick = function(self)
			RunConsoleCommand("cinema_pause")
		end
		self.PauseButton = PauseButton
		self.Options:AddItem(PauseButton)
	end

	-- Admin-only options
	if LocalPlayer():IsAdmin() then
		-- Reset the theater
		local ResetButton = vgui.Create("TheaterButton")
		ResetButton:SetText(translations:Format("Theater_Reset"))
		ResetButton.DoClick = function(self)
			RunConsoleCommand("cinema_reset")
		end
		self.Options:AddItem(ResetButton)
	end

	-- Private theater options
	if Theater and Theater:IsPrivate() then
		local NameButton = vgui.Create("TheaterButton")
		NameButton:SetText(translations:Format("Theater_ChangeName"))
		NameButton.DoClick = function(self)
			Derma_StringRequest(translations:Format("Theater_ChangeName"),
				"",
				Theater:Name(),
				function(strTextOut) RunConsoleCommand("cinema_name", strTextOut) end,
				function(strTextOut) end,
				translations:Format("Set"),
				translations:Format("Cancel"))
		end
		self.Options:AddItem(NameButton)

		local LockButton = vgui.Create("TheaterButton")
		LockButton:SetText(translations:Format("Theater_QueueLock"))
		LockButton.DoClick = function(self)
			RunConsoleCommand("cinema_lock")
		end
		self.Options:AddItem(LockButton)

		-- Rent owner controls (integrated from Theater Rentals)
		self.voteSkipLock = vgui.Create("TheaterButton")
		self.voteSkipLock:SetText(translations:Format("Rent_ToggleVoteSkipLock"))
		self.voteSkipLock.DoClick = function()
			rent.ToggleVoteSkipLock()
		end
		self.Options:AddItem(self.voteSkipLock)

		self.playerFilter = vgui.Create("TheaterButton")
		self.playerFilter:SetText(translations:Format("Rent_PlayerFilter"))
		self.playerFilter.DoClick = function()
			rent.CreatePlayerFilterWindow()
		end
		self.Options:AddItem(self.playerFilter)

		self.extendRent = vgui.Create("TheaterButton")
		self.extendRent:SetText(translations:Format("Rent_AddRentTime"))
		self.extendRent.DoClick = function()
			rent.CreateRentWindow()
		end
		self.Options:AddItem(self.extendRent)

		self.refundRent = vgui.Create("TheaterButton")
		self.refundRent:SetText(translations:Format("Rent_RefundButton"))
		self.refundRent.DoClick = function()
			rent.RefundRent()
		end
		self.Options:AddItem(self.refundRent)

		-- Admin-only control to cancel (refund) another player's rent
		self.cancelRent = vgui.Create("TheaterButton")
		self.cancelRent:SetText(translations:Format("Rent_CancelButton"))
		self.cancelRent.DoClick = function()
			rent.CancelRent()
		end
		self.cancelRent:SetVisible(false)
		self.Options:AddItem(self.cancelRent)

		if Theater:GetOwner() ~= LocalPlayer() then
			self.voteSkipLock:SetVisible(false)
			self.playerFilter:SetVisible(false)
			self.extendRent:SetVisible(false)
			self.refundRent:SetVisible(false)
		end

		self.remainingRentTimeLbl = vgui.Create("DLabel", self)
		self.remainingRentTimeLbl:SetFont("ScoreboardVidDuration")
		self.remainingRentTimeLbl:SetText(translations:Format("Rent_Remaining"))
		self.remainingRentTimeLbl:SetColor(Color(255, 255, 255))
		self.remainingRentTimeLbl:SizeToContents()
		self.remainingRentTimeLbl:SetPos(0, self:GetTall() - self.remainingRentTimeLbl:GetTall() - 5)
		self.remainingRentTimeLbl:CenterHorizontal()

		self.remainingRentTime = vgui.Create("DLabel", self)
		self.remainingRentTime:SetFont("ScoreboardVidTitle")
		self.remainingRentTime:SetColor(Color(255, 255, 255))
		self.remainingRentTime:SetText("00:00:00")
		self.remainingRentTime.Think = function(lbl)
			lbl:SetText(rent.SecondsToTimer(rent.GetTimeRemaining(Theater:GetLocation())))
		end
	end
end

function ADMIN:Update()
	local Theater = LocalPlayer():GetTheater() -- get player's theater from their location
	if not Theater then return end

	if IsValid(self.PauseButton) then
		self.PauseButton:SetText(translations:Format(Theater:IsPaused() and "Theater_Resume" or "Theater_Pause"))
	end

	-- Change title text
	if Theater:IsPrivate() and Theater:GetOwner() == LocalPlayer() then
		self.Title:SetText(translations:Format("Theater_Owner"))
	elseif LocalPlayer():IsAdmin() then
		self.Title:SetText(translations:Format("Theater_Admin"))
	end

	-- Toggle rent owner controls based on ownership
	if Theater:IsPrivate() and IsValid(self.voteSkipLock) then
		local isOwner = Theater:GetOwner() == LocalPlayer()
		self.voteSkipLock:SetVisible(isOwner)
		self.playerFilter:SetVisible(isOwner)
		self.extendRent:SetVisible(isOwner)
		self.refundRent:SetVisible(isOwner)

		if IsValid(self.remainingRentTime) then
			self.remainingRentTime:SetVisible(isOwner)
			self.remainingRentTimeLbl:SetVisible(isOwner)
		end
	end

	-- Admins (who are not the owner) can cancel an active rent
	if IsValid(self.cancelRent) then
		local canCancel = LocalPlayer():IsAdmin()
			and Theater:IsPrivate()
			and IsValid(Theater:GetOwner())
			and Theater:GetOwner() ~= LocalPlayer()
		self.cancelRent:SetVisible(canCancel)
	end
end

function ADMIN:Think()
	if RealTime() > self.NextUpdate then
		self:Update()
		self:InvalidateLayout()
		self.NextUpdate = RealTime() + 3.0
	end
end

local Background = Material("theater/banner.png")

function ADMIN:Paint(w, h)
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

function ADMIN:PerformLayout()
	self.Title:SizeToContents()
	self.Title:SetTall(self.TitleHeight)
	self.Title:CenterHorizontal()

	if self.Title:GetWide() > self:GetWide() and self.Title:GetFont() ~= "ScoreboardTitleSmall" then
		self.Title:SetFont("ScoreboardTitleSmall")
	end

	self.Options:Dock(FILL)
	self.Options:SizeToContents()

	-- Position the rent remaining timer above its label
	if IsValid(self.remainingRentTime) then
		self.remainingRentTime:SizeToContents()
		self.remainingRentTime:SetPos(0,
			select(2, self.remainingRentTimeLbl:GetPos()) - self.remainingRentTime:GetTall())
		self.remainingRentTime:CenterHorizontal()
	end
end

vgui.Register("ScoreboardAdmin", ADMIN)