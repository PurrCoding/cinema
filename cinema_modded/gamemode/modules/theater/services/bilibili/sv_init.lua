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

local SERVICE = include "cl_init.lua"
if not SERVICE then return end
-- Currently supports AV and BV ids
local META_URL = "https://www.bilibili.com/video/%s"

function SERVICE:GetVideoInfo(d, onSuccess, onFailure)
	local sT = string.Split(d, " ")
	local f = Format("https://api.bilibili.com/x/web-interface/view?bvid=%s", sT[1])
	local onReceive = function(b, l, h, c)
		http.Fetch(f, function(r, s)
			if s == 0 then return onFailure("Theater_RequestFailed") end
			local rT = util.JSONToTable(r)
			local data = rT and rT.data
			if data == nil or not data.pages then return onFailure("Theater_RequestFailed") end
			local pdata = data.pages[tonumber(sT[2])] or data.pages[1]
			if pdata == nil then return onFailure("Theater_RequestFailed") end
			local info = {}
			info.thumbnail = data.pic
			info.title = data.title .. " (" .. sT[2] .. "p)"
			info.duration = pdata.duration + 1
			if onSuccess then pcall(onSuccess, info) end
		end)
	end

	local url = META_URL:format(sT[1])
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibili", SERVICE)
