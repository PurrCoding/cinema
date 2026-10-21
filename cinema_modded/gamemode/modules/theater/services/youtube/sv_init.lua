local SERVICE = include "cl_init.lua"
if not SERVICE then return end

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["duration"] = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"] = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"] = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">",
}

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	-- Metadata is fetched server-side.
	if not SERVER then return end

	local videoId = data:Data()

	-- Builds the info table from metadata and calls onSuccess.
	-- Shared by both the primary crawler path and the HTML scraper fallback.
	local function buildInfo(title, isLive, duration)
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
	local function runHTMLScraperFallback(primaryError)
		local watchUrl = ("https://www.youtube.com/watch?v=%s"):format(videoId)

		self:Fetch(watchUrl, function(body, length, headers, code)
			local ok, metadata = pcall(self.ParseYTMetaDataFromHTML, self, body)

			if not ok or not metadata or not metadata.title then
				-- Prefer the crawler error, else the generic localized key.
				return onFailure and onFailure(primaryError or "Theater_RequestFailed")
			end

			buildInfo(metadata.title, metadata.isLive, metadata.duration)
		end, function(err)
			-- HTTP request itself failed (timeout, non-200, connection error).
			if onFailure then
				onFailure(primaryError or err or "Theater_RequestFailed")
			end
		end)
	end

	-- PRIMARY: client-side HTML crawler (youtube_meta.html) via the IFrame API.
	-- Networks the request to the video's owner client and awaits metadata back.
	theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
		if not metadata or metadata.err then
			-- Crawler unavailable or errored: attempt the server-side scraper.
			return runHTMLScraperFallback(metadata and metadata.err)
		end

		buildInfo(metadata.title, metadata.isLive, metadata.duration)
	end)
end

---
-- Parse video metadata from a raw YouTube watch page HTML body.
--
function SERVICE:ParseYTMetaDataFromHTML(html)
	local metadata = {}

	-- Title: prefer og:title meta tag, fall back to <title> element
	metadata.title = util.ParseElementAttribute(string.match(html, patterns["title"]), "content")
		or util.ParseElementContent(string.match(html, patterns["title_fallback"]))

	-- Decode HTML entities (e.g. & -> &)
	metadata.title = url.htmlentities_decode(metadata.title)

	-- Live broadcast detection
	local isLiveBroadcast = tobool(util.ParseElementAttribute(string.match(html, patterns["live"]), "content"))
	local broadcastEndDate = string.match(html, patterns["live_enddate"])

	if isLiveBroadcast and not broadcastEndDate then
		-- Ongoing live stream: mark duration as 0
		metadata.isLive = true
		metadata.duration = 0
	else
		metadata.isLive = false

		-- Try the legacy <meta itemprop="duration"> tag (ISO 8601) first.
		-- YouTube removed this tag around 2021, so it will usually be absent.
		local durationISO8601 = util.ParseElementAttribute(string.match(html, patterns["duration"]), "content")
		local parsedDuration = isstring(durationISO8601) and util.ISO_8601ToSeconds(durationISO8601)
		if parsedDuration then
			metadata.duration = math.max(1, parsedDuration)
		else
			-- Modern fallback: parse lengthSeconds from the ytInitialPlayerResponse
			-- JSON blob that YouTube embeds directly in the page HTML.
			local lengthSeconds = tonumber(string.match(html, '"lengthSeconds"%s*:%s*"(%d+)"'))
			if lengthSeconds then
				metadata.duration = math.max(1, lengthSeconds)
			end
		end
	end

	return metadata
end

theater.RegisterService("youtube", SERVICE)

-- Implementation is found in "youtube" service.
-- GetVideoInfo switches to "youtubelive"
theater.RegisterService("youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
