local SERVICE = {
	Name = "Google Drive",
	IsTimed = true,

	Dependency = DEPENDENCY_COMPLETE,
	ExtentedVideoInfo = true
}

local PREVIEW_URL = "https://drive.google.com/file/d/%s/preview?autoplay=true"

function SERVICE:Match( url )
	return url.host and url.host:match("drive.google.com")
end

if (CLIENT) then

	local THEATER_JS = [[
		(async  () => {
			var player = YT.get("ucc-2");

			player.addEventListener("onReady", function() {
				player.setVolume(0)
			})

			var done = false;
			player.addEventListener("onStateChange", function(event) {
				if (event.data == YT.PlayerState.PLAYING && !done) {
					done = true;

					{ // Native video controll
						player.volume = 0;
						player.currentTime = 0;
						player.duration = player.getDuration();

						Object.defineProperty(player, "volume", {
							get() {
								return player.getVolume();
							},
							set(volume) {
								if (player.isMuted()) {
									player.unMute();
								}
								player.setVolume(volume * 100);
							},
						});

						Object.defineProperty(player, "currentTime", {
							get() {
								return Number(player.getCurrentTime());
							},
							set(time) {
								player.seekTo(time, true);
							},
						});
					}

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			})
		})();
	]]

	local METADATA_JS = [[
		(async  () => {
			var player = YT.get("ucc-2");

			player.addEventListener("onReady", function() {
				player.setVolume(0)
			})

			var done = false;
			player.addEventListener("onStateChange", function(event) {
				if (event.data == YT.PlayerState.PLAYING && !done) {
					done = true;

					var title = document.querySelector("meta[property='og:title']").getAttribute("content");
					var metadata = { 
						duration: player.getDuration(),
						title: title
					}

					console.log("METADATA:" + JSON.stringify(metadata))	
				}
			})
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )
		panel:OpenURL(PREVIEW_URL:format(Video:Data()))

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )

		local panel = self:CreateWebCrawler(callback)

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(METADATA_JS)
			end
		end

		panel:OpenURL(PREVIEW_URL:format(data))

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://drive.google.com/file/d/(fileId)
	if url.path and url.path:match("^/file/d/([%a%d-_]+)/") then
		info.Data = url.path:match("^/file/d/([%a%d-_]+)/")
	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.duration = tonumber(metadata.duration)

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "gdrive", SERVICE )