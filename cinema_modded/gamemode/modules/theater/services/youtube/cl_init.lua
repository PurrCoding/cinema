local SERVICE = {
	Name = "YouTube",
	IsTimed = true,

	NeedsCodecFix = false,
	ExtentedVideoInfo = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("youtu.?be[.com]?")
end

if (CLIENT) then

	function SERVICE:LoadProvider( Video, panel )
		local baseUrl = theater.GetCinemaURL("youtube.html")
		local videoId = Video:Data()
		local hash = ("v=%s"):format(videoId)

		if self.IsTimed then
			local startTime
			if Video._Paused and Video._PausedOffset then
				-- Frozen pause position, not the advancing clock
				startTime = math.max(0, math.Round(Video._PausedOffset))
			else
				startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))
			end

			if startTime > 0 then
				hash = hash .. ("&t=%d"):format(startTime)
			end
		end

		-- Start the player paused (disables autoplay in youtube.html)
		if Video._Paused then
			hash = hash .. "&paused=1"
		end

		local url = baseUrl .. "#" .. hash
		panel:OpenURL(url)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	-- PRIMARY metadata extractor. Runs client-side, driven by the server via
	-- theater.FetchVideoMedata. Loads the invisible youtube_meta.html crawler,
	-- which uses the YouTube IFrame API to emit
	-- "METADATA:{title,isLive,duration}" or "ERROR:<code|msg>" to console.
	function SERVICE:GetMetadata( data, callback )
		local videoId = data
		if istable(data) then
			videoId = data.id or data.Data
		end

		local panel = self:CreateWebCrawler(callback)

		local baseUrl = theater.GetCinemaURL("youtube_meta.html")
		panel:OpenURL(baseUrl .. ("#v=%s"):format(videoId))
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
		( not url.query or #url.query == 0 ) then -- short url
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

---
-- Helper function for converting ISO 8601 time strings.
-- e.g. "PT1H23M45S" -> 5025
--
local function convertISO8601Time( duration )
	if not isstring(duration) then return 0 end

	local hours   = tonumber( string.match(duration, "(%d+)H") ) or 0
	local minutes = tonumber( string.match(duration, "(%d+)M") ) or 0
	local seconds = tonumber( string.match(duration, "(%d+)S") ) or 0

	duration = hours * 3600 + minutes * 60 + seconds
	return duration
end

---
-- Get the value for an attribute from a html element
--
local function ParseElementAttribute( element, attribute )
	if not element then return end
	local output = string.match( element, attribute .. "%s-=%s-%b\"\"" )
	if not output then return end
	output = string.gsub( output, attribute .. "%s-=%s-", "" )
	return string.sub( output, 2, -2 )
end

---
-- Get the contents of a html element by removing tags.
-- Used as fallback for when title cannot be found via meta tag.
--
local function ParseElementContent( element )
	if not element then return end
	local output = string.gsub( element, "^%s-<%w->%s-", "" )
	return string.gsub( output, "%s-</%w->%s-$", "" )
end

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"]          = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["duration"]       = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"]           = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"]   = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">"
}

---
-- Parse video metadata from a raw YouTube watch page HTML body.
--
function SERVICE:ParseYTMetaDataFromHTML( html )
	local metadata = {}

	-- Title: prefer og:title meta tag, fall back to <title> element
	metadata.title = ParseElementAttribute( string.match(html, patterns["title"]), "content" )
		or ParseElementContent( string.match(html, patterns["title_fallback"]) )

	-- Decode HTML entities (e.g. &amp; -> &)
	metadata.title = url.htmlentities_decode( metadata.title )

	-- Live broadcast detection
	local isLiveBroadcast = tobool( ParseElementAttribute( string.match(html, patterns["live"]), "content" ) )
	local broadcastEndDate = string.match( html, patterns["live_enddate"] )

	if isLiveBroadcast and not broadcastEndDate then
		-- Ongoing live stream: mark duration as 0
		metadata.isLive = true
		metadata.duration = 0
	else
		metadata.isLive = false

		-- Try the legacy <meta itemprop="duration"> tag (ISO 8601) first.
		-- YouTube removed this tag around 2021, so it will usually be absent.
		local durationISO8601 = ParseElementAttribute( string.match(html, patterns["duration"]), "content" )
		if isstring(durationISO8601) then
			metadata.duration = math.max( 1, convertISO8601Time(durationISO8601) )
		else
			-- Modern fallback: parse lengthSeconds from the ytInitialPlayerResponse
			-- JSON blob that YouTube embeds directly in the page HTML.
			local lengthSeconds = tonumber( string.match(html, '"lengthSeconds"%s*:%s*"(%d+)"') )
			if lengthSeconds then
				metadata.duration = math.max( 1, lengthSeconds )
			end
		end
	end

	return metadata
end


SERVICE.ClassName = "youtube"

if SERVER then
	return SERVICE
end

theater.RegisterService(SERVICE)

-- Implementation is found in "youtube" service.
-- GetVideoInfo switches to "youtubelive"
theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
