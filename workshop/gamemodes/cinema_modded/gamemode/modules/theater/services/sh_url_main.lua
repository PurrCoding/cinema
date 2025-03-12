local SERVICE = {
	Name = "URL",
	IsTimed = true,

	Dependency = DEPENDENCY_COMPLETE,
	ExtentedVideoInfo = true
}

local url2 = url -- keep reference for extracting url data
local validExtensions = {} -- Used for matching

local imageExtensions = {
	["jpg"] = true,
	["png"] = true,
	["bmp"] = true,
	["jpeg"] = true,
	["gif"] = true,
}
validExtensions = table.Merge(validExtensions, imageExtensions)

local videoExtensions = {
	["mp4"] = true,
	["webm"] = true,
	["mov"] = true,
}
validExtensions = table.Merge(validExtensions, videoExtensions)

function SERVICE:Match( url )
	return (url.file and validExtensions[ url.file.ext ] and true or false)
end

if (CLIENT) then

	local HTML_BASE = [[
		<html>
		<head></head>
		<body>
			<style>
				body {
					margin:0px;
					background-color:black;
					overflow:hidden;
				}

				video {
					height: 100%;
					width: 100%;
				}
			</style>

			<div id="player-wrapper"></div>

			<script>
				var video = document.createElement("video");
				video.src = "{@VideoURL}";
				video.autoplay = true;
				video.controls = true;
				video.muted = false;

				document.getElementById("player-wrapper").appendChild(video);
			</script>

			<script>
				var checkerInterval = setInterval(function() {
					if (!video.paused && video.readyState === 4) {
						clearInterval(checkerInterval);

						window.cinema_controller = video;
						exTheater.controllerReady();
					}
				}, 50);
			</script>

		</body>
		</html>
	]]

	local HTML_METADATA = [[
		<html><body> <video id="video" src="{@VideoSrc}" preload="metadata"></video>
			<script>
				const video = document.querySelector('video');
				video.onloadedmetadata = function() {
					var metadata = { duration: video.duration }

					console.log("METADATA:" + JSON.stringify(metadata))
				};
				video.onerror = function() { console.log("ERROR:" + video.error.code ) };
			</script>
		</body></html>
	]]

	function SERVICE:LoadProvider( Video, panel )
		local url = Video:Data()

		panel:SetHTML(HTML_BASE:Replace("{@VideoURL}", url))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	function SERVICE:GetMetadata( data, callback )

		local panel = self:CreateWebCrawler(callback)
		panel:SetHTML(HTML_METADATA:Replace( "{@VideoSrc}", data ))

	end
end

function SERVICE:GetURLInfo( url )
	if url and url.encoded then
		local info = {}

		info.Data = url.encoded
		return info
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local status, data2 = pcall( url2.parse2, data:Data() )
	if not status then
		return onFailure( "ERROR:\n" .. tostring(data2) )
	end

	local fileext = data2.file.ext
	local filename = data2.file.name

	if imageExtensions[ fileext ] then
		local info = {}
		info.title = ("Image: %s"):format(filename)

		local duration = GetConVar("cinema_service_imageduration"):GetInt()
		if duration > 0 then
			info.type = "image_timed"
			info.duration = duration
		else
			info.type = "image"
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

		return
	end

	if videoExtensions[ fileext ] then
		theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

			if metadata.err then
				return onFailure(metadata.err)
			end

			local info = {}
			info.title = ("URL: %s"):format(filename)
			info.duration = math.Round(tonumber(metadata.duration))

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
	end

end

theater.RegisterService( "url", SERVICE )