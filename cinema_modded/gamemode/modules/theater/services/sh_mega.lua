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
			window.__mpToggleBusy = false;

			function toggleOnce(wantPlay) {
				window.__mpWantPlay = wantPlay;
				var player = window.cinema_controller;
				if (!player) return;
				if (wantPlay && !player.paused) return;
				if (!wantPlay && player.paused) return;
				if (window.__mpToggleBusy) return;

				var btn = document.querySelector(".play-video-button");
				if (!btn) return;

				window.__mpToggleBusy = true;
				try { btn.click(); } catch (e) {}

				setTimeout(function() {
					window.__mpToggleBusy = false;
					if (window.__mpWantPlay !== wantPlay) return;
					var ply = window.cinema_controller;
					if (!ply) return;
					if (wantPlay && !ply.paused) return;
					if (!wantPlay && ply.paused) return;
					var b = document.querySelector(".play-video-button");
					if (!b) return;
					window.__mpToggleBusy = true;
					try { b.click(); } catch (e) {}
					setTimeout(function() { window.__mpToggleBusy = false; }, 400);
				}, 400);
			}

			var checkerInterval = setInterval(function() {
				if (!window.__mpWantPlay) return;

				var btn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (!player.paused && !Number.isNaN(player.duration)) {
					clearInterval(checkerInterval);
					window.cinema_controller = player;

					player.pause = function() { toggleOnce(false); };
					player.play = function() {
						toggleOnce(true);
						return Promise.resolve();
					};

					exTheater.controllerReady();
					return;
				}

				// Autoplay: one click, cooldown, check video.paused
				if (player.paused && btn && !window.__mpToggleBusy) {
					window.__mpToggleBusy = true;
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						btn.click();
					} catch (e) {}
					setTimeout(function() { window.__mpToggleBusy = false; }, 500);
				}
			}, 50);
		})();
	]]

	local METADATA_JS = [[
		(function() {
			var done = false;
			var busy = false;
			var checkerInterval = setInterval(function() {
				var btn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (!player.paused && !Number.isNaN(player.duration)) {
					if (done) return;
					clearInterval(checkerInterval);
					done = true;
					player.volume = 0;
					if (btn) { try { btn.click(); } catch (e) {} }

					var title = document.title.replace("MEGA - ", "");
					console.log("METADATA:" + JSON.stringify({
						duration: player.duration,
						title: title
					}));
					return;
				}

				if (player.paused && btn && !busy) {
					busy = true;
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						btn.click();
					} catch (e) {}
					setTimeout(function() { busy = false; }, 500);
				}
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
