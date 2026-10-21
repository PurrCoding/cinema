local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local patterns = {
	["title"] = '<meta property="og:title" content=%b"">',
	["thumb"] = '<meta property="og:image" content=%b"">',
	["thumb_alt"] = '<link rel="image_src" href=%b"">',
	["duration"] = '"duration":(%d+)',
	["age_restriction"] = '"isFamilyFriendly":(%a+)',
}

local function ParseMetaDataFromHTML(html)
	local metadata = {}

	metadata.title = string.match(html, patterns["title"])
	if metadata.title then
		metadata.title = string.match(metadata.title, 'content="(.-)"') or metadata.title
	end

	metadata.thumbnail = string.match(html, patterns["thumb"]) or string.match(html, patterns["thumb_alt"])
	if metadata.thumbnail then
		metadata.thumbnail = string.match(metadata.thumbnail, 'content="(.-)"')
			or string.match(metadata.thumbnail, 'href="(.-)"')
			or metadata.thumbnail
	end

	local familyfriendly = html:match(patterns["age_restriction"])
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
