--[[
    This "VKontakte" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}

SERVICE.Name = "Sibnet"
SERVICE.IsTimed = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local API_URL = "https://gmod-cinema.pages.dev/api/sibnet?v=%s"

function SERVICE:Match( url )
	return url.host and url.host:match("video.sibnet.ru")
end

if (CLIENT) then
	local EMBED_URL = "https://video.sibnet.ru/shell.php?videoid=%s" 
	local THEATER_JS = [[
		function check() {
			var preplayer = document.getElementById("video_html5_wrapper_html5_api")
			if (!!preplayer) {
				clearInterval(checkerInterval);
		
				window.location.href = preplayer.src;
			} else {
				var player = document.getElementsByTagName('video')[0];
	
				if (!!player) {
					if (player.error && player.error.code && player.error.code === 4) {return;} 
	
					if (player.paused) { player.play(); }
					if (!player.paused && player.readyState === 4) {
						clearInterval(checkerInterval);
						window.cinema_controller = player;
	
						exTheater.controllerReady();
		
						player.preload = 'auto';
						player.autoplay = true;
						player.style.height = "100%";
						player.style.width = "100%";
						player.style.background = "black"
						player.style.overflow = 'hidden';
		
					}
				}
			}
		}
		var checkerInterval = setInterval(check, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( EMBED_URL:format(Video:Data()) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local videoID = url.path:match("/video(%d+)-")
		if videoID then return { Data = videoID } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable( body )
		if not response then
			return onFailure("Sibnet: No response from API")
		end

		local info = {}
		info.title = ("Sibnet: %s"):format(data)
		info.thumbnail = response.thumbnail
		if response.duration == "0" then
			return onFailure("Sibnet: Livestream currently not supported")
		else
			info.duration = response.duration
		end

		info.data = response.embed

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format(data)
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "sibnet", SERVICE )