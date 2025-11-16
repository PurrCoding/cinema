
surface.CreateFont( "ScoreboardHelp", { font = "Open Sans Condensed Light", size = 20, weight = 100 } )
surface.CreateFont( "ScoreboardHelpSmall", { font = "Open Sans Condensed Light", size = 18, weight = 100 } )

SETTINGS = {}
SETTINGS.TitleHeight = 88

function SETTINGS:Init()

	self.Title = Label( translations:Format("Settings_Title"), self )
	self.Title:SetFont( "ScoreboardTitleSmall" )
	self.Title:SetColor( Color( 255, 255, 255 ) )

	self.Help = Label( translations:Format("Settings_ClickActivate"), self )
	self.Help:SetFont( "ScoreboardHelp" )
	self.Help:SetColor( Color( 255, 255, 255, 150 ) )

	self.Settings = {}

	self:Create()

end

function SETTINGS:NewSetting( control, text, convar )

	local Control = vgui.Create( control, self )
	Control:SetText( text or "" )
	Control:SetWidth( 300 )

	if convar then
		Control:SetConVar( convar )
	end

	if not table.HasValue( self.Settings, Control ) then
		table.insert( self.Settings, Control )
	end

	return Control

end

local Background = Material( "theater/settingsbright.png" )

function SETTINGS:Paint( w, h )

	--Render the background
	surface.SetDrawColor( 62, 16, 15, 255 )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	--Background image
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Background )
	surface.DrawTexturedRect( 0, self:GetTall() - 680, 256, 680 )

end

function SETTINGS:Think()

	if IsValid( Gui ) then
		self.Help:SetVisible( not Gui.MouseEnabled )
	end

end

function SETTINGS:PerformLayout()

	local curY = self.TitleHeight + 40

	for _, panel in pairs( self.Settings ) do

		panel:InvalidateLayout()
		curY = curY + 28

		-- Resize label if needed for localization
		if IsValid( panel.Label ) and panel.Label:GetFont() ~= "ScoreboardHelpSmall" then

			local px, py = panel:GetPos()

			local x, y = panel.Label:GetPos()
			local w, h = panel.Label:GetSize()

			if ( px + x + w ) > self:GetWide() then
				panel.Label:SetFont( "ScoreboardHelpSmall" )
				panel.Label:SizeToContents()
			end

		end

	end

	self:SetTall( curY )

	self.Title:SizeToContents()
	self.Title:SetTall( self.TitleHeight - 14 )
	self.Title:CenterHorizontal()

	self.Help:SizeToContents()
	self.Help:CenterHorizontal()
	self.Help:AlignBottom( 10 )

	if self.Help:GetWide() > self:GetWide() and self.Help:GetFont() ~= "ScoreboardHelpSmall" then
		self.Help:SetFont( "ScoreboardHelpSmall" )
	end

end

function SETTINGS:Create()

	-- Volume slider
	local Volume = self:NewSetting( "TheaterNumSlider", translations:Format("Volume"), "cinema_volume" )
	Volume:SetTooltip( translations:Format("Settings_VolumeTooltip") )
	Volume:SetMinMax( 0, 100 )
	Volume:SetDecimals( 0 )
	Volume:SetWide( 256 - 32 )
	Volume:SetTall( 50 )
	Volume:AlignLeft( 16 )
	Volume:AlignTop( self.TitleHeight - 20 )

	-- Video Smoother
	local VideoSmoother = self:NewSetting( "TheaterCheckBoxLabel", translations:Format("Settings_SmoothVideoLabel"), "cinema_smoother" )
	VideoSmoother:SetTooltip( translations:Format("Settings_SmoothVideoTooltip") )
	VideoSmoother:AlignLeft( 16 )
	VideoSmoother:AlignTop( self.TitleHeight + 34 )
	VideoSmoother.Label:SetFont( "LabelFont" )
	VideoSmoother.Label:SetColor( color_white )
	VideoSmoother.Label:SetTall(50)

	-- Hide Players
	local HidePlayers = self:NewSetting( "TheaterCheckBoxLabel", translations:Format("Settings_HidePlayersLabel"), "cinema_hideplayers" )
	HidePlayers:SetTooltip( translations:Format("Settings_HidePlayersTooltip") )
	HidePlayers:AlignLeft( 16 )
	HidePlayers:AlignTop( self.TitleHeight + 64 )
	HidePlayers.Label:SetFont( "LabelFont" )
	HidePlayers.Label:SetColor( color_white )
	HidePlayers.Label:SetTall(50)

	-- Hide Players
	local MuteAltTab = self:NewSetting( "TheaterCheckBoxLabel", translations:Format("Settings_MuteFocusLabel"), "cinema_mute_nofocus" )
	MuteAltTab:SetTooltip( translations:Format("Settings_MuteFocusTooltip") )
	MuteAltTab:AlignLeft( 16 )
	MuteAltTab:AlignTop( self.TitleHeight + 94 )
	MuteAltTab.Label:SetFont( "LabelFont" )
	MuteAltTab.Label:SetColor( color_white )
	MuteAltTab.Label:SetTall(50)

end

vgui.Register( "ScoreboardSettings", SETTINGS )