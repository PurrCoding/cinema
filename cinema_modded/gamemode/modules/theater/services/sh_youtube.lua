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

	-- Fallback metadata extractor. Runs client-side, driven by the server via
	-- theater.FetchVideoMedata when the HTTP API is unavailable. Loads the
	-- invisible youtube_meta.html crawler, which uses the YouTube IFrame API to
	-- emit "METADATA:{title,isLive,duration}" or "ERROR:<code|msg>" to console.
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

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	-- Metadata is fetched server-side via the HTTP API.
	if not SERVER then return end

	local videoId = data:Data()

	-- Builds the info table from crawler metadata and calls onSuccess.
	-- Shared by both the primary API path and the crawler fallback.
	local function buildInfo( title, isLive, duration )
		local info = {}
		info.title = title
		info.thumbnail = ("https://img.youtube.com/vi/%s/mqdefault.jpg"):format(videoId)

		if isLive then
			info.type = "youtubelive"
			info.duration = 0
		else
			info.duration = tonumber(duration) or 0
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	-- FALLBACK: client-side HTML crawler (youtube_meta.html) via the IFrame API.
	-- Triggered whenever the primary HTTP API is down or returns an error.
	local function runCrawlerFallback( primaryError )
		theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

			if not metadata or metadata.err then
				-- Prefer the crawler error, else the original API error,
				-- else the generic localized key.
				local message = (metadata and metadata.err)
					or primaryError
					or "Theater_RequestFailed"
				return onFailure and onFailure(message)
			end

			buildInfo( metadata.title, metadata.isLive, metadata.duration )
		end)
	end

	-- Custom endpoint created by PurrCoding. Please do not overly abuse it,
	-- and do not use it in third-party addons. No warranty for reliability is
	-- guaranteed, even though this is backed by edge scripts.
	local apiUrl = ("https://gm-api.physcannon.top/index.ts?id=%s"):format(videoId)

	self:Fetch(apiUrl, function(body, length, headers, code)

		local response = util.JSONToTable(body)

		if not response or not response.success then
			-- The API returns richer error details on failure:
			--   response.error  = human-readable message (e.g. "Video is unplayable")
			--   response.reason = short code (e.g. "unplayable")
			-- Keep that message around, but attempt the crawler fallback first.
			local message = response and response.error
			if message and response.reason then
				message = ("%s (%s)"):format(message, response.reason)
			end

			return runCrawlerFallback( message )
		end

		buildInfo( response.title, response.live, response.duration )

	end, function( err )
		-- HTTP request itself failed (timeout, non-200, connection error).
		runCrawlerFallback( err )
	end)

end

theater.RegisterService( "youtube", SERVICE )

-- Implementation is found in "youtube" service.
-- GetVideoInfo switches to "youtubelive"
theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )