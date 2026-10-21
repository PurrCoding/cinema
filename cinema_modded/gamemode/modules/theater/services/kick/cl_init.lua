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
