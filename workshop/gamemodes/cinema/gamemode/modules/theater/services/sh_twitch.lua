local SERVICE = {}

local THUMB_URL = "https://static-cdn.jtvnw.net/previews-ttv/live_user_%s-1280x720.jpg"

SERVICE.Name = "Twitch.TV Stream"
SERVICE.IsTimed 	= false

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

if CLIENT then

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

			var video = document.getElementsByTagName('video')[0];
			if (!testSelector("div", "sad-overlay") && !!video && video.paused == false && video.readyState == 4) {
				clearInterval(checkerInterval);

				window.player = video;
				console.log("INTERFACE_START");
			}
		}
		var checkerInterval = setInterval(check, 250);
	]]

	function SERVICE:LoadPlayer( Video, panel )

		local url = TWITCH_URL:format( Video:Data() )

		local panel = theater.ActivePanel()
		panel:Stop()
		panel:OpenURL( url )

		panel.OnFinishLoading = function(self)
			panel:RunJavascript(THEATER_JS)
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