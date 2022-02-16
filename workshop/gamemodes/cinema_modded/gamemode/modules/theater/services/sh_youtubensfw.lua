--[[
    ██╗   ██╗ ██████╗ ██╗   ██╗████████╗██╗   ██╗██████╗ ███████╗
    ╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝██║   ██║██╔══██╗██╔════╝
     ╚████╔╝ ██║   ██║██║   ██║   ██║   ██║   ██║██████╔╝█████╗
      ╚██╔╝  ██║   ██║██║   ██║   ██║   ██║   ██║██╔══██╗██╔══╝
       ██║   ╚██████╔╝╚██████╔╝   ██║   ╚██████╔╝██████╔╝███████╗
       ╚═╝    ╚═════╝  ╚═════╝    ╚═╝    ╚═════╝ ╚═════╝ ╚══════╝

                ███╗   ██╗███████╗███████╗██╗    ██╗
                ████╗  ██║██╔════╝██╔════╝██║    ██║
                ██╔██╗ ██║███████╗█████╗  ██║ █╗ ██║
                ██║╚██╗██║╚════██║██╔══╝  ██║███╗██║
                ██║ ╚████║███████║██║     ╚███╔███╔╝
                ╚═╝  ╚═══╝╚══════╝╚═╝      ╚══╝╚══╝

    This Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!

	Info: This service was once only made for "KNAB-Networks Cinema", now some of them are available for third party use.
--]]

local SERVICE = {}

SERVICE.Name = "YouTube NSFW"
SERVICE.IsTimed = true
SERVICE.Hidden = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

if (CLIENT) then
	local THEATER_URL = "https://www.youtube.com/embed/%s?t=%s&autoplay=1&muted=1&controls=0&showinfo=0&modestbranding=1&rel=0&iv_load_policy=3"
	local THEATER_JS = [[
		function check() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}
		var checkerInterval = setInterval(check, 50);
	]]
	local agebypasser = nil

	-- Simple YouTube Age Restriction Bypass
	local function fetchAgeBypass()
		local function onSuccess(body, length, headers, code)
			if not body or code ~= 200 then return end

			agebypasser = body
		end

		local function onFailure(message)
			print("[Simple YouTube A.R.B]: " .. message)
		end

		http.Fetch("https://github.com/zerodytrash/Simple-YouTube-Age-Restriction-Bypass/releases/download/v2.3.5/Simple-YouTube-Age-Restriction-Bypass.user.js", onSuccess, onFailure, {})
	end
	fetchAgeBypass()

	function injectARB(panel)
		if not IsValid(panel) then return end

		if timer.Exists("YouTube.ARB") then
			timer.Remove("YouTube.ARB")
		end

		timer.Create("YouTube.ARB", .1, 60, function()
			if not IsValid(panel) then return end
			panel:RunJavascript(agebypasser)
		end)
	end

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( THEATER_URL:format(
			Video:Data(),
			math.Round(CurTime() - Video:StartTime())
		))

		injectARB(panel)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end
end

theater.RegisterService( "youtubensfw", SERVICE )