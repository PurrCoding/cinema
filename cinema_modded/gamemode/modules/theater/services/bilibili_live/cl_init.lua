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

--[[
	Cinema Modded Bilibili Live Support
	Powered by OriginalSnow

	You can edit this code. But you cant upload anymore.
]]

-- Last update : 2026/05/07

local SERVICE = {
	Name = "哔哩哔哩直播",
	IsTimed = false,

	NeedsCodecFix = true,

	PlayerURL = "https://www.bilibili.com/blackboard/live/live-mobile-playerV3.html?roomId=%s&danmaku=1&autoplay=1",
}

function SERVICE:Match(url)
	local host = url.host or ""
	local path = url.path or ""
	return host:match("live.bilibili.com") and string.find(path, "/[%w*].")
end

if CLIENT then

	local JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("video")[0];
			if (player && player.paused === false && player.readyState === 4) {
				clearInterval(checkerInterval);

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
			pnl:QueueJavascript(JS)
		end
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}
	local host = url.host or ""
	local path = url.path or ""
	if host:match("live.bilibili.com") then
		info.Data = string.match(path, "[%w*]+")
	end
	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("bilibili_live", SERVICE)
