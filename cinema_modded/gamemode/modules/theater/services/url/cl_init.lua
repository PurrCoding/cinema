local url2 = url

local IMAGE_FORMATS = {
	jpg = true, jpeg = true, png = true, gif = true, bmp = true
}

local HTML_VIDEO_PLAYER = [[
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
	<style>
		* { margin: 0; padding: 0; box-sizing: border-box; }
		body { margin:0px; background-color:black; overflow:hidden; }
		video { width: 100%; height: 100%; }
	</style>
	<video id="cinema-player" src="{@VideoURL}" autoplay controls preload="metadata"></video>
	<script>
		(function() {
			const video = document.getElementById('cinema-player');
			video.addEventListener('loadedmetadata', function() {
				window.cinema_controller = video;
				exTheater.controllerReady();
			});
			video.addEventListener('error', function(e) {
				console.error('Video error:', e);
			});
		})();
	</script>
</body>
</html>
]]

local HTML_IMAGE = [[
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
	<style>
		* { margin: 0; padding: 0; box-sizing: border-box; }
		body { margin:0px; background-color:black; overflow:hidden; }
		img { width: 100%; height: 100%; object-fit: contain; image-rendering: auto; }
	</style>
	<img src="{@ImageURL}" alt="Theater Image" />
</body>
</html>
]]

local HTML_METADATA = [[
<html>
<head><meta charset="utf-8"></head>
<body>
	<video id="metadata-video" src="{@VideoSrc}" preload="metadata" style="display:none;"></video>
	<script>
		(function() {
			const video = document.getElementById('metadata-video');
			video.onloadedmetadata = function() {
				const metadata = {
					duration: video.duration,
					videoWidth: video.videoWidth || 0,
					videoHeight: video.videoHeight || 0
				};
				console.log("METADATA:" + JSON.stringify(metadata));
			};
			video.onerror = function() {
				console.log("ERROR:" + (video.error ? video.error.code : 'unknown'));
			};
		})();
	</script>
</body>
</html>
]]

local function AttachClientMethods(class)
	local service = theater.GetServiceByClass(class)
	if not service then return end

	function service:LoadProvider(Video, panel)
		local status, data2 = pcall(url2.parse2, Video:Data())
		if not status then
			ErrorNoHalt("[Cinema] Failed to parse URL: " .. tostring(data2))
			return
		end

		local fileext = data2.file and data2.file.ext
		if not fileext then return end

		if IMAGE_FORMATS[fileext] then
			panel:SetHTML(HTML_IMAGE:Replace("{@ImageURL}", Video:Data()))
		else
			panel:SetHTML(HTML_VIDEO_PLAYER:Replace("{@VideoURL}", Video:Data()))
			panel.OnDocumentReady = function(pnl)
				self:LoadExFunctions(pnl)
			end
		end
	end

	function service:GetMetadata(data, callback)
		local panel = self:CreateWebCrawler(callback)
		panel:SetHTML(HTML_METADATA:Replace("{@VideoSrc}", data))
	end
end

AttachClientMethods("url_basic")
AttachClientMethods("url_proprietary")
