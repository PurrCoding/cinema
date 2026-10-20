local SERVICE = {
	Name = "Dailymotion",
	IsTimed = true,

	NeedsCodecFix = true
}



function SERVICE:Match( url )
	return url.host and url.host:match("dailymotion.com")
end

if (CLIENT) then
	local DAILYMOTION_URL = "https://geo.dailymotion.com/player.html?video=%s&rel=0&autoplay=1"
	local THEATER_JS = [[
		(function() {
			var checkerInterval = setInterval(function() {
				var player = document.querySelector(".video_view video");
				if (!!player && player.paused == false && player.readyState == 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = startTime
		else startTime = 0 end

		panel:OpenURL( DAILYMOTION_URL:format( Video:Data() ) .. (self.IsTimed and "&start=" .. startTime or "" ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:RunJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://dailymotion/video/xxxxxxxxx
	if (url.path and url.path:match("^/video/([%a%d-_]+)")) then
		info.Data = url.path:match("^/video/([%a%d-_]+)")
	end

	if (url.query) then

		if url.query.start and url.query.start ~= "" then
			local time = tonumber(url.query.start)
			if time and time ~= 0 then
				info.StartTime = time
			end
		end

	end

	return info.Data and info or false
end


SERVICE.ClassName = "dailymotion"

if SERVER then
	return SERVICE
end

theater.RegisterService(SERVICE)

theater.RegisterService( "dailymotionlive", {
	Name = "Dailymotion Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
