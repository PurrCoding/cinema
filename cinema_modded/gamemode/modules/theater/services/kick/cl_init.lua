local SERVICE = theater.GetServiceByClass( "kick" )

	local THEATER_JS = [[
		(async () => {
			var checkerInterval = setInterval(function () {

				var matureWarn = document.querySelector("button[data-test=\"mature\"]")
				if (!!matureWarn) {
					matureWarn.click();
					matureWarn.remove()
				}

				var player = document.getElementById("video-player")
				if (!!player) {
					clearInterval(checkerInterval);

					if (player.muted) {player.muted = false}

					document.body.appendChild(player)
					var main = document.querySelector("div[class^=\"group/main\"]")
					if (main) { main.remove() }
					document.body.style.backgroundColor = "black";

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( ("https://kick.com/%s"):format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
