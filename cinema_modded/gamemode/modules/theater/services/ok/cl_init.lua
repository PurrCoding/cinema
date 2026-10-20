local SERVICE = theater.GetServiceByClass( "ok" )

	local EMBED_URL = "https://ok.ru/videoembed/%s?autoplay=1"
	local THEATER_JS = [[
		(function() {

			// Recursively search for a <video> element, including inside Shadow DOM
			function findVideo(root) {
				if (!root) return null;

				// Direct video element
				let vid = root.querySelector && root.querySelector("video");
				if (vid) return vid;

				// Handle ok divs "shadow-root-container" shadow DOM
				let rootContainer = root.querySelector && root.querySelector(".shadow-root-container");
				if (rootContainer && rootContainer.shadowRoot) {
					let v = findVideo(rootContainer.shadowRoot);
					if (v) return v;
				}

				// Traverse all elements and check for nested shadow roots
				let all = root.querySelectorAll ? root.querySelectorAll("*") : [];
				for (let el of all) {
					if (el.shadowRoot) {
						let v = findVideo(el.shadowRoot);
						if (v) return v;
					}
				}

				return null;
			}

			// Poll until video element is available and ready
			var checkerInterval = setInterval(function() {
				var player = findVideo(document);

				if (!player.paused && player.readyState === 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 100);

		})();
	]]

	function SERVICE:LoadProvider( Video, panel )
		local data = string.Explode(",", Video:Data())
		local typeID, videoID = data[1], data[2]

		panel:OpenURL( EMBED_URL:format(videoID) )
		print(EMBED_URL:format(videoID))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
