local SERVICE = {
	Name = "VK Video",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,

	EmbedURL = "https://vkvideo.ru/video_ext.php?oid=-%s&id=%s&autoplay=1",
}

function SERVICE:Match(url)
	return url.host and url.host:match("vkvideo.ru")
end

if CLIENT then

	local JS_FIND_VIDEO = [[
		function findVideo(root) {
			if (!root) return null;

			var container = root.querySelector && root.querySelector("div.video-container.s-t");
			if (container) {
				var inContainer = container.querySelector("video");
				if (inContainer) return inContainer;
				if (container.shadowRoot) {
					var v = findVideo(container.shadowRoot);
					if (v) return v;
				}
			}

			var vid = root.querySelector && root.querySelector("video");
			if (vid) return vid;

			var rootContainer = root.querySelector && root.querySelector(".shadow-root-container");
			if (rootContainer && rootContainer.shadowRoot) {
				var v2 = findVideo(rootContainer.shadowRoot);
				if (v2) return v2;
			}

			var all = root.querySelectorAll ? root.querySelectorAll("*") : [];
			for (var i = 0; i < all.length; i++) {
				var el = all[i];
				if (el.shadowRoot) {
					var v3 = findVideo(el.shadowRoot);
					if (v3) return v3;
				}
			}
			return null;
		}
	]]

	local THEATER_JS = [[
		(function() {
			]] .. JS_FIND_VIDEO .. [[

			var checkerInterval = setInterval(function() {
				var player = findVideo(document);
				if (!player) return;

				if (player.paused) { try { player.play(); } catch (e) {} }

				if (!player.paused && player.readyState >= 3) {
					if (player.muted) { player.muted = false; }

					clearInterval(checkerInterval);

					window.cinema_controller = player;
					exTheater.controllerReady();

					document.body.style.backgroundColor = "black";

					player.addEventListener("seeking", function() {
						if (!player.paused) { player.pause(); }

						var onProgress = function() {
							if (player.paused && player.readyState >= 3) {
								player.removeEventListener("progress", onProgress);
								player.play();
							}
						};
						player.addEventListener("progress", onProgress);
					});
				}
			}, 50);
		})();
	]]

	-- Title: full document.title / <title> from the page header
	local METADATA_JS = [[
		(function() {
			]] .. JS_FIND_VIDEO .. [[

			function pageTitle() {
				var t = (document.title || "").trim();
				if (t) return t;
				var el = document.querySelector("head title");
				if (el) {
					var text = (el.textContent || el.innerText || "").trim();
					if (text) return text;
				}
				return "VK Video";
			}

			var checkerInterval = setInterval(function() {
				var player = findVideo(document);
				if (!player) return;

				clearInterval(checkerInterval);
				if (window.metaevent_set) return;

				player.muted = true;

				var finish = function() {
					if (window.metaevent_set) return;
					window.metaevent_set = true;

					var thumb = "";
					var thumbEl = document.querySelector(".videoplayer_thumb");
					if (thumbEl && thumbEl.style && thumbEl.style.backgroundImage) {
						thumb = thumbEl.style.backgroundImage.slice(4, -1).replace(/["']/g, "");
					}

					console.log("METADATA:" + JSON.stringify({
						title: pageTitle(),
						thumbnail: thumb,
						duration: player.duration || 0
					}));
				};

				if (player.readyState >= 1 && !isNaN(player.duration)) {
					finish();
				} else {
					player.addEventListener("loadedmetadata", finish);
					player.addEventListener("error", function() {
						console.log("ERROR:" + (player.error ? player.error.code : 5));
					});
					setTimeout(function() {
						if (!window.metaevent_set) finish();
					}, 8000);
				}
			}, 50);
		})();
	]]

	local function extractData(data)
		-- video-OID_ID or live-OID_ID
		local oid, id = data:match("video%-(%d+)_(%d+)")
		if not oid then
			oid, id = data:match("live%-(%d+)_(%d+)")
		end
		return oid, id
	end

	function SERVICE:LoadProvider(Video, panel)
		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = util.SecondsToISO_8601(startTime)
		else
			startTime = 0
		end

		local url = SERVICE.EmbedURL:format(extractData(Video:Data())) ..
			(self.IsTimed and "&t=" .. startTime or "")

		panel:OpenURL(url)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata(data, callback)
		local panel = vgui.Create("DHTML")
		panel:SetSize(512, 512)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		panel.OnDocumentReady = function(pnl)
			pnl:QueueJavascript(METADATA_JS)
		end

		function panel:ConsoleMessage(msg)
			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))
				callback(metadata)
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local code = tonumber(string.sub(msg, 7))
				callback({ err = util.MEDIA_ERR[code] or util.MEDIA_ERR[5] })
				panel:Remove()
			end
		end
		panel:OpenURL(SERVICE.EmbedURL:format(extractData(data)))
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}

	-- https://vkvideo.ru/video-xxxxxxxxx_xxxxxxxxx
	-- https://vkvideo.ru/live-xxxxxxxxx_xxxxxxxxx
	if url.path then
		local videoID = url.path:match("(video%-%d+_%d+)")
			or url.path:match("(live%-%d+_%d+)")
		if videoID then
			info.Data = videoID
		end
	end

	if url.query then
		-- ?z=video-... or ?z=live-...
		if url.query.z then
			local data = url.query.z:match("(video%-%d+_%d+)")
				or url.query.z:match("(live%-%d+_%d+)")
			if data then info.Data = data end
		end

		if url.query.t and url.query.t ~= "" then
			local time = util.ISO_8601ToSeconds(url.query.t)
			if time and time ~= 0 then
				info.StartTime = time
			end
		end
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("vk", SERVICE)

theater.RegisterService("vklive", {
	Name = "VK Video (Live)",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
