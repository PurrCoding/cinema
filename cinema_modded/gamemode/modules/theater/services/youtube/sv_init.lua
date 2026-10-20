local SERVICE = include "cl_init.lua"
if not SERVICE then return end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	-- Metadata is fetched server-side.
	if not SERVER then return end

	local videoId = data:Data()

	-- Builds the info table from metadata and calls onSuccess.
	-- Shared by both the primary crawler path and the HTML scraper fallback.
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

	-- FALLBACK: server-side scraper of the raw YouTube watch page HTML.
	-- Triggered whenever the primary client-side crawler is unavailable or errors.
	local function runHTMLScraperFallback( primaryError )
		local watchUrl = ("https://www.youtube.com/watch?v=%s"):format(videoId)

		self:Fetch(watchUrl, function(body, length, headers, code)

			local ok, metadata = pcall(self.ParseYTMetaDataFromHTML, self, body)

			if not ok or not metadata or not metadata.title then
				-- Prefer the crawler error, else the generic localized key.
				return onFailure and onFailure( primaryError or "Theater_RequestFailed" )
			end

			buildInfo( metadata.title, metadata.isLive, metadata.duration )

		end, function( err )
			-- HTTP request itself failed (timeout, non-200, connection error).
			if onFailure then
				onFailure( primaryError or err or "Theater_RequestFailed" )
			end
		end)
	end

	-- PRIMARY: client-side HTML crawler (youtube_meta.html) via the IFrame API.
	-- Networks the request to the video's owner client and awaits metadata back.
	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if not metadata or metadata.err then
			-- Crawler unavailable or errored: attempt the server-side scraper.
			return runHTMLScraperFallback( metadata and metadata.err )
		end

		buildInfo( metadata.title, metadata.isLive, metadata.duration )
	end)

end


theater.RegisterService("youtube", SERVICE)

-- Implementation is found in "youtube" service.
-- GetVideoInfo switches to "youtubelive"
theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
