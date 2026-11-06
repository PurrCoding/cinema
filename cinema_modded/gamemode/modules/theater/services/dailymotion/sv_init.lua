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

local API_URL = "https://api.dailymotion.com/video/%s?fields=id,title,duration,thumbnail_url,status,mode,private"

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local onReceive = function(body, length, headers, code)
		local response = util.JSONToTable(body)
		if not response then
			return onFailure("Theater_RequestFailed")
		end

		if response.private or response.status ~= "published" then
			return onFailure("Service_EmbedDisabled")
		end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if response.mode == "live" and response.duration == 0 then
			info.type = "dailymotionlive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local url = API_URL:format(data)
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("dailymotion", SERVICE)

theater.RegisterService("dailymotionlive", {
	Name = "Dailymotion Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
