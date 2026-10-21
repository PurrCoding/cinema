--[[
	Combined URL Media Service
	Separates basic formats (no GModPatchTool needed) from proprietary formats

	Basic Service: Images, WebM, Audio formats
	Proprietary Service: MP4, MOV, MKV formats

	Protocol Service: HLS, DASH (In separate script, also requires GModPatchTool)
--]]

local url2 = url

-- Format definitions - clearly separated for maintainability
local IMAGE_FORMATS = {
	jpg = true, jpeg = true, png = true, gif = true, bmp = true,
}

local BASIC_VIDEO_AUDIO_FORMATS = {
	-- Open video format (no GModPatchTool needed)
	webm = true, -- (VP8, VP9, AV1)
	-- Browser-supported audio formats
	mp3 = true, wav = true, ogg = true, m4a = true, aac = true, flac = true,
}

local PROPRIETARY_FORMATS = {
	-- Proprietary video formats (require GModPatchTool)
	mp4 = true, mov = true, mkv = true,
}

-- Combined basic formats for service matching
local BASIC_FORMATS = table.Merge(table.Copy(IMAGE_FORMATS), BASIC_VIDEO_AUDIO_FORMATS)

-- HTML templates optimized for different media types
local HTML_VIDEO_PLAYER = [[
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
	<style>
		* { margin: 0; padding: 0; box-sizing: border-box; }
		body {
			margin:0px;
			background-color:black;
			overflow:hidden;
		}
		video {
			width: 100%;
			height: 100%;
		}
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
		body {
			margin:0px;
			background-color:black;
			overflow:hidden;
		}
		img {
			width: 100%;
			height: 100%;
			object-fit: contain;
			image-rendering: auto;
		}
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

local function createService(name, codecSupport, formats)
	return {
		Name = name,
		IsTimed = true,
		NeedsCodecFix = codecSupport,
		ExtentedVideoInfo = true,
		IsCacheable = true,

		Match = function(self, url)
			-- Reject archive.org URLs with /details/ path to prevent conflicts
			if url.host and url.host:match("archive%.org") and
			   url.path and url.path:match("^/details/(.+)$") then
				return false
			end

			return url.file and formats[url.file.ext] or false
		end,

		GetURLInfo = function(self, url)
			if not url or not url.encoded then return false end
			return { Data = url.encoded }
		end,

		LoadProvider = CLIENT and function(self, Video, panel)
			local status, data2 = pcall(url2.parse2, Video:Data())
			if not status then
				ErrorNoHalt("[Cinema] Failed to parse URL: " .. tostring(data2))
				return
			end

			local fileext = data2.file and data2.file.ext
			if not fileext then return end

			-- Use appropriate template based on format type
			if IMAGE_FORMATS[fileext] then
				panel:SetHTML(HTML_IMAGE:Replace("{@ImageURL}", Video:Data()))
			else
				-- Video/audio formats use video player
				panel:SetHTML(HTML_VIDEO_PLAYER:Replace("{@VideoURL}", Video:Data()))
				panel.OnDocumentReady = function(pnl)
					self:LoadExFunctions(pnl)
				end
			end
		end or nil,

		GetMetadata = CLIENT and function(self, data, callback)
			local panel = self:CreateWebCrawler(callback)
			panel:SetHTML(HTML_METADATA:Replace("{@VideoSrc}", data))
		end or nil,

		-- GetVideoInfo is attached in sv_init.lua.
	}
end

-- Create services with clear naming
local basicService = createService("URL (Basic Media)", false, BASIC_FORMATS)
local proprietaryService = createService("URL (Proprietary Video)", true, PROPRIETARY_FORMATS)

-- Register all services on the client. On the server, return the service objects
-- so sv_init.lua can register them after including this file.
local imageTimedService = {
	Name = "URL (Timed Images)",
	IsTimed = true,
	NeedsCodecFix = false,
	Hidden = true,
	LoadProvider = CLIENT and basicService.LoadProvider or function() end,
}

local imageService = {
	Name = "URL (Images)",
	IsTimed = false,
	NeedsCodecFix = false,
	Hidden = true,
	LoadProvider = CLIENT and basicService.LoadProvider or function() end,
}

if SERVER then
	return {
		url_basic = basicService,
		url_proprietary = proprietaryService,
		image_timed = imageTimedService,
		image = imageService,
		url = url2,
		IMAGE_FORMATS = IMAGE_FORMATS,
		BASIC_VIDEO_AUDIO_FORMATS = BASIC_VIDEO_AUDIO_FORMATS,
		PROPRIETARY_FORMATS = PROPRIETARY_FORMATS,
	}
end

theater.RegisterService("url_basic", basicService)
theater.RegisterService("url_proprietary", proprietaryService)
theater.RegisterService("image_timed", imageTimedService)
theater.RegisterService("image", imageService)
