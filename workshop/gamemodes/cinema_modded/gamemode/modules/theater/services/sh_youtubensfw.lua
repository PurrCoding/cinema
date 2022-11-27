--[[
    This "YouTube NSFW" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}

SERVICE.Name = "YouTube NSFW"
SERVICE.ParentClass = "youtube"
SERVICE.IsTimed = true
SERVICE.Hidden = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

if (CLIENT) then
	local SYTARB_JS = "" -- Empty by default
	local THEATER_URL = "https://www.youtube.com/embed/%s?autoplay=1&muted=1&controls=0&showinfo=0&modestbranding=1&rel=0&iv_load_policy=3&unlock_confirmed=1"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}, 50);
	]]

	do -- Simple YouTube Age Restriction Bypass
		local SYTARB_URL = "https://github.com/zerodytrash/Simple-YouTube-Age-Restriction-Bypass/releases/latest/download/Simple-YouTube-Age-Restriction-Bypass.user.js"

		local retry = 0
		local function msg(str)
			print("[Simple YouTube A.R.B]: " .. str)
		end

		local function run()
			http.Fetch(SYTARB_URL, function(body, length, headers, code)
				if not body or code ~= 200 then
					msg(("Not expected response received from GitHub (Code: %d)"):format(code))
					return
				end

				SYTARB_JS = body
				msg("Script loaded successfully")
			end, function(error)
				retry = retry + 1

				if retry < 5 then
					msg(("(#%d) Retrying in 10 Seconds again.."):format(retry))
					timer.Simple(10, run)
				else
					msg(("After %d attempts the script could not be loaded, maybe there is a problem on GitHub"):format(retry))
					msg("(Error Message) " .. error)
				end

			end, {})
		end

		hook.Add("PostGamemodeLoaded", "SYTARB.Loader", run)
		hook.Add("OnReloaded", "SYTARB.Loader", run)
	end

	function injectARB(panel)
		if not IsValid(panel) then return end

		if timer.Exists("YouTube.ARB") then
			timer.Remove("YouTube.ARB")
		end

		timer.Create("YouTube.ARB", .1, 60, function()
			if not IsValid(panel) then return end
			panel:RunJavascript(SYTARB_JS)
		end)
	end

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( THEATER_URL:format( Video:Data()) )

		injectARB(panel)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end
end

theater.RegisterService( "youtubensfw", SERVICE )