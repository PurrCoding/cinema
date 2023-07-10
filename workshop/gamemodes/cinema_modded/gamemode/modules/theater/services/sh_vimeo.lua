local SERVICE = {}

SERVICE.Name = "Vimeo"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_COMPLETE

local API_URL = "https://vimeo.com/api/oembed.json?url=https://vimeo.com/%s"

function SERVICE:Match( url )
	return url.host and url.host:match("vimeo.com")
end

if (CLIENT) then
	local VIMEO_URL = "https://player.vimeo.com/video/%s?rel=0&autoplay=1"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = util.SecondsToISO_8601(startTime)
		else startTime = 0 end

		panel:OpenURL( VIMEO_URL:format( Video:Data() ) .. (self.IsTimed and "#t=" .. startTime or "" ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local data = url.path:match("/(%d+)")
		if ( data ) then return { Data = data } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )
		local response = util.JSONToTable(body)
		if not response then
			return onFailure( "Theater_RequestFailed" )
		end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if response.duration == 0 then
			info.type = "vimeolive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format( data )
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "vimeo", SERVICE )

theater.RegisterService( "vimeolive", {
	Name = "Vimeo Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )