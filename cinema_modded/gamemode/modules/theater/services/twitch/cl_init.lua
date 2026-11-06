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
	Name = "Twitch.TV Stream",
	IsTimed = false,

	NeedsCodecFix = true,

	PlayerURL = "https://player.twitch.tv/?channel=%s&parent=pixeltailgames.com",
}

local Ignored = {
	["video"] = true,
	["directory"] = true,
	["downloads"] = true,
}

function SERVICE:Match(url)
	return url.host and url.host:match("twitch.tv")
end

if CLIENT then

	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var matureAccept = document.querySelectorAll("[data-a-target=\"content-classification-gate-overlay-start-watching-button\"]")[0];
			if (matureAccept) {
				matureAccept.click();
				return;
			}

			var player = document.getElementsByTagName("video")[0];
			var adOverlay = document.querySelectorAll("[data-test-selector=\"sad-overlay\"]")[0];

			if (!adOverlay && player && player.paused === false && player.readyState === 4) {
				clearInterval(checkerInterval);

				if (player.muted) {
					player.muted = false;
				}

				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider(Video, panel)
		panel:OpenURL(SERVICE.PlayerURL:format(Video:Data()))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

end

function SERVICE:GetURLInfo(url)
	if url.path then
		local data = url.path:match("/([%w_]+)")
		if data and not Ignored[data] then
			return { Data = data }
		end
	end

	return false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("twitchstream", SERVICE)
