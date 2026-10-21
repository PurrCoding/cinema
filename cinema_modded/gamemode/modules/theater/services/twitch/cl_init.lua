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
