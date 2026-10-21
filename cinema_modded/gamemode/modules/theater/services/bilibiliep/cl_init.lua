--[[
	Bilibili Bangumi Support by OriginalSnow
	Note: You can edit this code. But you cant upload anymore.
]]

local SERVICE = {
	Name = "哔哩哔哩番剧",
	IsTimed = true,

	NeedsCodecFix = true,

	PlayerURL = "https://www.bilibili.com/bangumi/play/ep%s",
}

function SERVICE:Match(url)
	local host = url.host or ""
	local path = url.path or ""
	return host:match("www.bilibili.com") and string.find(path, "/bangumi/play/ep[%w*].") or false
end

if CLIENT then

	local JS = [[
		var checkerVideoInterval = setInterval(function() {
			var player = document.getElementsByTagName("video")[0];
			if (player && player.paused !== false) {
				document.getElementsByClassName("squirtle-video-pagefullscreen squirtle-video-item")[0].click();
				clearInterval(checkerVideoInterval);
				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	local fullscreenRequest = [[
		var checkerFullScreenInterval = setInterval(function() {
			var wrap = document.getElementById("bilibili-player-wrap");
			var isFullScreen = wrap && wrap.classList[0] && wrap.classList[0].indexOf("video_playerFullScreen") > -1;
			if (!isFullScreen) {
				var btn = document.getElementsByClassName("squirtle-video-pagefullscreen squirtle-video-item")[0];
				if (btn) btn.click();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider(vi, p)
		p:OpenURL(SERVICE.PlayerURL:format(vi:Data()))
		p.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(JS)
			timer.Simple(5, function()
				if IsValid(pnl) then
					pnl:QueueJavascript(fullscreenRequest)
				end
			end)
		end
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}
	local host = url.host or ""
	local path = url.path or ""
	if host:match("www.bilibili.com") then
		local s = string.match(path, "ep[%w*]+")
		if s then
			local s1 = string.Split(s, "ep")
			info.Data = s1[2]
		end
	end
	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("bilibiliep", SERVICE)
