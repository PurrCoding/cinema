local SERVICE = {
	Name = "YouTube",
	IsTimed = true,

	NeedsCodecFix = false,
	ExtentedVideoInfo = true,

	PlayerURL = "youtube.html",
	MetadataURL = "youtube_meta.html",
}

function SERVICE:Match(url)
	return url.host and url.host:match("youtu.?be[.com]?")
end

if CLIENT then

	function SERVICE:LoadProvider(Video, panel)
		local baseUrl = theater.GetCinemaURL(SERVICE.PlayerURL)
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
			self:LoadExFunctions(pnl)
		end
	end

	-- PRIMARY metadata extractor. Runs client-side, driven by the server via
	-- theater.FetchVideoMedata. Loads the invisible youtube_meta.html crawler,
	-- which uses the YouTube IFrame API to emit
	-- "METADATA:{title,isLive,duration}" or "ERROR:<code|msg>" to console.
	function SERVICE:GetMetadata(data, callback)
		local videoId = data
		if istable(data) then
			videoId = data.id or data.Data
		end

		local panel = self:CreateWebCrawler(callback)

		local baseUrl = theater.GetCinemaURL(SERVICE.MetadataURL)
		panel:OpenURL(baseUrl .. ("#v=%s"):format(videoId))
	end

end

function SERVICE:GetURLInfo(url)
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
	elseif url.host:match("youtu.be")
		and url.path
		and url.path:match("^/([%a%d-_]+)$")
		and (not url.query or #url.query == 0) then -- short url
		info.Data = url.path:match("^/([%a%d-_]+)$")
	end

	-- Start time, ?t=123s
	if url.query and url.query.t and url.query.t ~= "" then
		local time = util.ISO_8601ToSeconds(url.query.t)
		if time and time ~= 0 then
			info.StartTime = time
		end
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
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
