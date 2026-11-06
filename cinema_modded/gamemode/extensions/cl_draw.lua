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

local Color = Color
local IsValid = IsValid
local RealTime = RealTime

local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

local FPS_Cap = 30
local FPS_Smoother = CreateClientConVar( "cinema_smoother", 1, true, false, "Make some videos smoother at the cost of FPS" )

local function ChangeFrameCap()
	local bool = FPS_Smoother:GetBool()

	FPS_Cap = bool and 60 or 30
end
ChangeFrameCap()
cvars.AddChangeCallback( FPS_Smoother:GetName(), ChangeFrameCap)

function draw.TheaterText(text, font, x, y, colour, xalign, yalign)
	draw_SimpleText(text, font, x, y + 4, Color(0,0,0,colour.a), xalign, yalign)
	draw_SimpleText(text, font, x + 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
	draw_SimpleText(text, font, x - 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
	draw_SimpleText(text, font, x, y, colour, xalign, yalign)
end

local mat, pw, ph
function draw.HTMLTexture( panel, w, h )
	if not panel or not IsValid(panel) then return end
	if not w or not h then return end

	if not panel.NextHTMLTextureThink or RealTime() > panel.NextHTMLTextureThink then
		panel:UpdateHTMLTexture()
		panel.NextHTMLTextureThink = RealTime() + (1 / FPS_Cap)
	end

	pw, ph = panel:GetSize()

	-- Convert to scalar
	w = w / pw
	h = h / ph

	-- Fix for non-power-of-two html panel size
	pw = pw * (math.power2(pw) / pw)
	ph = ph * (math.power2(ph) / ph)

	mat = panel:GetHTMLMaterial()
	if mat then
		surface_SetDrawColor( 255, 255, 255, 255 )
		surface_SetMaterial( mat )
		surface_DrawTexturedRect( 0, 0, w * pw, h * ph )
	else
		surface_SetDrawColor( 0, 0, 0, 255 )
		surface_DrawRect( 0, 0, w * pw, h * ph )
	end
end