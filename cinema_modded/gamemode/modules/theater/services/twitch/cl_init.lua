local SERVICE = theater.GetServiceByClass( "twitchstream" )

	local TWITCH_URL = "https://player.twitch.tv/?channel=%s&parent=pixeltailgames.com"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var matureAccept = document.querySelectorAll("[data-a-target=\"content-classification-gate-overlay-start-watching-button\"]")[0]
			if (!!matureAccept) {matureAccept.click(); return;}

			var player = document.getElementsByTagName('video')[0];
			var adOverlay = document.querySelectorAll("[data-test-selector=\"sad-overlay\"]")[0]

			if (!adOverlay && !!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);
				
				if (player.muted) {player.muted = false}

				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( TWITCH_URL:format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
