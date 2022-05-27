--[[
	███████╗██╗██╗     ███████╗
	██╔════╝██║██║     ██╔════╝
	█████╗  ██║██║     █████╗
	██╔══╝  ██║██║     ██╔══╝
	██║     ██║███████╗███████╗
	╚═╝     ╚═╝╚══════╝╚══════╝

		███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗
		██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝
		███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗
		╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝
		███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗
		╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝

    This Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!

	Info: This service was once only made for "KNAB-Networks Cinema", now some of them are available for third party use.
--]]

--[[ NOTE:

	This service has no API or method to collect metadata like the duration.
	For this reason, a length of 10 hours is displayed for each video.

]]--

local SERVICE = {}
SERVICE.Name = "File"
SERVICE.IsTimed = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local validExtensions = {
	["mp4"] = true,
	["webm"] = true,
}

function SERVICE:Match( url )
	return validExtensions[ string.GetExtensionFromFilename( url.path ) ]
end

if (CLIENT) then

	local HTML_BASE = [[
		<html>
		<head></head>
		<body style="margin:0px;background-color:black;overflow:hidden;">
			<div id="player-wrapper"></div>
		
			<script>
				var playedHooked = false;
				var video = document.createElement("video");
				video.src = "{@VideoURL}";
				video.autoplay = true;
				video.controls = false;
				video.muted = false;
				video.height = window.innerHeight;
				video.width = window.innerWidth;
				
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

	function SERVICE:LoadProvider( Video, panel )
		local url = Video:Data()

		if url:find("dropbox", 1, true) then
			url = url:gsub([[^http%://dl%.dropboxusercontent%.com/]], [[https://dl.dropboxusercontent.com/]])
			url = url:gsub([[^https?://dl.dropbox.com/]], [[https://www.dropbox.com/]])
			url = url:gsub([[^https?://www.dropbox.com/s/(.+)%?dl%=[01]$]], [[https://dl.dropboxusercontent.com/s/%1]])
			url = url:gsub([[^https?://www.dropbox.com/s/(.+)$]], [[https://dl.dropboxusercontent.com/s/%1]])
		end

		panel:SetHTML(HTML_BASE:Replace("{@VideoURL}", url))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end
end

function SERVICE:GetURLInfo( url )
	if url and url.encoded then
		return { Data = url.encoded }
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local info = {}
	info.title = ("File: %s"):format(data)
	info.thumbnail = self.PlaceholderThumb
	info.duration = 36000 -- 10 Hours

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "file", SERVICE )