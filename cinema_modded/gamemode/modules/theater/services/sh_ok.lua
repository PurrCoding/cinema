local SERVICE = {
	Name = "OK",
	IsTimed = true,

	NeedsCodecFix = true
}

local ValidTypes = {
	["video"] = true,
	["live"] = true,
}

local API_URL = "https://ok.ru/web-api/videoyandexfeed/%s"

function SERVICE:Match( url )
	return url.host and url.host:match("ok.ru")
end

if (CLIENT) then
	local EMBED_URL = "https://ok.ru/videoembed/%s?autoplay=1"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("VIDEO")[0]
			var ad = document.querySelector(".videoAdUiSkipButton")
			if (!!ad) {ad.click()}
			if (!!player) {

				if (!player.paused && player.readyState === 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}
		}, 100);
	]]

	function SERVICE:LoadProvider( Video, panel )
		local data = string.Explode(",", Video:Data())
		local typeID, videoID = data[1], data[2]

		panel:OpenURL( EMBED_URL:format(videoID) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local typeID, videoID = url.path:match("^/([%w%-_]+)/(%d+)")
		if (typeID and videoID and ValidTypes[typeID]) then return { Data = typeID .. "," .. videoID } end
	end

	return false
end

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
local function ParseMetaDataFromHTML( html )
	local metadata, html = {}, html

	metadata.title = html:match(patterns["title"])
	metadata.title = url.htmlentities_decode(metadata.title) -- Parse HTML entities in the title into symbols

	metadata.thumbnail = url.htmlentities_decode(html:match(patterns["thumb"]))
	metadata.familyfriendly = html:match(patterns["age_restriction"])
	metadata.duration = tonumber(html:match(patterns["duration"]))

	return metadata
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	data = string.Explode(",", data)
	local typeID, videoID = data[1], data[2]

	local onReceive = function( body, length, headers, code )

		local status, metadata = pcall(ParseMetaDataFromHTML, body)
		if not status  then
			return onFailure( "Theater_RequestFailed" )
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
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "ok", SERVICE )

theater.RegisterService( "oklive", {
	Name = "Ok Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )