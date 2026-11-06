--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

local SERVICE = {
	Name = "Google Drive",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,

	PreviewURL = "https://drive.google.com/file/d/%s/preview?autoplay=true",
}

function SERVICE:Match(url)
	return url.host and url.host:match("drive.google.com")
end

if CLIENT then

	local THEATER_JS = [[
		(async () => {
			// The Drive preview page loads the YT IFrame API asynchronously, so
			// YT / the "ucc-2" player may not exist yet when this script is queued.
			// Poll until both are ready before touching them (prevents
			// "ReferenceError: YT is not defined").
			function waitForPlayer(cb) {
				var tries = 0;
				var iv = setInterval(function() {
					tries++;
					var ready = (typeof YT !== "undefined") &&
						YT && typeof YT.get === "function" && YT.get("ucc-2");
					if (ready) {
						clearInterval(iv);
						cb(YT.get("ucc-2"));
					} else if (tries > 200) { // ~20s @ 100ms, give up
						clearInterval(iv);
					}
				}, 100);
			}

			waitForPlayer(function(player) {
				player.addEventListener("onReady", function() {
					player.setVolume(0);
				});

				player.addEventListener("onApiChange", function() {
					player.hideControls();
				});

				var done = false;
				var hideTimer = null;
				var sweepTimer = null;

				player.addEventListener("onStateChange", function(event) {
					if (event.data == YT.PlayerState.PLAYING ||
						event.data == YT.PlayerState.BUFFERING) {
						player.hideControls();
					}

					if (event.data == YT.PlayerState.ENDED) {
						if (hideTimer) { clearInterval(hideTimer); hideTimer = null; }
						if (sweepTimer) { clearTimeout(sweepTimer); sweepTimer = null; }
					}

					if (event.data == YT.PlayerState.PLAYING && !done) {
						done = true;

						{ // Native video control
							player.volume = 0;
							player.currentTime = 0;
							player.duration = player.getDuration();

							Object.defineProperty(player, "volume", {
								get() {
									return player.getVolume();
								},
								set(volume) {
									if (player.isMuted()) {
										player.unMute();
									}
									player.setVolume(volume * 100);
								},
							});

							Object.defineProperty(player, "currentTime", {
								get() {
									return Number(player.getCurrentTime());
								},
								set(time) {
									player.seekTo(time, true);
								},
							});
						}

						window.cinema_controller = player;
						exTheater.controllerReady();

						hideTimer = setInterval(function() {
							try { player.hideControls(); } catch (e) {}
						}, 500);

						sweepTimer = setTimeout(function() {
							try {
								var el = player.getIframe ? player.getIframe() : document.querySelector("video, iframe");
								if (el) {
									var rect = el.getBoundingClientRect();
									var steps = 8;
									for (var i = 0; i <= steps; i++) {
										var x = rect.left + (rect.width * i / steps);
										var y = rect.top + (rect.height * 0.5);
										["mousemove", "mousedown", "mouseup", "click"].forEach(function(type) {
											el.dispatchEvent(new MouseEvent(type, {
												bubbles: true, cancelable: true, view: window,
												clientX: x, clientY: y
											}));
										});
									}
								}
								player.hideControls();
							} catch (e) {}
						}, 1000);
					}
				});
			});
		})();
	]]

	local METADATA_JS = [[
		(async () => {
			var player = YT.get("ucc-2");

			player.addEventListener("onReady", function() {
				player.setVolume(0);
			});

			var done = false;
			player.addEventListener("onStateChange", function(event) {
				if (event.data == YT.PlayerState.PLAYING && !done) {
					done = true;

					var title = document.querySelector("meta[property='og:title']").getAttribute("content");
					var metadata = {
						duration: Math.round(player.getDuration()),
						title: title
					};

					console.log("METADATA:" + JSON.stringify(metadata));
				}
			});
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

	-- https://drive.google.com/file/d/(fileId)
	if url.path and url.path:match("^/file/d/([%a%d-_]+)/") then
		info.Data = url.path:match("^/file/d/([%a%d-_]+)/")
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("gdrive", SERVICE)
