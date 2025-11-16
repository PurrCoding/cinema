local SERVICE = {
	Name = "Mega",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

local PREVIEW_URL = "https://mega.nz/embed/%s"

local ValidTypes = {
	["embed"] = true,
	["file"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("mega.nz")
end

if (CLIENT) then

	local THEATER_JS = [[
		(async () => {
			var done = false
			var checkerInterval = setInterval(function () {

				var plybtn = document.querySelector('.play-video-button');
				var player = document.getElementsByTagName('video')[0];

				if (!!player) {
					if (!!plybtn && player.paused ) { 
						player.setAttribute('webkit-playsinline', 'webkit-playsinline');
						player.click(); 
						return;
					}

					//Check if we have the correct element
					if (player.id && player.id === "video" && player.id === video.id ) { 
					
						//Check if its playing and duration is not NaN
						if (!player.paused && !Number.isNaN(player.duration)) {
							
							// Check if we already done
							if (done) { return } 

							done = true

							window.cinema_controller = player;
							exTheater.controllerReady();
						}
					} else{ //Skip any video ads
						player.currentTime = 9999
					}
				}

			}, 50);
		})();
	]]

	local METADATA_JS = [[
		(async () => {
			var done = false
			var checkerInterval = setInterval(function () {

				var plybtn = document.querySelector('.play-video-button');
				var player = document.getElementsByTagName('video')[0];

				if (!!player) {
					if (!!plybtn && player.paused ) { 
						player.setAttribute('webkit-playsinline', 'webkit-playsinline');
						player.click(); 
						return;
					}

					//Check if we have the correct element
					if (player.id && player.id === "video" && player.id === video.id ) { 
					
						//Check if its playing and duration is not NaN
						if (!player.paused && !Number.isNaN(player.duration)) {
							
							// Check if we already done
							if (done) { return } 
						
							clearInterval(checkerInterval);

							done = true
							player.volume = 0

							var title = document.title.replace("MEGA - ", "")
							var metadata = { 
								duration: player.duration,
								title: title
							}

							console.log("METADATA:" + JSON.stringify(metadata))
						}
					} else{ //Skip any video ads
						player.currentTime = 9999
					}
				}

			}, 50);
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

	local authority, path, data, key = url.encoded:match("^https?://(.+%..+)/(%a+)/([%a%d-_]+)#([%a%d-_]+)$")
	if (authority and authority == "mega.nz") and ValidTypes[path] and key then
		info.Data = ("%s#%s"):format(data, key)
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

theater.RegisterService( "mega", SERVICE )