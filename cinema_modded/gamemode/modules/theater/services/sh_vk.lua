local SERVICE = {
	Name = "VK Video",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

function SERVICE:Match( url )
	return url.host and url.host:match("vkvideo.ru")
end

if (CLIENT) then
	local EMBED_URL = "https://vkvideo.ru/video_ext.php?oid=-%s&id=%s&autoplay=1"

	--[[
		VK puts the real <video> under div.video-container.s-t and/or Shadow DOM.
		Same recursive finder idea as OK (shadow-root-container + nested roots).
	]]
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

	local METADATA_JS = [[
		(function() {
			]] .. JS_FIND_VIDEO .. [[

			var checkerInterval = setInterval(function() {
				var player = findVideo(document);
				if (!player) return;

				clearInterval(checkerInterval);
				if (window.metaevent_set) return;

				player.muted = true;

				var titleEl = document.querySelector(".videoplayer_title_link, .videoplayer_title_link._clickable");
				var title = titleEl ? (titleEl.innerText || titleEl.textContent) : "VK Video";

				var finish = function() {
					if (window.metaevent_set) return;
					window.metaevent_set = true;

					var thumb = "";
					var thumbEl = document.querySelector(".videoplayer_thumb");
					if (thumbEl && thumbEl.style && thumbEl.style.backgroundImage) {
						thumb = thumbEl.style.backgroundImage.slice(4, -1).replace(/["']/g, "");
					}

					console.log("METADATA:" + JSON.stringify({
						title: title,
						thumbnail: thumb,
						duration: player.duration || 0
					}));
				};

				if (player.readyState >= 1 && !isNaN(player.duration) && player.duration > 0) {
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
		local oid, id = data:match("video%-(%d+)_(%d+)")
		return oid, id
	end

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = util.SecondsToISO_8601(startTime)
		else startTime = 0 end

		local url = EMBED_URL:format(extractData(Video:Data())) ..
			(self.IsTimed and "&t=" .. startTime or "")

		panel:OpenURL(url)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end

	function SERVICE:GetMetadata( data, callback )

		local panel = vgui.Create("DHTML")
		panel:SetSize(512,512)
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
		panel:OpenURL(EMBED_URL:format(extractData(data)))
	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://vkvideo.ru/video-xxxxxxxxx_xxxxxxxxx
	if url.path then
		local videoID = url.path:match("(video%-%d+_%d+)")
		if videoID then
			info.Data = videoID
		end
	end

	if url.query then

		-- https://vkvideo.ru/video?z=video-xxxxxxxxx_xxxxxxxxx
		if url.query.z then
			local data = url.query.z:match("(video%-%d+_%d+)")
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

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = metadata.thumbnail

		local duration = metadata.duration
		if not duration or (isnumber(duration) and duration == 0) then
			info.type = "vklive"
			info.duration = 0
		else
			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "vk", SERVICE )
theater.RegisterService( "vklive", {
	Name = "VK Video (Live)",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
