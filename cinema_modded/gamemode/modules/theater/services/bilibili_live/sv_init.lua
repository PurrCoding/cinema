local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local META_URL = "https://live.bilibili.com/%s"

function SERVICE:GetVideoInfo(ID, onSuccess, onFailure)
	local f = Format("https://api.live.bilibili.com/room/v1/Room/get_info?room_id=%s", ID)

	local onReceive = function(b, l, h, c)
		http.Fetch(f, function(r, s)
			if s == 0 then
				return onFailure("Theater_RequestFailed")
			end

			local rT = util.JSONToTable(r)
			local data = rT.data

			if data == nil then
				return onFailure("Theater_RequestFailed")
			end

			if data.live_status == 0 then
				return onFailure("Service_StreamOffline")
			end

			local info = {}
			info.thumbnail = data.user_cover
			info.title = data.title

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
	end

	local url = META_URL:format(ID)
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibili_live", SERVICE)
