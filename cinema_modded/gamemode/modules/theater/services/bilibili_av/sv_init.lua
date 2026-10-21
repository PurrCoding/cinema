local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local META_URL = "https://www.bilibili.com/video/%s"

function SERVICE:GetVideoInfo(d, onSuccess, onFailure)
	local sT = string.Split(d, " ")
	local aid = string.Split(sT[1], "av")
	local f = Format("https://api.bilibili.com/x/web-interface/view?aid=%s", aid[2])

	local onReceive = function(b, l, h, c)
		http.Fetch(f, function(r, s)
			if s == 0 then return onFailure("Theater_RequestFailed") end

			local rT = util.JSONToTable(r)
			local data = rT and rT.data
			if data == nil or not data.pages then return onFailure("Theater_RequestFailed") end

			local pdata = data.pages[tonumber(sT[2])] or data.pages[1]
			if pdata == nil then return onFailure("Theater_RequestFailed") end

			local info = {}
			info.title = data.title .. " (" .. sT[2] .. "p)"
			info.duration = pdata.duration + 1

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
	end

	local url = META_URL:format(aid[2])
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibili_legacy", SERVICE)
