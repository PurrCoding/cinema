local SERVICE = {}

SERVICE.Name = "Vimeo"
SERVICE.IsTimed = true
-- SERVICE.TheaterType = THEATER_PRIVATE

local API_URL = "https://vimeo.com/api/oembed.json?url=https://vimeo.com/%s"

function SERVICE:Match( url )
	return string.match(url.host, "vimeo.com") and string.match(url.path, "^/(%d+)")
end

if (CLIENT) then
	local VIMEO_URL = "https://player.vimeo.com/video/%s?rel=0&autoplay=1"
	local THEATER_JS = [[
		function check() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}
		var checkerInterval = setInterval(check, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( VIMEO_URL:format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}
	info.Data = string.match(url.path, "/(%d+)")

	return info

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )
		if not body or code ~= 200 then
			return onFailure( "Service_EmbedDisabled" )
		end

		local response = util.JSONToTable(body)
		if not response then
			return onFailure( "Theater_RequestFailed" )
		end

		local info = {}
		info.title = response.title
		info.duration = response.duration
		info.thumbnail = response.thumbnail_url

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format( data )
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "vimeo", SERVICE )