local SERVICE = {
	Name = "Mega",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

local PREVIEW_URL = "https://mega.nz/embed/%s"

local ValidTypes = {
	["embed"] = true,
	["file"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("mega.nz")
end

if (CLIENT) then

	local THEATER_JS = [[
		(function() {
			window.__mpWantPlay = true;

			var checkerInterval = setInterval(function() {
				if (!window.__mpWantPlay) return;

				var btn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				// Autoplay via MEGA toggle until video.paused === false
				if (player.paused) {
					if (btn) {
						try {
							player.setAttribute("webkit-playsinline", "webkit-playsinline");
							btn.click();
						} catch (e) {}
					}
					return;
				}

				if (Number.isNaN(player.duration)) return;

				clearInterval(checkerInterval);
				window.cinema_controller = player;

				// Theater pause/play → click .play-video-button, trust video.paused
				player.pause = function() {
					window.__mpWantPlay = false;
					if (player.paused) return;

					var b = document.querySelector(".play-video-button");
					if (b) { try { b.click(); } catch (e) {} }

					var ticks = 0;
					if (window.__mpPauseWatch) clearInterval(window.__mpPauseWatch);
					window.__mpPauseWatch = setInterval(function() {
						if (window.__mpWantPlay) {
							clearInterval(window.__mpPauseWatch);
							return;
						}
						if (!player || player.paused) {
							clearInterval(window.__mpPauseWatch);
							return;
						}
						var bb = document.querySelector(".play-video-button");
						if (bb) { try { bb.click(); } catch (e) {} }
						if (++ticks >= 20) clearInterval(window.__mpPauseWatch);
					}, 100);
				};

				player.play = function() {
					window.__mpWantPlay = true;
					if (window.__mpPauseWatch) {
						clearInterval(window.__mpPauseWatch);
						window.__mpPauseWatch = null;
					}
					if (!player.paused) return Promise.resolve();

					var b = document.querySelector(".play-video-button");
					if (b) { try { b.click(); } catch (e) {} }

					var ticks = 0;
					if (window.__mpPlayWatch) clearInterval(window.__mpPlayWatch);
					window.__mpPlayWatch = setInterval(function() {
						if (!window.__mpWantPlay) {
							clearInterval(window.__mpPlayWatch);
							return;
						}
						if (!player || !player.paused) {
							clearInterval(window.__mpPlayWatch);
							return;
						}
						var bb = document.querySelector(".play-video-button");
						if (bb) { try { bb.click(); } catch (e) {} }
						if (++ticks >= 20) clearInterval(window.__mpPlayWatch);
					}, 100);

					return Promise.resolve();
				};

				exTheater.controllerReady();
			}, 50);
		})();
	]]

	local METADATA_JS = [[
		(function() {
			var done = false;
			var checkerInterval = setInterval(function() {
				var btn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (player.paused) {
					if (btn) {
						try {
							player.setAttribute("webkit-playsinline", "webkit-playsinline");
							btn.click();
						} catch (e) {}
					}
					return;
				}

				if (Number.isNaN(player.duration)) return;
				if (done) return;

				clearInterval(checkerInterval);
				done = true;
				player.volume = 0;

				if (btn) {
					try { btn.click(); } catch (e) {}
				}

				var title = document.title.replace("MEGA - ", "");
				console.log("METADATA:" + JSON.stringify({
					duration: player.duration,
					title: title
				}));
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )
		panel:OpenURL(PREVIEW_URL:format(Video:Data()))

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )

		local panel = self:CreateWebCrawler(callback)

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(METADATA_JS)
			end
		end

		panel:OpenURL(PREVIEW_URL:format(data))

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	local authority, path, data, key = url.encoded:match("^https?://(.+%..+)/(%a+)/([%a%d-_]+)#([%a%d-_]+)$")
	if (authority and authority == "mega.nz") and ValidTypes[path] and key then
		info.Data = ("%s#%s"):format(data, key)
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
		info.duration = tonumber(metadata.duration)

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "mega", SERVICE )
