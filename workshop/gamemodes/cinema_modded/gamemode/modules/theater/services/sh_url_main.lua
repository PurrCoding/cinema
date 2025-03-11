local url2 = url -- keep reference for extracting url data

local SERVICE = {}

SERVICE.Name = "URL"
SERVICE.IsTimed = true
SERVICE.Hidden = false

SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

-- Don't use the hosts of the other Services.
local isCinemaURLincluded = false
local excludedHosts = {
	"youtu.?be[.com]?",
	"bilibili.com",
	"b23.tv",
	"dailymotion.com",
	"archive.org",
	"ok.ru",
	"rutube.ru",
	"rumble.com",
	"sibnet.ru",
	"vk.com",
	"twitch.tv",
	"drive.google.com",
	"mega.nz",
	"dlive.tv",
	"kick.com"
}

-- Used for matching
local validExtensions = {}

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
	local allowed = true

	if url.file and validExtensions[ url.file.ext ] then
		allowed = true
	end

	if url.host then
		if CLIENT and not isCinemaURLincluded then
			isCinemaURLincluded = true

			local status, data2 = pcall( url2.parse2, url )
			if not status then
				isCinemaURLincluded = false
				return
			end

			table.insert(excludedHosts, data2.host )
		end

		for _, tld in pairs( excludedHosts ) do
			if url.host and url.host:find(tld) then
				allowed = false
				break
			end
		end
	end

	return allowed
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