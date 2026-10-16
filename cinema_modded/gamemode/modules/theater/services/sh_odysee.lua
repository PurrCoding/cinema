local SERVICE = {
	Name = "Odysee",
	IsTimed = true,
	NeedsCodecFix = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("odysee%.com")
end

function SERVICE:GetURLInfo( url )
	if not url.path then return false end

	-- https://odysee.com/@channel:1/video-title:a
	-- https://odysee.com/video-title:a
	local claimName = url.path:match("/([^/]+)$")
	if not claimName or claimName == "" then
		return false
	end

	local info = { Data = claimName }

	-- Preserve channel for livestream-style embeds when present
	local channel = url.path:match("/@([^/]+)/")
	if channel then
		info.Data = claimName
		info.Channel = channel
	end

	if url.query and url.query.t then
		local t = tonumber(url.query.t)
		if t and t > 0 then
			info.StartTime = t
		end
	end

	return info
end

local function ParseISO8601Duration( duration )
	if not duration or not string.match(duration, "^PT") then
		return 0
	end

	local totalSeconds = 0
	local hours = string.match(duration, "(%d+)H")
	local minutes = string.match(duration, "(%d+)M")
	local seconds = string.match(duration, "(%d+)S")

	if hours then totalSeconds = totalSeconds + (tonumber(hours) * 3600) end
	if minutes then totalSeconds = totalSeconds + (tonumber(minutes) * 60) end
	if seconds then totalSeconds = totalSeconds + tonumber(seconds) end

	return totalSeconds > 0 and totalSeconds or 0
end

local function ParseOdyseeHTML( body )
	local jsonData = string.match(body, '<script type="application/ld%+json">(.-)</script>')
	if not jsonData then return nil end

	local videoData = util.JSONToTable(jsonData)
	if not videoData or videoData["@type"] ~= "VideoObject" then
		return nil
	end

	local title = videoData.name or "Odysee Video"
	title = string.gsub(title, "&quot;", '"')
	title = string.gsub(title, "&amp;", "&")
	title = string.gsub(title, "&lt;", "<")
	title = string.gsub(title, "&gt;", ">")

	local duration = 0
	if videoData.duration then
		duration = ParseISO8601Duration(videoData.duration)
	end

	return {
		title = title,
		duration = duration,
		embedUrl = videoData.embedUrl or "",
	}
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	-- data is the claim name from GetURLInfo
	local pageUrl = "https://odysee.com/" .. data

	self:Fetch( pageUrl, function( body, length, headers, code )
		local metadata = ParseOdyseeHTML(body)

		if metadata and metadata.title then
			if metadata.duration == 0 then
				metadata.type = "odyseelive"
			end
			pcall(onSuccess, metadata)
			return
		end

		-- Fallback: oEmbed
		local oembedUrl = "https://odysee.com/$/oembed?url=" .. pageUrl .. "&format=json"
		self:Fetch( oembedUrl, function( oBody )
			local response = util.JSONToTable(oBody)
			if not response then
				return onFailure("Theater_RequestFailed")
			end

			local info = {
				title = response.title or "Odysee Livestream",
				duration = 0,
				type = "odyseelive",
			}
			pcall(onSuccess, info)
		end, onFailure )
	end, onFailure )
end

if CLIENT then
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.querySelector("video#vjs_video_3_html5_api")
				|| document.querySelector("video");
			var consentBtn = document.querySelector("#onetrust-accept-btn-handler");

			if (!!consentBtn) {
				consentBtn.click();
				return;
			}

			if (!!player && !player.paused && player.readyState == 4) {
				if (player.muted) { player.muted = false; }
				clearInterval(checkerInterval);
				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )
		local startTime = 0
		if self.IsTimed then
			startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))
		end

		local claim = Video:Data()
		local embedUrl = ("https://odysee.com/$/embed/%s?autoplay=1"):format(claim)

		if self.IsTimed and startTime > 0 then
			embedUrl = embedUrl .. "&t=" .. startTime
		end

		panel:OpenURL(embedUrl)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end
end

theater.RegisterService( "odysee", SERVICE )

theater.RegisterService( "odyseelive", {
	Name = "Odysee Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
} )
