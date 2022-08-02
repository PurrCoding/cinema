local SERVICE = {}

SERVICE.Name = "VK"
SERVICE.IsTimed = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local API_URL = "https://gmod-cinema.pages.dev/api/vk?v=%s"

function SERVICE:Match( url )
	return url.host and url.host:match("vk.com")
end

if (CLIENT) then
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player) {

				if (player.paused) { player.play(); }
				if (!player.paused && player.readyState === 4) {
					if (player.muted) {player.muted = false}
	
					clearInterval(checkerInterval);
	
					document.body.style.backgroundColor = "black";
					window.cinema_controller = player;

					exTheater.controllerReady();
				}
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( Video:Data() .. "&autoplay=1" )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	if (url.query and url.query.z) then
		local data = url.query.z:match("[video%-(%d+)_(%d+)]+")
		if data then return { Data = data } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable( body )
		if not response then
			return onFailure("VK: No response from API")
		end

		local info = {}
		info.title = ("VK: %s"):format(data)
		info.thumbnail = response.thumbnail
		if response.duration == "0" then
			return onFailure("VK: Livestream currently not supported")
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

theater.RegisterService( "vk", SERVICE )