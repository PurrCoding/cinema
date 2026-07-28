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

	-- Custom endpoint created by PurrCoding. Please do not overly abuse it,
	-- and do not use it in third-party addons. No warranty for reliability is
	-- guaranteed, even though this is backed by edge scripts.
	local apiUrl = ("https://gm-api.physcannon.top/index.ts?id=%s"):format(videoId)

	self:Fetch(apiUrl, function(body, length, headers, code)

		local response = util.JSONToTable(body)

		if not response or not response.success then
			return onFailure and onFailure("Theater_RequestFailed")
		end

		local info = {}
		info.title = response.title
		info.thumbnail = ("https://img.youtube.com/vi/%s/mqdefault.jpg"):format(videoId)

		if response.live then
			info.type = "youtubelive"
			info.duration = 0
		else
			info.duration = tonumber(response.duration) or 0
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end, onFailure)

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