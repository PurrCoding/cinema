local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local META_API = "https://api.bitchute.com/api/beta9/video"

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local onReceive = function(body, length, headers, code)
		local response = util.JSONToTable(body)
		if not response or not response.video_id then
			return onFailure("Theater_RequestFailed")
		end

		if response.state_id and response.state_id ~= "published" and response.state_id ~= "live" then
			return onFailure("Theater_RequestFailed")
		end

		local duration = util.ConvertTimeToSeconds(response.duration or "") or tonumber(response.duration) or 0
		local isLive = (response.state_id == "live") or (response.duration == "0:00")

		local info = {}
		info.title = response.video_name or "BitChute Video"
		info.thumbnail = response.thumbnail_url

		if isLive then
			info.type = "bitchutelive"
			info.duration = 0
		else
			info.duration = duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	-- SERVICE:Fetch is GET-only; BitChute metadata requires POST
	HTTP({
		url = META_API,
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Cache-Control"] = "no-cache",
			["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
		},
		body = util.TableToJSON({ video_id = data }),
		success = function(code, body, respHeaders)
			code = tonumber(code) or 0
			if code ~= 200 then
				return pcall(onFailure, "Theater_RequestFailed")
			end
			onReceive(body, body and body:len() or 0, respHeaders, code)
		end,
		failed = function(err)
			if onFailure then
				pcall(onFailure, err)
			end
		end,
	})
end

theater.RegisterService("bitchute", SERVICE)

-- Hidden live variant (same player, no seeking / no end-of-media)
theater.RegisterService("bitchutelive", {
	Name = "BitChute Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
