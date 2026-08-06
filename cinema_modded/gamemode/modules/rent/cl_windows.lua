module("rent", package.seeall)

local CloseTexture = Material("theater/close.png")
local TitleBackground = Material("theater/banner.png")

-- Base window panel

local WINDOW = {}

function WINDOW:Init()
	self:SetFocusTopLevel(true)

	self.titleHeight = 36

	self.title = vgui.Create("DLabel", self)
	self.title:SetFont("ScoreboardTitleSmall")
	self.title:SetColor(Color(255, 255, 255))
	self.title:SetText("Window")

	self.closeButton = vgui.Create("DButton", self)
	self.closeButton:SetZPos(5)
	self.closeButton:NoClipping(true)
	self.closeButton:SetText("")
	self.closeButton.DoClick = function()
		self:Remove()
	end
	self.closeButton.Paint = function(btn, w, h)
		DisableClipping(true)

		surface.SetDrawColor(48, 55, 71)
		surface.DrawRect(2, 2, w - 4, h - 4)

		surface.SetDrawColor(26, 30, 38)
		surface.SetMaterial(CloseTexture)
		surface.DrawTexturedRect(0, 0, w, h)

		DisableClipping(false)
	end
end

function WINDOW:SetTitle(title)
	self.title:SetText(title)
end

function WINDOW:PerformLayout()
	self.title:SizeToContents()
	self.title:SetTall(self.titleHeight)
	self.title:SetPos(1, 1)
	self.title:CenterHorizontal()

	self.closeButton:SetSize(32, 32)
	self.closeButton:SetPos(self:GetWide() - 34, 2)
end

function WINDOW:Paint(w, h)
	surface.SetDrawColor(26, 30, 38, 255)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(141, 38, 33, 255)
	surface.DrawRect(0, 0, w, self.title:GetTall())

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(TitleBackground)
	surface.DrawTexturedRect(0, -1, 512, self.title:GetTall() + 1)
	if w > 512 then
		surface.DrawTexturedRect(460, -1, 512, self.title:GetTall() + 1)
	end
end

vgui.Register("CinemaRentalsWindow", WINDOW, "Panel")

-- Rent window

function CreateRentWindow()
	local window = vgui.Create("CinemaRentalsWindow")
	window:SetSize(450, 125)
	window:SetTitle(translations:Format("Rent_RentTheater"))

	local slider = vgui.Create("TheaterNumSlider", window)
	slider:SetText(translations:Format("Rent_Minutes"))
	slider:SetMinMax(0, rent.MaximumRentTime())
	slider:SetDecimals(0)
	slider:SetWidth(window:GetWide() - (19 * 2))
	slider:SetTall(50)
	slider:SetPos(0, window.titleHeight + 10)
	slider:CenterHorizontal()

	local rentButton = vgui.Create("TheaterButton", window)
	rentButton:SetText(translations:Format("Rent_Purchase"))
	rentButton:SetSize(window:GetWide() - 8, 25)
	rentButton:SetPos(0, window:GetTall() - rentButton:GetTall() - 4)
	rentButton:CenterHorizontal()

	rentButton.DoClick = function()
		local value = slider:GetValue()
		if value >= rent.MinimumRentTime() then
			rent.RentTheater(nil, value)
		else
			chat.AddText(unpack(translations:FormatChat("Rent_MinTime", rent.MinimumRentTime())))
		end
		window:Remove()
	end

	local lastValue = 0
	slider.Think = function(pnl)
		local value = pnl:GetValue()

		if value ~= lastValue then
			lastValue = value
			local cost = value * rent.CostPerMinute()
			rentButton:SetText(translations:Format("Rent_PurchaseFor", rent.FormatCost(cost, LocalPlayer())))
		end
	end

	window:Center()
	window:MakePopup()
end

-- Player filter window

function CreatePlayerFilterWindow()
	local window = vgui.Create("CinemaRentalsWindow")
	window:SetSize(800, 600)
	window:SetTitle(translations:Format("Rent_PlayerFilter"))

	window.whitelistButton = vgui.Create("TheaterButton", window)
	window.whitelistButton:SetText(translations:Format("Rent_WhitelistMode"))
	window.whitelistButton:SetSize(window:GetWide() - 8, 25)
	window.whitelistButton:SetPos(4, window.titleHeight + 4)
	window.whitelistButton:SetVisible(false)
	window.whitelistButton.whitelistMode = true
	window.whitelistButton.DoClick = function(self)
		if self.whitelistMode then
			self:SetText(translations:Format("Rent_BlacklistMode"))
			self.whitelistMode = false
		else
			self:SetText(translations:Format("Rent_WhitelistMode"))
			self.whitelistMode = true
		end
	end

	window.applyButton = vgui.Create("TheaterButton", window)
	window.applyButton:SetText(translations:Format("Rent_Apply"))
	window.applyButton:SetSize(window:GetWide() - 8, 25)
	window.applyButton:SetPos(4, window:GetTall() - window.applyButton:GetTall() - 4)
	window.applyButton:SetVisible(false)

	window.playerList = vgui.Create("TheaterList", window)
	window.playerList:SetPos(4, window.titleHeight + window.whitelistButton:GetTall() + 8)
	window.playerList:SetSize(window:GetWide() - 8,
		window:GetTall() - window.titleHeight - window.whitelistButton:GetTall() - window.applyButton:GetTall() - 16)
	window.playerList:SetVisible(false)

	window.applyButton.DoClick = function()
		local filterData = {}
		filterData.whitelistMode = window.whitelistButton.whitelistMode
		filterData.players = {}

		for _, pnl in pairs(window.playerList:GetItems()) do
			if pnl:IsSelected() then
				table.insert(filterData.players, pnl:GetPlayer():SteamID())
			end
		end

		rent.SetPlayerFilter(filterData)

		window:Remove()
	end

	for _, ply in ipairs(player.GetAll()) do
		if ply ~= LocalPlayer() then
			local pnl = vgui.Create("FilterPlayer", window.playerList)
			pnl:SetPlayer(ply)
			pnl:SetVisible(true)
			window.playerList:AddItem(pnl)
		end
	end

	window.loadingText = vgui.Create("DLabel", window)
	window.loadingText:SetFont("ScoreboardTitle")
	window.loadingText:SetColor(Color(255, 255, 255))
	window.loadingText:SetText(translations:Format("Rent_Retrieving"))
	window.loadingText:SizeToContents()
	window.loadingText:Center()

	window:Center()
	window:MakePopup()

	rent.PlayerFilterWindow = window
	rent.RequestPlayerFilter()
end

-- Filter player row panel

local PLAYER = {}
PLAYER.Padding = 8

function PLAYER:Init()
	self:SetTall(48)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:SetCursor("hand")

	self.Name = Label(translations:Format("Rent_Unknown"), self)
	self.Name:SetFont("ScoreboardName")
	self.Name:SetColor(Color(255, 255, 255))

	self.Location = Label(translations:Format("Rent_Unknown"), self)
	self.Location:SetFont("ScoreboardLocation")
	self.Location:SetColor(Color(255, 255, 255, 80))
	self.Location:SetPos(0, 8)

	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetSize(32, 32)
	self.Avatar:SetZPos(1)
	self.Avatar:SetVisible(false)
	self.Avatar:SetMouseInputEnabled(false)

	self.CheckBox = vgui.Create("DCheckBox", self)
end

function PLAYER:UpdatePlayer()
	if not IsValid(self.Player) then
		local parent = self:GetParent()
		if ValidPanel(parent) and parent.RemovePlayer then
			parent:RemovePlayer(self.Player)
		end

		return
	end

	self.Name:SetText(self.Player:Name())
	self.Location:SetText(string.upper(self.Player:GetLocationName() or translations:Format("Rent_Unknown")))
end

function PLAYER:SetPlayer(ply)
	self.Player = ply

	self.Avatar:SetPlayer(ply, 64)
	self.Avatar:SetVisible(true)

	self:UpdatePlayer()
end

function PLAYER:GetPlayer()
	return self.Player
end

function PLAYER:IsSelected()
	return self.CheckBox:GetChecked()
end

function PLAYER:SetSelected(selected)
	self.CheckBox:SetChecked(selected)
end

function PLAYER:OnMouseReleased()
	self.CheckBox:SetChecked(not self.CheckBox:GetChecked())
end

function PLAYER:PerformLayout()
	self.Name:SizeToContents()
	self.Name:AlignTop(self.Padding - 2)
	self.Name:AlignLeft(self.Avatar:GetWide() + 16)

	self.Location:SizeToContents()
	self.Location:AlignTop(self.Name:GetTall() + 5)
	self.Location:AlignLeft(self.Avatar:GetWide() + 16)

	self.Avatar:SizeToContents()
	self.Avatar:AlignTop(self.Padding)
	self.Avatar:AlignLeft(self.Padding)
	self.Avatar:CenterVertical()

	self.CheckBox:SetPos(self:GetWide() - self.Padding - self.CheckBox:GetWide(), 1)
	self.CheckBox:CenterVertical()
end

local GMDevIcon = Material( "theater/gmdevicon.png" )
local AdminIcon = Material("theater/adminicon.png")

function PLAYER:Paint(w, h)
	surface.SetDrawColor(38, 41, 49, 255)
	surface.DrawRect(0, 0, self:GetSize())
	surface.SetDrawColor(255, 255, 255, 255)

	if not self.Player then return end

	if self.Player.IsGamemodeDev and self.Player:IsGamemodeDev() then
		surface.SetMaterial(GMDevIcon)
		surface.DrawTexturedRect(self.Name.x + self.Name:GetWide() + 5, self.Name.y + 3, 40, 16)
	elseif self.Player:IsAdmin() then
		surface.SetMaterial(AdminIcon)
		surface.DrawTexturedRect(self.Name.x + self.Name:GetWide() + 5, self.Name.y + 3, 40, 16)
	end
end

vgui.Register("FilterPlayer", PLAYER)
