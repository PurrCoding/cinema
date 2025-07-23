local SERVICE = {
	Name = "Twitch.TV Stream",
	IsTimed = false,

	NeedsCodecFix = true
}

local THUMB_URL = "https://static-cdn.jtvnw.net/previews-ttv/live_user_%s-1280x720.jpg"
local Ignored = {
	["video"] = true,
	["directory"] = true,
	["downloads"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("twitch.tv")
end

if (CLIENT) then
	local TWITCH_URL = "https://player.twitch.tv/?channel=%s&parent=pixeltailgames.com"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var matureAccept = document.querySelectorAll("[data-a-target=\"content-classification-gate-overlay-start-watching-button\"]")[0]
			if (!!matureAccept) {matureAccept.click(); return;}

			var player = document.getElementsByTagName('video')[0];
			var adOverlay = document.querySelectorAll("[data-test-selector=\"sad-overlay\"]")[0]

			if (!adOverlay && !!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( TWITCH_URL:format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local data = url.path:match("/([%w_]+)")
		if (data and not Ignored[data]) then return { Data = data } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local info = {}
	info.title = ("Twitch Stream: %s"):format(data)
	info.thumbnail = THUMB_URL:format(data)

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "twitchstream", SERVICE )