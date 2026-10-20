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
	local channel, claim = url.path:match("/(@[^/]+)/([^/]+)$")
	local claimOnly = url.path:match("/([^/]+)$")

	local data
	if channel and claim then
		-- Full path matches official oEmbed embed src
		data = channel .. "/" .. claim
	elseif claimOnly and claimOnly ~= "" and not claimOnly:StartWith("$") then
		data = claimOnly
	else
		return false
	end

	local info = { Data = data }

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

local function DecodeURIComponent( str )
	if not str then return str end
	return string.gsub(str, "%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end)
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

	local embedUrl = ""
	if videoData.embedUrl and videoData.embedUrl ~= "" then
		embedUrl = DecodeURIComponent(videoData.embedUrl)
	end

	return {
		title = title,
		duration = duration,
		embedUrl = embedUrl,
		thumbnail = videoData.thumbnailUrl or "",
	}
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	-- data is the embed path (@channel/claim or claim)
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

			if response.thumbnail_url then
				info.thumbnail = response.thumbnail_url
			end

			if response.html then
				local src = string.match(response.html, 'src="([^"]+)"')
				if src then
					local embed = DecodeURIComponent(src)
					embed = string.match(embed, "^([^?]+)") or embed
					info.embedUrl = embed
				end
			end

			pcall(onSuccess, info)
		end, onFailure )
	end, onFailure )
end

if CLIENT then
	local THEATER_JS = [[
		(function() {
			function findPlayer() {
				var parent = document.querySelector(".video-js-parent");
				if (parent) {
					var v = parent.querySelector("video");
					if (v) return v;
				}
				return document.querySelector("video.vjs-tech")
					|| document.querySelector("video");
			}

			var consentHandled = false;
			var checkerInterval = setInterval(function() {
				var consentBtn = document.querySelector("#onetrust-accept-btn-handler");
				if (consentBtn && !consentHandled) {
					consentBtn.click();
					consentHandled = true;
					return;
				}

				var player = findPlayer();
				if (!player) return;

				if (player.paused) {
					try { player.play(); } catch (e) {}
					return;
				}

				if (player.readyState < 2) return;

				clearInterval(checkerInterval);

				try {
					player.muted = false;
					if (player.hasAttribute && player.hasAttribute("muted")) {
						player.removeAttribute("muted");
					}
				} catch (e) {}

				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;

				// Short watchdog: Odysee sometimes re-mutes right after start
				var ticks = 0;
				var watchdog = setInterval(function() {
					try {
						if (player.muted) {
							player.muted = false;
							if (player.hasAttribute && player.hasAttribute("muted")) {
								player.removeAttribute("muted");
							}
						}
					} catch (e) {}
					if (++ticks >= 40) clearInterval(watchdog);
				}, 100);

				exTheater.controllerReady();
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )
		local startTime = 0
		if self.IsTimed then
			startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))
		end

		local embedUrl

		-- Prefer embedUrl resolved during GetVideoInfo (JSON-LD / oEmbed)
		local meta = Video.metadata or Video._metadata
		if istable(meta) and meta.embedUrl and meta.embedUrl ~= "" then
			embedUrl = meta.embedUrl
		else
			local claim = Video:Data()
			embedUrl = ("https://odysee.com/$/embed/%s"):format(claim)
		end

		if not string.find(embedUrl, "[?&]autoplay=") then
			embedUrl = embedUrl .. (string.find(embedUrl, "?", 1, true) and "&" or "?") .. "autoplay=1"
		end

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

SERVICE.ClassName = "odysee"

if SERVER then
	return SERVICE
end

theater.RegisterService(SERVICE)

theater.RegisterService( "odyseelive", {
	Name = "Odysee Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
} )
