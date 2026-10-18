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
				var plybtn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (plybtn && player.paused && window.__mpWantPlay) {
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						plybtn.click();
					} catch (e) {}
					return;
				}

				if (player.paused || Number.isNaN(player.duration)) return;

				clearInterval(checkerInterval);
				window.cinema_controller = player;

				// MEGA ignores native pause — drive UI instead
				player.pause = function() {
					window.__mpWantPlay = false;
					var playBtn = document.querySelector(".play-video-button");
					if (playBtn && player.paused) return;

					try { player.click(); } catch (e) {}

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
						try { player.click(); } catch (e) {}
						if (++ticks >= 15) clearInterval(window.__mpPauseWatch);
					}, 120);
				};

				player.play = function() {
					window.__mpWantPlay = true;
					if (window.__mpPauseWatch) {
						clearInterval(window.__mpPauseWatch);
						window.__mpPauseWatch = null;
					}
					if (!player.paused) return Promise.resolve();

					var playBtn = document.querySelector(".play-video-button");
					if (playBtn) {
						try { playBtn.click(); } catch (e) {}
						return Promise.resolve();
					}

					try { player.click(); } catch (e) {}
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
				var plybtn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (plybtn && player.paused) {
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						plybtn.click();
					} catch (e) {}
					return;
				}

				if (player.paused || Number.isNaN(player.duration)) return;
				if (done) return;

				clearInterval(checkerInterval);
				done = true;
				player.volume = 0;
				try { player.click(); } catch (e) {}

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
