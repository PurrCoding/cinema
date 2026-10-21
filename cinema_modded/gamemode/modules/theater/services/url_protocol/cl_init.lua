local SERVICE = {
	Name = "URL (Protocol)",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,

	HLSLibraryURL = "https://cdn.jsdelivr.net/npm/hls.js@1",
	DASHLibraryURL = "https://cdn.dashjs.org/latest/dash.all.min.js",
}

local validExtensions = {
	["m3u8"] = "hls", -- HLS
	["mpd"] = "dash", -- DASH
}

local function ParseURL(urlString)
	local status, parsed = pcall(url.parse2, urlString)
	if status then
		return parsed
	end
	return nil
end

local function GetProtocol(url)
	if url.file and validExtensions[url.file.ext] then
		return validExtensions[url.file.ext]
	end
	return nil
end

function SERVICE:Match(url)
	if url.file and validExtensions[url.file.ext] then
		return true
	end
	return false
end

function SERVICE:GetURLInfo(url)
	if url and url.encoded then
		return { Data = url.encoded }
	end
	return false
end

if CLIENT then
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

				<!-- Load all streaming libraries -->
				<script src="__HLS_LIBRARY_URL__"></script>
				<script src="__DASH_LIBRARY_URL__"></script>

				<script>
					var video = document.getElementById('video');
					var protocol = "{@Protocol}";
					var videoSrc = "{@VideoSrc}";

					function initializePlayer() {
						switch(protocol) {
							case 'hls':
								if (Hls.isSupported()) {
									var hls = new Hls();
									hls.loadSource(videoSrc);
									hls.attachMedia(video);

									hls.once(Hls.Events.LEVEL_LOADED, function(event, data) {
										window.cinema_controller = video;
										exTheater.controllerReady();
									});

									hls.on(Hls.Events.ERROR, function(event, data) {
										console.log("HLS ERROR: " + data.details);
									});
								}
								break;

							case 'dash':
								if (typeof dashjs !== 'undefined' && dashjs.supportsMediaSource()) {
									var player = dashjs.MediaPlayer().create();
									player.initialize(video, videoSrc, true);

									player.on(dashjs.MediaPlayer.events.STREAM_INITIALIZED, function() {
										window.cinema_controller = video;
										exTheater.controllerReady();
									});

									player.on(dashjs.MediaPlayer.events.ERROR, function(event) {
										console.log("DASH ERROR: " + event.error);
									});
								}
								break;
						}
					}

					{@JS_Content}
				</script>
			</body>
		</html>
	]]
	HTML_BASE = HTML_BASE:Replace("__HLS_LIBRARY_URL__", SERVICE.HLSLibraryURL):Replace("__DASH_LIBRARY_URL__", SERVICE.DASHLibraryURL)

	local THEATER_HTML = HTML_BASE:Replace("{@JS_Content}", [[
		video.autoplay = true;
		initializePlayer();
	]])

	local METADATA_HTML = HTML_BASE:Replace("{@JS_Content}", [[
		function extractMetadata() {
			switch(protocol) {
				case 'hls':
					if (Hls.isSupported()) {
						var hls = new Hls();
						hls.loadSource(videoSrc);
						hls.attachMedia(video);

						hls.once(Hls.Events.LEVEL_LOADED, function(event, data) {
							var metadata = {
								duration: data.details.totalduration,
								live: data.details.live
							}
							console.log("METADATA:" + JSON.stringify(metadata));
						});
					}
					break;

				case 'dash':
					if (typeof dashjs !== 'undefined' && dashjs.supportsMediaSource()) {
						var player = dashjs.MediaPlayer().create();
						player.initialize(video, videoSrc, false);

						player.on(dashjs.MediaPlayer.events.STREAM_INITIALIZED, function() {
							var metadata = {
								duration: player.duration(),
								live: player.isDynamic()
							}
							console.log("METADATA:" + JSON.stringify(metadata));
						});
					}
					break;
			}
		}

		extractMetadata();
	]])

	function SERVICE:LoadProvider(Video, panel)
		local url = Video:Data()
		local urlParsed = ParseURL(url)
		local protocol = GetProtocol(urlParsed) or "hls"

		local html = THEATER_HTML:Replace("{@VideoSrc}", url)
		html = html:Replace("{@Protocol}", protocol)

		panel:SetHTML(html)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
		end
	end

	function SERVICE:GetMetadata(data, callback)
		local panel = self:CreateWebCrawler(callback)
		local urlParsed = ParseURL(data)
		local protocol = GetProtocol(urlParsed) or "hls"

		local html = METADATA_HTML:Replace("{@VideoSrc}", data)
		html = html:Replace("{@Protocol}", protocol)

		panel:SetHTML(html)
	end

end

-- Register the multi-protocol service
if SERVER then
	return SERVICE
end

theater.RegisterService("url_protocol", SERVICE)

-- Register live streaming variant
theater.RegisterService("url_protocol_live", {
	Name = "URL (Protocol, Live)",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
