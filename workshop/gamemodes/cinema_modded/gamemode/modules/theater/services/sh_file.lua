local SERVICE = {}

SERVICE.Name = "File"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

local validExtensions = {

	-- Video 
	["mp4"] = true,
	["webm"] = true,

	-- Audio
	["mp3"] = true,
	["m4a"] = true,
	["wav"] = true,
	["ogg"] = true,
}

function SERVICE:Match( url )
	return validExtensions[ string.GetExtensionFromFilename( url.path ) ]
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

	local function DropboxParse(url)
		url = url:gsub([[^http%://dl%.dropboxusercontent%.com/]], [[https://dl.dropboxusercontent.com/]])
		url = url:gsub([[^https?://dl.dropbox.com/]], [[https://www.dropbox.com/]])
		url = url:gsub([[^https?://www.dropbox.com/s/(.+)%?dl%=[01]$]], [[https://dl.dropboxusercontent.com/s/%1]])
		url = url:gsub([[^https?://www.dropbox.com/s/(.+)$]], [[https://dl.dropboxusercontent.com/s/%1]])

		return url
	end

	function SERVICE:LoadProvider( Video, panel )
		local url = Video:Data()

		if url:find("dropbox", 1, true) then
			url = DropboxParse(url)
		end

		panel:SetHTML(HTML_BASE:Replace("{@VideoURL}", url))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	function SERVICE:GetMetadata( data, callback )
		local panel = vgui.Create("HTML")
		panel:SetSize(100,100)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		if data:find("dropbox", 1, true) then
			data = DropboxParse(data)
		end

		function panel:ConsoleMessage(msg)
			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				callback(metadata)
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local code = tonumber(string.sub(msg, 7))

				callback({ err = util.MEDIA_ERR[code] or util.MEDIA_ERR[5] })
				panel:Remove()
			end
		end

		panel:SetHTML(HTML_METADATA:Replace( "{@VideoSrc}", data ))
	end
end

function SERVICE:GetURLInfo( url )
	if url and url.encoded then
		return { Data = url.encoded }
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = ("File: %s"):format(data:Data())
		info.duration = math.Round(tonumber(metadata.duration))

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "file", SERVICE )