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
	theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.duration = tonumber(metadata.duration)

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)
end

theater.RegisterService("gdrive", SERVICE)
