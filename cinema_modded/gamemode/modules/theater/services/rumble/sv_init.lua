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
