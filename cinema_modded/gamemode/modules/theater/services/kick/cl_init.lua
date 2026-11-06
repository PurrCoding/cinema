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
	Name = "Kick",
	IsTimed = false,

	NeedsCodecFix = true,

	PlayerURL = "https://kick.com/%s",
}

local Ignored = {
	["category"] = true,
	["browse"] = true,
	["videos"] = true,
}

function SERVICE:Match(url)
	return url.host and url.host:match("kick.com")
end

if CLIENT then

	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var matureWarn = document.querySelector("button[data-test=\"mature\"]");
			if (matureWarn) {
				matureWarn.click();
				matureWarn.remove();
			}

			var player = document.getElementById("video-player");
			if (player) {
				clearInterval(checkerInterval);

				if (player.muted) {
					player.muted = false;
				}

				document.body.appendChild(player);
				var main = document.querySelector("div[class^=\"group/main\"]");
				if (main) {
					main.remove();
				}
				document.body.style.backgroundColor = "black";

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
	if not url.path then return false end

	local channel, uuid = url.path:match("^/([%a%d-_]+)/videos/([%w%-]+)")
	if channel and uuid then
		return { Data = channel .. "/videos/" .. uuid }
	end

	local data = url.path:match("^/([%a%d-_]+)")
	if data and not Ignored[data] then
		return { Data = data }
	end

	return false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("kick", SERVICE)

theater.RegisterService("kickvod", {
	Name = "Kick VOD",
	IsTimed = true,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
