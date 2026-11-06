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

/*   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DNumberWang2: GMT Edition

*/

local PANEL = {}

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:Init()

	self.Slider = vgui.Create( "DSlider", self )
	self.Slider:SetLockY( 0.5 )
	self.Slider.TranslateValues = function( slider, x, y ) return self:TranslateSliderValues( x, y ) end
	self.Slider:SetTrapInside( true )

	self:SetTall( 35 )

end

/*---------------------------------------------------------
	SetMinMax
---------------------------------------------------------*/
function PANEL:SetMinMax( min, max )

	self:SetMin( min )
	self:SetMax( max )

end

/*---------------------------------------------------------
	SetMin
---------------------------------------------------------*/
function PANEL:SetMin( min )
	self.m_numMin = tonumber( min )
end

/*---------------------------------------------------------
	SetMax
---------------------------------------------------------*/
function PANEL:SetMax( max )
	self.m_numMax = tonumber( max )
end

/*---------------------------------------------------------
	GetFloatValue
---------------------------------------------------------*/
function PANEL:GetFloatValue( max )

	if ( not self.m_fFloatValue ) then m_fFloatValue = 0 end

	return tonumber( self.m_fFloatValue ) or 0

end

/*---------------------------------------------------------
   Name: SetValue
---------------------------------------------------------*/
function PANEL:SetValue( val )

	if ( val == nil ) then return end

	local OldValue = val
	val = tonumber( val )
	val = val or 0

	if ( self.m_iDecimals == 0 ) then

		val = Format( "%i", val )

	elseif ( val ~= 0 ) then

		val = Format( "%." .. self.m_iDecimals .. "f", val )

		// Trim trailing 0's and .'s 0 this gets rid of .00 etc
		val = string.TrimRight( val, "0" )
		val = string.TrimRight( val, "." )

	end

	self.Value = val
	self:UpdateConVar()

end

/*---------------------------------------------------------
   Name: GetValue
---------------------------------------------------------*/
function PANEL:GetValue()

	return tonumber( self.Value ) or 0

end

/*---------------------------------------------------------
   Name: SetConVar
---------------------------------------------------------*/
function PANEL:SetConVar( cvar )

	self.ConVar = cvar

end

/*---------------------------------------------------------
   Name: UpdateConVar
---------------------------------------------------------*/
function PANEL:UpdateConVar()

	if self.ConVar then
		RunConsoleCommand( self.ConVar, self.Value )
	end

end

/*---------------------------------------------------------
	Name: SetDecimals
---------------------------------------------------------*/
function PANEL:SetDecimals( num )

	self.m_iDecimals = num

end

/*---------------------------------------------------------
   Name: GetDecimals
---------------------------------------------------------*/
function PANEL:GetDecimals()
	return self.m_iDecimals
end

/*---------------------------------------------------------
   Name: GetFraction
---------------------------------------------------------*/
function PANEL:GetFraction( val )

	local Value = val or self:GetValue()

	local Fraction = ( Value - self.m_numMin ) / (self.m_numMax - self.m_numMin)
	return math.max( 0, Fraction )

end

/*---------------------------------------------------------
   Name: SetFraction
---------------------------------------------------------*/
function PANEL:SetFraction( val )

	local Fraction = self.m_numMin + ( (self.m_numMax - self.m_numMin) * val )
	self:SetValue( Fraction )

end

/*---------------------------------------------------------
   Name:
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.Slider:SetPos( 0, self:GetTall() / 2 )
	self.Slider:SetSize( self:GetWide(), 13 )

	self.Slider:SetSlideX( self:GetFraction() )

end

function PANEL:Think()

	if self.ConVar then

		if GetConVar( self.ConVar ):GetInt() ~= self.Value then
			self.Value = GetConVar( self.ConVar ):GetInt()
			self.Slider:SetSlideX( self:GetFraction() )
		end

	end

end

function PANEL:Paint( w, h )

	local val = self:GetValue()
	local title = string.upper( self:GetText() )

	if self.Descriptions then
		val = self.Descriptions[val + 1]
	end

	surface.SetFont( "LabelFont" )
	local w, h = surface.GetTextSize( val )
	surface.SetTextColor( 255, 255, 255, 255 )

	// Value
	surface.SetTextPos( self:GetWide() - w - 5, 0 )
	surface.DrawText( val )

	// Title
	surface.SetTextPos( 5, 0 )
	surface.DrawText( title)

	// Line
	//surface.SetDrawColor( 85, 167, 221, 150 )
	surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
	surface.DrawRect( 3, ( self:GetTall() / 2 ) + 6, self:GetWide() - 6, 3 )

end

function PANEL:SetText( text )
	self.Text = text
end

function PANEL:GetText()
	return self.Text or ""
end

/*---------------------------------------------------------
   Name: ValueChanged
---------------------------------------------------------*/
function PANEL:ValueChanged( val )

	self.Slider:SetSlideX( self:GetFraction( val ) )
	self:UpdateConVar()

end

/*---------------------------------------------------------

---------------------------------------------------------*/
function PANEL:TranslateSliderValues( x, y )

	self:SetFraction( x )

	return self:GetFraction(), y

end

derma.DefineControl( "TheaterNumSlider", "A simple slider", PANEL, "Panel" )
