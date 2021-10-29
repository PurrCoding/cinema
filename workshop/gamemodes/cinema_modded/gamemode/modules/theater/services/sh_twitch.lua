local SERVICE = {}

local THUMB_URL = "https://static-cdn.jtvnw.net/previews-ttv/live_user_%s-1280x720.jpg"

SERVICE.Name = "Twitch.TV Stream"
SERVICE.IsTimed = false

--[[
	Uncomment this line below to restrict Livestreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

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
		function testSelector(elem, dataStr) {
			var data = document.querySelectorAll( elem + "[data-test-selector]")
			for (let i=0; i<data.length; i++) {
				var selector = data[i].dataset.testSelector
				if (!!selector && selector === dataStr) {
					return data[i]
					break
				}
			}
		}

		function target(dataStr) {
			var data = document.querySelectorAll( "button[data-a-target]")
			for (let i=0; i<data.length; i++) {
				var selector = data[i].dataset.aTarget
				if (!!selector && selector === dataStr) {
					return data[i]
					break
				}
			}
		}

		function check() {
			var mature = target("player-overlay-mature-accept")
			if (!!mature) {mature.click(); return;}

			var player = document.getElementsByTagName('video')[0];
			if (!testSelector("div", "sad-overlay") && !!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}
		var checkerInterval = setInterval(check, 50);
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