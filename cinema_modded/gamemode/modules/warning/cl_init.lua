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

local color_box_bg = Color(0,0,0,200)
local WarningFont = "WarningFont"
surface.CreateFont( WarningFont, { font = "Open Sans Condensed Light", size = 28, weight = 200 } )

local pairs = pairs
local ScrW = ScrW
local draw = draw
local hook = hook
local surface = surface
local table = table

local color_white = color_white
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM

module( "warning" )

local HookName = "DrawWarningMessage"
local Messages = {}

function Set( ... )
	Clear()
	Add(...)
end

function Add( ... )
	table.Add( Messages, {...} )
	hook.Add( "HUDPaint", HookName, Draw )
end

function Clear()
	hook.Remove( "HUDPaint", HookName )
	table.Empty( Messages )
end

local p = 10
local w, h, hoffset
function Draw()

	surface.SetFont( WarningFont )

	for k, msg in pairs( Messages ) do

		w, h = surface.GetTextSize( msg )

		hoffset = ((h * k) - h) * 2

		draw.RoundedBox( 4, (ScrW() / 2) - w / 2 - p, h - p + hoffset, w + p * 2, h + p * 2, color_box_bg )
		draw.SimpleText( msg, WarningFont, ScrW() / 2 - w / 2, hoffset + h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

	end

end