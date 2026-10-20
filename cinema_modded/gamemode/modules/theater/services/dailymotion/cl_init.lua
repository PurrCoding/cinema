local SERVICE = theater.GetServiceByClass( "dailymotion" )

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
