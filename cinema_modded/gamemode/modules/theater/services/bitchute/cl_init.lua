local SERVICE = {
	Name = "BitChute",
	IsTimed = true,

	NeedsCodecFix = true,

	EmbedURL = "https://www.bitchute.com/embed/%s",
}

function SERVICE:Match(url)
	if not url or not url.host then return false end
	if not url.host:match("bitchute%.com") then return false end
	if not url.path then return false end

	-- Only /video/ID or /embed/ID (not homepage / channels)
	if url.path:match("^/video/[%w%-_]+") then return true end
	if url.path:match("^/embed/[%w%-_]+") then return true end

	return false
end

if CLIENT then

	--[[
		Same approach as MEGA:
		1. Use BitChute/Video.js only to start the stream
		2. Detach <video>, wipe the rest of the page (kills Video.js)
		3. Own play/pause/volume/seek via native HTMLMediaElement
	]]
	local THEATER_JS = [[
		(function() {
			function tryClickPlay() {
				var btn = document.querySelector(".vjs-big-play-button")
					|| document.querySelector("button.vjs-play-control")
					|| document.querySelector(".vjs-play-control");
				if (btn) {
					try { btn.click(); } catch (e) {}
					return true;
				}
				return false;
			}

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

			tryClickPlay();

			var checkerInterval = setInterval(function() {
				tryClickPlay();

				var player = document.getElementsByTagName("video")[0];
				if (!player) return;

				if (player.paused) {
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						var req = player.play();
						if (req && req.catch) req.catch(function() {});
					} catch (e) {}
					return;
				}

				// Live streams often have duration NaN/Infinity — still isolate once playing
				if (player.readyState < 2) return;

				clearInterval(checkerInterval);
				isolate(player);

				var req = player.play();
				if (req && req.catch) req.catch(function() {});

				exTheater.controllerReady();
			}, 20);
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		local startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))

		panel:OpenURL(SERVICE.EmbedURL:format(Video:Data()))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)

			if self.IsTimed and startTime > 3 then
				timer.Simple(1.5, function()
					if IsValid(pnl) then
						pnl:QueueJavascript(
							("if (window.cinema_controller) cinema_controller.currentTime = %d;"):format(startTime)
						)
					end
				end)
			end
		end
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}

	-- https://www.bitchute.com/video/xxxxxxxxx
	-- https://www.bitchute.com/embed/xxxxxxxxx
	if url.path then
		local videoId = url.path:match("^/video/([%w%-_]+)")
			or url.path:match("^/embed/([%w%-_]+)")
		if videoId then
			info.Data = videoId
		end
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("bitchute", SERVICE)

-- Hidden live variant (same player, no seeking / no end-of-media)
theater.RegisterService("bitchutelive", {
	Name = "BitChute Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
