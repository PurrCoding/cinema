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
