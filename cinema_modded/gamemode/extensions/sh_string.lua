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

local string_byte = string.byte
local string_len = string.len
local ipairs = ipairs
local math_fmod = math.fmod
local math_floor = math.floor
local tostring = tostring
local string_format = string.format
local surface_SetFont = CLIENT and surface.SetFont
local surface_GetTextSize = CLIENT and surface.GetTextSize
local string_sub = string.sub
local pairs = pairs
local string_find = string.find

function string.hash(str)
	local bytes = {string_byte(str, 0, string_len(str))}

	local hash = 0

	--0x07FFFFFF
	--It is a sequrence of 31 "1".
	--If it was a sequence of 32 "1", it would not be able to send over network as a positive number
	--Now it must be 27 "1", because DTVarInt hates 31... Do not ask why...
	for _, v in ipairs(bytes) do
		hash = math_fmod(v + ((hash * 32) - hash), 0x07FFFFFF)
	end

	return hash
end

function string.FormatSeconds(sec)
	local hours = math_floor(sec / 3600)
	local minutes = math_floor((sec % 3600) / 60)
	local seconds = sec % 60

	if minutes < 10 then
		minutes = "0" .. tostring(minutes)
	end

	if seconds < 10 then
		seconds = "0" .. tostring(seconds)
	end

	if hours > 0 then
		return string_format("%s:%s:%s", hours, minutes, seconds)
	else
		return string_format("%s:%s", minutes, seconds)
	end
end

function string.reduce(str, font, width)
	surface_SetFont(font)
	local tw, th = surface_GetTextSize(str)

	while tw > width do
		str = string_sub(str, 1, string_len(str) - 1)
		tw, th = surface_GetTextSize(str)
	end

	return str
end

function string.findFromTable(str, tbl)
	for _, v in pairs(tbl) do
		if string_find(str, v) then return true end
	end

	return false
end