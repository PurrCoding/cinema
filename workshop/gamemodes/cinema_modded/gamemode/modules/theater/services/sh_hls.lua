--[[
    This "HLS" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}
SERVICE.Name = "HLS Video"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local validExtensions = {

	-- Video
	["m3u8"] = true,
}

function SERVICE:Match( url )
	return validExtensions[ string.GetExtensionFromFilename( url.path ) ]
end

if (CLIENT) then

	local HTML_BASE = [[
		<!DOCTYPE html>

		<head></head>
		<html>
			<body>
				<style>
					body {
						margin: 0px;
						background-color: black;
						overflow: hidden;
					}

					.videoWrapper video {
						position: absolute;
						top: 0;
						left: 0;
						width: 100%;
						height: 100%;
					}
				</style>

				<div class="videoWrapper">
					<video id="video"></video>
				</div>

				<script src="https://cdn.jsdelivr.net/npm/hls.js@1"></script>
				<script>
					var video = document.getElementById('video');

					if (Hls.isSupported()) {
						var hls = new Hls();
						hls.loadSource("{@VideoSrc}");
						hls.attachMedia(video);

						{@JS_Content}
					}
				</script>
			</body>
		</html>
	]]

	local THEATER_HTML = HTML_BASE:Replace("{@JS_Content}", [[
		video.autoplay = true

		hls.once(Hls.Events.LEVEL_LOADED, function(event, data) {
			window.cinema_controller = video;
			exTheater.controllerReady();
		});
	]])

	local METADATA_HTML = HTML_BASE:Replace("{@JS_Content}", [[
		hls.once(Hls.Events.LEVEL_LOADED, function(event, data) {
			var metadata = {
				duration: data.details.totalduration,
				live: data.details.live
			}

			console.log("METADATA:" + JSON.stringify(metadata))
		});

		hls.on(Hls.Events.ERROR, function(event, data) {
			console.log("ERROR:" + data.details )
		});
	]])

	function SERVICE:LoadProvider( Video, panel )
		local url = Video:Data()

		panel:SetHTML(THEATER_HTML:Replace("{@VideoSrc}", url))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	function SERVICE:GetMetadata( data, callback )
		local panel = vgui.Create("HTML")
		panel:SetSize(100,100)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		function panel:ConsoleMessage(msg)
			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				callback(metadata)
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)

				callback({ err = errmsg })
				panel:Remove()
			end
		end

		panel:SetHTML(METADATA_HTML:Replace( "{@VideoSrc}", data ))
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
		info.title = ("HLS: %s"):format(data:Data())
		info.thumbnail = self.PlaceholderThumb

		if metadata.live then
			info.type = "hls_live"
			info.duration = 0
		else
			info.duration = math.Round(tonumber(metadata.duration))
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "hls", SERVICE )
theater.RegisterService( "hls_live", {
	Name = "HLS Live",
	IsTimed = false,
	Dependency = DEPENDENCY_COMPLETE,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )