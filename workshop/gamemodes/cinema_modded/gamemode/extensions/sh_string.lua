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