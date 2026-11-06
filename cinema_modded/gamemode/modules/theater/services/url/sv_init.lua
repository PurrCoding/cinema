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

local SERVICES = include "cl_init.lua"
if not SERVICES then return end

local url2 = SERVICES.url
local IMAGE_FORMATS = SERVICES.IMAGE_FORMATS
local BASIC_VIDEO_AUDIO_FORMATS = SERVICES.BASIC_VIDEO_AUDIO_FORMATS
local PROPRIETARY_FORMATS = SERVICES.PROPRIETARY_FORMATS

local function GetVideoInfo(self, data, onSuccess, onFailure)
	local status, data2 = pcall(url2.parse2, data:Data())
	if not status then
		return onFailure("Failed to parse URL: " .. tostring(data2))
	end

	local fileext = data2.file and data2.file.ext
	local filename = data2.file and data2.file.name or "Unknown"

	if not fileext then
		return onFailure("No file extension found")
	end

	-- Handle video and audio formats with metadata extraction
	if BASIC_VIDEO_AUDIO_FORMATS[fileext] then
		theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
			if metadata.err then
				return onFailure(metadata.err)
			end

			local info = {
				title = (fileext == "webm" and "Video: %s" or "Audio: %s"):format(filename),
				duration = math.max(0, math.Round(tonumber(metadata.duration) or 0)),
			}

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
		return
	end

	-- Handle images with configurable duration
	if IMAGE_FORMATS[fileext] then
		local info = { title = ("Image: %s"):format(filename) }
		local duration = GetConVar("cinema_service_imageduration"):GetInt()

		if duration > 0 then
			info.type = "image_timed"
			info.duration = duration
		else
			info.type = "image"
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
		return
	end

	-- Handle proprietary video formats
	if PROPRIETARY_FORMATS[fileext] then
		theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
			if metadata.err then
				return onFailure(metadata.err)
			end

			local info = {
				title = ("Video: %s"):format(filename),
				duration = math.max(0, math.Round(tonumber(metadata.duration) or 0)),
			}

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
	end
end

SERVICES.url_basic.GetVideoInfo = GetVideoInfo
SERVICES.url_proprietary.GetVideoInfo = GetVideoInfo

if SERVER then
	CreateConVar("cinema_service_imageduration", "0", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "0 = Infinite, 60sec Max", 0, 60)
end

theater.RegisterService("url_basic", SERVICES.url_basic)
theater.RegisterService("url_proprietary", SERVICES.url_proprietary)
theater.RegisterService("image_timed", SERVICES.image_timed)
theater.RegisterService("image", SERVICES.image)
