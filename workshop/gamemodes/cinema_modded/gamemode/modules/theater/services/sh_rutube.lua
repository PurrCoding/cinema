local SERVICE = {
	Name = "Rutube",
	IsTimed = true,

	NeedsCodecFix = true
}

local API_URL = "https://rutube.ru/api/video/%s/?format=json"

function SERVICE:Match( url )
	return url.host and url.host:match("rutube.ru")
end

if (CLIENT) then
	local DAILYMOTION_URL = "https://rutube.ru/play/embed/%s?autoplay=1"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var consent = document.querySelector('button[type="button"]')
			if (!!consent && consent.innerText == "Мне уже есть 18 лет") {
				consent.click();
			}

			var poster = document.querySelector('img#raichuVideoPoster')
			if (!!poster) { poster.remove(); }

			var player = document.getElementsByTagName("VIDEO")[0];
			if (!!player) {
				if (player.paused) {player.play()}

				if (player.paused == false && player.readyState == 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					exTheater.controllerReady();

					player.addEventListener("pause", function(){
						player.play();
					});
				}
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = startTime
		else startTime = 0 end

		panel:OpenURL( DAILYMOTION_URL:format( Video:Data() ) .. (self.IsTimed and "&t=" .. startTime or "" ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:RunJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local data = url.path:match("^/video/([%a%d-_]+)/")
		if data then return { Data = data} end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable(body)
		if not response then
			return onFailure( "Theater_RequestFailed" )
		end

		local isLive = response.is_livestream
		local isPaid = response.is_paid
		local isAudio = response.is_audio
		local isDeleted = response.is_deleted

		if isPaid then return onFailure( "Service_PurchasableContent" ) end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if isLive then
			info.type = "rutubelive"
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
theater.RegisterService( "rutube", SERVICE )

theater.RegisterService( "rutubelive", {
	Name = "Rutube Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )