local SERVICE = {
	Name = "Rumble",
	IsTimed = true,

	NeedsCodecFix = true,
}

local API_URL = "https://rumble.com/api/Media/oembed.json?url=https://rumble.com/%s"

function SERVICE:Match( url )
	return url.host and url.host:match("rumble.com")
end

if (CLIENT) then
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				if (player.muted) {player.muted = false}

				clearInterval(checkerInterval);

				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local function onFail(msg)
			LocalPlayer():ChatPrint(("Rumble: %s"):format(msg))
		end

		local url = API_URL:format( Video:Data() ) .. ".html"
		self:Fetch( url, function( body, length, headers, code )
			local response = util.JSONToTable(body)
			if not response then
				return onFail("API Error")
			end

			local startTime = math.Round(CurTime() - Video:StartTime())
			local embed = response.html:match("(https://rumble.com/embed/[%a%d-_]+/)")
				.. "?pub=7a20&rel=5&autoplay=2"
				.. (self.IsTimed and "&t=" .. startTime or "" )

			panel:OpenURL(embed)
			panel.OnDocumentReady = function(pnl)
				self:LoadExFunctions( pnl )
				pnl:QueueJavascript(THEATER_JS)
			end

		end, onFail)

	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local data = url.path:match("/([%a%d%p-_]+).html")
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
			info.type = "rumblelive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format( data ) .. ".html"
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "rumble", SERVICE )

theater.RegisterService( "rumblelive", {
	Name = "Rumble Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )