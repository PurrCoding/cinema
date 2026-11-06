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

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local onReceive = function(body, length, headers, code)
		local response = util.JSONToTable(body)
		if not response then
			return onFailure("Theater_RequestFailed")
		end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if response.duration == 0 then
			info.type = "rumblelive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local isShort = isstring(data) and data:StartWith("shorts/")
	local url = SERVICE.APIURL:format(data) .. (isShort and "" or ".html")
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("rumble", SERVICE)

theater.RegisterService("rumblelive", {
	Name = "Rumble Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
