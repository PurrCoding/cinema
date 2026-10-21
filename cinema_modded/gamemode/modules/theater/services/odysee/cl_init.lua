local SERVICE = {
	Name = "Odysee",
	IsTimed = true,
	NeedsCodecFix = true,

	EmbedURL = "https://odysee.com/$/embed/%s",
}

function SERVICE:Match(url)
	return url.host and url.host:match("odysee%.com")
end

function SERVICE:GetURLInfo(url)
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

	function SERVICE:LoadProvider(Video, panel)
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
			embedUrl = SERVICE.EmbedURL:format(claim)
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

if SERVER then
	return SERVICE
end

theater.RegisterService("odysee", SERVICE)

theater.RegisterService("odyseelive", {
	Name = "Odysee Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
