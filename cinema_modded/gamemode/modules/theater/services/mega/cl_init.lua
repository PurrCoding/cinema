local SERVICE = {
	Name = "Mega",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,

	PreviewURL = "https://mega.nz/embed/%s",
}

local ValidTypes = {
	["embed"] = true,
	["file"] = true,
}

function SERVICE:Match(url)
	return url.host and url.host:match("mega.nz")
end

if CLIENT then

	local THEATER_JS = [[
		(function() {
			var started = false;

			function isolate(player) {
				document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
				document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";

				document.body.appendChild(player);

				var nodes = Array.prototype.slice.call(document.body.childNodes);
				for (var i = 0; i < nodes.length; i++) {
					if (nodes[i] !== player) {
						try { document.body.removeChild(nodes[i]); } catch (e) {}
					}
				}

				var scripts = document.querySelectorAll("script");
				for (var s = 0; s < scripts.length; s++) {
					try { scripts[s].remove(); } catch (e) {}
				}

				player.style.cssText = [
					"position:fixed",
					"top:0",
					"left:0",
					"width:100%",
					"height:100%",
					"max-width:100%",
					"max-height:100%",
					"object-fit:contain",
					"background:#000",
					"z-index:9999",
					"margin:0",
					"padding:0",
					"border:none"
				].join(";");

				player.removeAttribute("controls");
				player.controls = false;

				window.cinema_controller = player;
			}

			var checkerInterval = setInterval(function() {
				var btn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (player.paused && !started) {
					started = true;
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						if (btn) btn.click();
					} catch (e) {}
					setTimeout(function() {
						if (player.paused) {
							var b = document.querySelector(".play-video-button");
							if (b) { try { b.click(); } catch (e) {} }
						}
					}, 600);
					return;
				}

				if (player.paused || Number.isNaN(player.duration)) return;

				clearInterval(checkerInterval);
				isolate(player);

				var req = player.play();
				if (req && req.catch) req.catch(function() {});

				exTheater.controllerReady();
			}, 50);
		})();
	]]

	local METADATA_JS = [[
		(function() {
			var done = false;
			var started = false;
			var checkerInterval = setInterval(function() {
				var btn = document.querySelector(".play-video-button");
				var player = document.getElementsByTagName("video")[0];

				if (!player) return;

				if (!player.id || player.id !== "video") {
					try { player.currentTime = 9999; } catch (e) {}
					return;
				}

				if (player.paused && !started) {
					started = true;
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						if (btn) btn.click();
					} catch (e) {}
					return;
				}

				if (player.paused || Number.isNaN(player.duration)) return;
				if (done) return;

				clearInterval(checkerInterval);
				done = true;
				player.volume = 0;
				try { player.pause(); } catch (e) {}

				var title = document.title.replace("MEGA - ", "");
				console.log("METADATA:" + JSON.stringify({
					duration: player.duration,
					title: title
				}));
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		panel:OpenURL(SERVICE.PreviewURL:format(Video:Data()))

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata(data, callback)
		local panel = self:CreateWebCrawler(callback)

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(METADATA_JS)
			end
		end

		panel:OpenURL(SERVICE.PreviewURL:format(data))
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}

	local authority, path, data, key = url.encoded:match("^https?://(.+%..+)/(%a+)/([%a%d-_]+)#([%a%d-_]+)$")
	if authority and authority == "mega.nz" and ValidTypes[path] and key then
		info.Data = ("%s#%s"):format(data, key)
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("mega", SERVICE)
