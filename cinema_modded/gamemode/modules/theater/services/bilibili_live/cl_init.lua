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
