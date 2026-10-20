local SERVICE = theater.GetServiceByClass( "url_protocol" )

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
				<script src="https://cdn.jsdelivr.net/npm/hls.js@1"></script>
				<script src="https://cdn.dashjs.org/latest/dash.all.min.js"></script>

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

	function SERVICE:LoadProvider( Video, panel )
		local url = Video:Data()
		local urlParsed = ParseURL(url)
		local protocol = GetProtocol(urlParsed) or "hls"

		local html = THEATER_HTML:Replace("{@VideoSrc}", url)
		html = html:Replace("{@Protocol}", protocol)

		panel:SetHTML(html)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	function SERVICE:GetMetadata( data, callback )
		local panel = self:CreateWebCrawler(callback)
		local urlParsed = ParseURL(data)
		local protocol = GetProtocol(urlParsed) or "hls"

		local html = METADATA_HTML:Replace("{@VideoSrc}", data)
		html = html:Replace("{@Protocol}", protocol)

		panel:SetHTML(html)
	end


