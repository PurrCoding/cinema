local SERVICE = include "cl_init.lua"
if not SERVICE then return end

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<ovs:title>(.+)</ovs:title>",
	["thumb"] = "<ovs:thumbnail>(.+)</ovs:thumbnail>",
	["duration"] = "<ovs:duration>(.+)</ovs:duration>",
	["age_restriction"] = "<ovs:adult>(.+)</ovs:adult>",
}

---
-- Function to parse video metadata straight from the html instead of using the API
--
local function ParseMetaDataFromHTML(html)
	local metadata = {}

	metadata.title = html:match(patterns["title"])
	metadata.title = url.htmlentities_decode(metadata.title) -- Parse HTML entities in the title into symbols

	metadata.thumbnail = url.htmlentities_decode(html:match(patterns["thumb"]))
	metadata.familyfriendly = html:match(patterns["age_restriction"])
	metadata.duration = tonumber(html:match(patterns["duration"]))

	return metadata
end

local API_URL = "https://ok.ru/web-api/videoyandexfeed/%s"

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	data = string.Explode(",", data)
	local typeID, videoID = data[1], data[2]

	local onReceive = function(body, length, headers, code)
		local status, metadata = pcall(ParseMetaDataFromHTML, body)
		if not status then
			return onFailure("Theater_RequestFailed")
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = metadata.thumbnail

		if metadata.duration == 0 then
			info.type = "oklive"
			info.duration = 0
		else
			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local url = API_URL:format(videoID)
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("ok", SERVICE)

theater.RegisterService("oklive", {
	Name = "Ok Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
