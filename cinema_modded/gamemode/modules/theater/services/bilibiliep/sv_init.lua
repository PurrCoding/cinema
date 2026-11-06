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

local META_URL = "https://www.bilibili.com/bangumi/play/ep%s"

function SERVICE:GetVideoInfo(d, onSuccess, onFailure)
	local f = Format("https://api.bilibili.com/pgc/view/web/season?ep_id=%s", d)
	local c = Format("https://api.bilibili.com/pgc/player/web/playurl/html5?ep_id=%s", d)

	local onReceive = function(b, l, h, c)
		http.Fetch(c, function(r, s)
			if s == 0 then return onFailure("Theater_RequestFailed") end
			local rT = util.JSONToTable(r)
			local data = rT.result
			if rT.message == "success" and data ~= nil then
			else
				return onFailure("Theater_RequestFailed")
			end
		end)

		http.Fetch(f, function(r, s)
			if s == 0 then return onFailure("Theater_RequestFailed") end
			local rT = util.JSONToTable(r)
			local data = rT.result
			if data == nil then return onFailure("Theater_RequestFailed") end

			local info = {}
			for k, v in pairs(data.episodes) do
				if tostring(v.id) == d then
					info.title = data.episodes[k].share_copy
					info.duration = v.duration / 1000 + 1
				end
			end

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
	end

	local url = META_URL:format(d)
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibiliep", SERVICE)
