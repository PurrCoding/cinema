--[[
	 █████╗ ███╗   ██╗██╗███╗   ███╗██╗██╗  ██╗    ██████╗ ██╗      █████╗ ██╗   ██╗
	██╔══██╗████╗  ██║██║████╗ ████║██║╚██╗██╔╝    ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝
	███████║██╔██╗ ██║██║██╔████╔██║██║ ╚███╔╝     ██████╔╝██║     ███████║ ╚████╔╝
	██╔══██║██║╚██╗██║██║██║╚██╔╝██║██║ ██╔██╗     ██╔═══╝ ██║     ██╔══██║  ╚██╔╝
	██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║██╔╝ ██╗    ██║     ███████╗██║  ██║   ██║
	╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝

            ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗
            ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝
            ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗
            ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝
            ███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗
            ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝

    This Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!

	Info: This service was once only made for "KNAB-Networks Cinema", now some of them are available for third party use.
--]]

--[[ NOTE:

	This service has no API or method to collect metadata like the duration.
	For this reason, a length of 10 hours is displayed for each video.
	
	For security and reliability reasons, only GOGO Stream is supported.
]]--

local SERVICE = {}
SERVICE.Name = "AniMix Play"
SERVICE.IsTimed = true
-- SERVICE.TheaterType = THEATER_PRIVATE

local Versions = {
	["v1"] = "animixplay_v1", -- GOGO Stream
}

function SERVICE:Match( url )
	return url.host and url.host:match("animixplay.to")
end

if (CLIENT) then
	local BASE_URL = "https://animixplay.to/%s/%s"

	local THEATER_JS = {
		["animixplay_v1"] = [[
			function check() {
				if (typeof (iframeplayer) != 'undefined') {
					if (!iframeplayer.src) {return;}
					clearInterval(checkerInterval);
	
					window.location.replace(iframeplayer.src);
				} else {
					if (typeof (player1) != 'undefined') {
						if (!player1.media) {return;}
						if (player1.paused) {
							player1.play();
							return;
						}
		
						clearInterval(checkerInterval);

						window.cinema_controller = player1.media;
						exTheater.controllerReady();
					}
				}
			}
			var checkerInterval = setInterval(check, 150);
		]]
	}

	function SERVICE:LoadProvider( Video, panel )
		local animeID = string.Explode(",", Video:Data())
		local url = BASE_URL:format(animeID[1], animeID[2])

		panel:OpenURL(url)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS[Video:Type()])
		end
	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local version, src = url.path:match("^/(v%d+)/(.+)")
		if ( version and Versions[version] and src ) then
			return { Data = version .. "," .. src }
		end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local animeData = string.Explode(",", data)

	local info = {}
	info.type = Versions[ animeData[1] ]
	info.title = ("AniMix Play: %s"):format(animeData[2])
	info.thumbnail = self.PlaceholderThumb
	info.duration = 36000 -- 10 Hours

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "animixplay_v1", SERVICE )