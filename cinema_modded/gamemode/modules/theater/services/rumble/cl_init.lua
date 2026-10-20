local SERVICE = theater.GetServiceByClass( "rumble" )

	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				if (player.muted) { player.muted = false; }

				// Full-bleed black stage (same idea as Kick)
				document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
				document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";

				document.body.appendChild(player);
				var children = Array.prototype.slice.call(document.body.childNodes);
				for (var i = 0; i < children.length; i++) {
					if (children[i] !== player) {
						try { document.body.removeChild(children[i]); } catch (e) {}
					}
				}

				player.style.cssText = [
					"position:fixed",
					"top:0",
					"left:0",
					"width:100%",
					"height:100%",
					"max-width:100%",
					"max-height:100%",
					"object-fit:contain",
					"background:#000",
					"z-index:9999",
					"margin:0",
					"padding:0",
					"border:none"
				].join(";");

				player.removeAttribute("controls");
				player.controls = false;

				window.cinema_controller = player;
				exTheater.controllerReady();

				setTimeout(function() {
					if (window.cinema_controller && window.cinema_controller.muted) {
						window.cinema_controller.muted = false;
					}
				}, 300);
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local function onFail(msg)
			LocalPlayer():ChatPrint(("Rumble: %s"):format(msg))
		end

		local data = Video:Data()
		local isShort = isstring(data) and data:StartWith("shorts/")
		local oembedUrl = API_URL:format( data ) .. (isShort and "" or ".html")

		self:Fetch( oembedUrl, function( body, length, headers, code )
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
