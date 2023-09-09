local SERVICE = {}

SERVICE.Name = "YouTube"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_PARTIAL

local METADATA_URL = "https://www.youtube.com/watch?v=%s"

function SERVICE:Match( url )
	return url.host and url.host:match("youtu.?be[.com]?")
end

if (CLIENT) then

	function SERVICE:LoadProvider( Video, panel )

		local url = GetGlobal2String( "cinema_url", "" ) .. "youtube.html?v=%s"
		panel:OpenURL( url:format( Video:Data() ) ..
			(self.IsTimed and ("&t=%s"):format(
				math.Round(CurTime() - Video:StartTime())
			) or "")
		)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
		end
	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- http://www.youtube.com/watch?v=(videoId)
	if url.query and url.query.v and #url.query.v > 0 then
		info.Data = url.query.v

	-- http://www.youtube.com/v/(videoId)
	elseif url.path and url.path:match("^/v/([%a%d-_]+)") then
		info.Data = url.path:match("^/v/([%a%d-_]+)")

		-- http://www.youtube.com/shorts/(videoId)
	elseif url.path and url.path:match("^/shorts/([%a%d-_]+)") then
		info.Data = url.path:match("^/shorts/([%a%d-_]+)")

	-- http://youtu.be/(videoId)
	elseif url.host:match("youtu.be") and
		url.path and url.path:match("^/([%a%d-_]+)$") and
		( not info.query or #info.query == 0 ) then -- short url
		info.Data = url.path:match("^/([%a%d-_]+)$")
	end

	-- Start time, ?t=123s
	if (url.query and url.query.t and url.query.t ~= "") then
		local time = util.ISO_8601ToSeconds(url.query.t)
		if time and time ~= 0 then
			info.StartTime = time
		end
	end

	return info.Data and info or false
end

--[[
	Credits to veitikka (https://github.com/veitikka) for fixing YouTube service and writing the
	Workaround with a Metadata parser.
--]]

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["thumb"] = "<meta%sproperty=\"og:image\"%s-content=%b\"\">",
	["thumb_fallback"] = "<link%sitemprop=\"thumbnailUrl\"%s-href=%b\"\">",
	["duration"] = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"] = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"] = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">",
	["age_restriction"] = "<meta%sproperty=\"og:restrictions:age\"%s-content=%b\"\">"
}

---
-- Function to parse video metadata straight from the html instead of using the API
--
local function ParseMetaDataFromHTML( html )
	--MetaData table to return when we're done
	local metadata, html = {}, html

	-- Fetch title and thumbnail, with fallbacks if needed
	metadata.title = util.ParseElementAttribute(html:match(patterns["title"]), "content")
		or util.ParseElementContent(html:match(patterns["title_fallback"]))

	-- Parse HTML entities in the title into symbols
	metadata.title = url.htmlentities_decode(metadata.title)

	metadata.thumbnail = util.ParseElementAttribute(html:match(patterns["thumb"]), "content")
		or util.ParseElementAttribute(html:match(patterns["thumb_fallback"]), "href")

	metadata.familyfriendly = util.ParseElementAttribute(html:match(patterns["age_restriction"]), "content") or ""

	-- See if the video is an ongoing live broadcast
	-- Set duration to 0 if it is, otherwise use the actual duration
	local isLiveBroadcast = tobool(util.ParseElementAttribute(html:match(patterns["live"]), "content"))
	local broadcastEndDate = html:match(patterns["live_enddate"])
	if isLiveBroadcast and not broadcastEndDate then
		-- Mark as live video
		metadata.duration = 0
	else
		local durationISO8601 = util.ParseElementAttribute(html:match(patterns["duration"]), "content")
		if isstring(durationISO8601) then
			metadata.duration = math.max(1, util.ISO_8601ToSeconds(durationISO8601))
		end
	end

	return metadata
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )
		local status, metadata = pcall(ParseMetaDataFromHTML, body)
		if not status  then
			return onFailure( "Theater_RequestFailed" )
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = metadata.thumbnail

		if metadata.duration == 0 then
			info.type = "youtubelive"
			info.duration = 0
		else
			if metadata.familyfriendly == "18+" then
				info.type = "youtubensfw"
			end

			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = METADATA_URL:format( data )
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "youtube", SERVICE )

-- Implementation is found in 'youtube' service.
-- GetVideoInfo switches to 'youtubelive'

theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	Dependency = DEPENDENCY_COMPLETE,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )