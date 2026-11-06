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

local function ParseURL(urlString)
	local status, parsed = pcall(url.parse2, urlString)
	if status then
		return parsed
	end
	return nil
end

local validExtensions = {
	["m3u8"] = "hls", -- HLS
	["mpd"] = "dash", -- DASH
}

local function GetProtocol(url)
	if url.file and validExtensions[url.file.ext] then
		return validExtensions[url.file.ext]
	end
	return nil
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		local urlParsed = ParseURL(data:Data())
		local protocol = GetProtocol(urlParsed) or "unknown"
		info.title = ("%s: %s"):format(protocol:upper(), data:Data())

		if metadata.live then
			info.type = "url_protocol_live"
			info.duration = 0
		else
			info.duration = math.Round(tonumber(metadata.duration) or 0)
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)
end

theater.RegisterService("url_protocol", SERVICE)

-- Register live streaming variant
theater.RegisterService("url_protocol_live", {
	Name = "URL (Protocol, Live)",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
