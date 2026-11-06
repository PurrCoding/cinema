--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

--[[   _
	( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)


--]]
local PANEL = {}

PANEL.Scrollbar = {}

local b = 20

PANEL.Scrollbar.BackgroundColor = Color( 38 + b, 41 + b, 49 + b )
PANEL.Scrollbar.HoverColor = Color( 38 + b * 2, 41 + b * 2, 49 + b * 2 )
PANEL.Scrollbar.DepressedColor = Color( 255, 255, 255 )
PANEL.Scrollbar.DisabledColor = Color( 26, 30, 38 )
PANEL.Scrollbar.TextColor = Color( 255, 255, 255 )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.BaseClass.Init( self )

	self:SetSpacing(2)
	self:EnableVerticalScrollbar()

	self.VBar.Paint = function()
		return true
	end

	self.VBar.btnUp:Remove()
	self.VBar.btnDown:Remove()

	self.VBar.btnGrip.Paint = function( panel, w, h )

		w = w - 4
		h = h - 2

		if ( panel:GetDisabled() ) then
			draw.RoundedBox( 4, 2, 1, w, h, self.Scrollbar.DisabledColor )
			return
		end

		if ( panel.Depressed ) then
			draw.RoundedBox( 4, 2, 1, w, h, self.Scrollbar.DepressedColor )
			return
		end

		if ( panel.Hovered ) then
			draw.RoundedBox( 4, 2, 1, w, h, self.Scrollbar.HoverColor )
			return
		end

		draw.RoundedBox( 4, 2, 1, w, h, self.Scrollbar.BackgroundColor )

	end

	self.VBar.OnCursorMoved = function( self, x, y )

		if ( not self.Enabled ) then return end
		if ( not self.Dragging ) then return end

		local x = 0
		local y = gui.MouseY()
		local x, y = self:ScreenToLocal( x, y )

		-- Uck.
		y = y - self.HoldPos

		local TrackSize = self:GetTall() - self:GetWide() * 2 - self.btnGrip:GetTall()

		y = y / TrackSize

		self:SetScroll( y * self.CanvasSize )

	end

	self.VBar.PerformLayout = function( self )

		local Wide = self:GetWide()
		local Scroll = self:GetScroll() / self.CanvasSize
		local BarSize = math.max( self:BarScale() * (self:GetTall()), 10 )
		local Track = self:GetTall() - BarSize
		Track = Track + 1

		Scroll = Scroll * Track

		self.btnGrip:SetPos( 0, Scroll )
		self.btnGrip:SetSize( Wide, BarSize )

	end

end

function PANEL:Paint( w, h )

	return true

end

--[[---------------------------------------------------------
   Name: SortVideos
-----------------------------------------------------------]]
function PANEL:SortVideos( f )

	if not f then return end

	table.sort( self.Items, function( a, b )

		if not a or not a.Video then return false end
		if not b or not b.Video then return true end

		return f( a.Video, b.Video )

	end )

end

derma.DefineControl( "TheaterList", "", PANEL, "DPanelList" )