local url2 = url -- keep reference for extracting url data

local SERVICE = {
	Name = "Internet Archive",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,
	NeedsExtraChecks = true

}

-- API endpoints
local METADATA_URL = "https://archive.org/metadata/%s"
local EMBED_URL = "https://archive.org/embed/%s?autoplay=1"

-- format support
local VALID_FORMATS = {
	["MPEG4"] = true,
	["h.264"] = true,
	["h.264 IA"] = true,
	["Ogg Video"] = true,
	["WebM"] = true,
	["MP4"] = true,
	["AVI"] = true,
	["MOV"] = true,
	["MKV"] = true,
	["Flac"] = true,
	["VBR MP3"] = true,
}

-- file selection logic
local function FindBestVideoFile(files, requestedFile)
	local candidates = {}

	for _, file in pairs(files) do
		if VALID_FORMATS[file.format] and file.name then
			-- Prioritize requested file
			if requestedFile then
				local normalizedRequested = requestedFile:gsub("+", " ")
				local normalizedFile = file.name:gsub("+", " ")

				if file.original == normalizedRequested or
				   file.name == requestedFile or
				   normalizedFile == normalizedRequested then
					return file
				end
			end

			table.insert(candidates, file)
		end
	end

	if #candidates == 0 then return nil end

	-- If no file was requested, take the first one from the list
	return candidates[1]
end

-- title generation
local function GenerateTitle(response, file, identifier)
	if response.metadata and response.metadata.title then
		local title = response.metadata.title
		if istable(title) then
			title = title[1] or identifier
		end

		-- Add file info if it's part of a collection
		if file.name and file.name ~= title then
			local fileName = file.name:gsub("%.%w+$", "") -- Remove extension
			fileName = fileName:gsub("+", " ") -- Replace + with spaces
			return title .. " - " .. fileName
		end

		return title
	end

	-- Fallback to file name
	if file.name then
		local title = file.name:gsub("%.%w+$", ""):gsub("+", " ")
		return title
	end

	return "Internet Archive: " .. identifier
end

-- thumbnail handling
local function GetThumbnail(files, videoFileName)
	local baseName = videoFileName:gsub("%.%w+$", "")

	for _, file in pairs(files) do
		if file.format == "Thumbnail" then
			-- Look for thumbnails matching the video file
			if file.original and file.original:find(baseName, 1, true) then
				return file.name
			end

		end
	end

	-- no thumbnail
	return nil
end

function SERVICE:Match(url)
	return url.host and url.host:match("archive.org")
end

if CLIENT then

	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("VIDEO")[0]
			if (!!player) {
				if (player.paused) {player.play();}
				if (player.paused === false && player.readyState === 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					player.style = "width:100%; height: 100%;";

					exTheater.controllerReady();
				}
			}
		}, 50);
	]]

	-- It's overkill, but hey, why not? ¯\_(ツ)_/¯
	local REQUEST_JS = [[
		(function watchForJWPlayer() {
			let lastState = null;
			let lastVideoSrc = null;
			let playerDetected = false;
			let isVideoPlaying = false;

			const updateState = (hasVideo, metadata = null) => {
				const currentVideoSrc = metadata ? metadata.source : null;
				const stateChanged = (lastState !== hasVideo) || (lastVideoSrc !== currentVideoSrc);

				if (stateChanged) {
					lastState = hasVideo;
					lastVideoSrc = currentVideoSrc;
					playerDetected = hasVideo;

					if (typeof gmod !== 'undefined' && gmod.updateRequestButton) {
						gmod.updateRequestButton(!!hasVideo);
					}

					if (hasVideo && metadata) {
						console.log("[IA-DETECT] Video detected:", JSON.stringify(metadata, null, 2));
					} else if (!hasVideo && lastVideoSrc !== null) {
						console.log("[IA-DETECT] Video lost");
					}
				}
			};

			const checkVideoSources = () => {
				// Method 1: JWPlayer API check - always active
				if (typeof window.jwplayer === 'function') {
					try {
						const player = window.jwplayer();
						if (player && player.getPlaylist) {
							const playlist = player.getPlaylist();
							if (playlist && playlist.length > 0) {
								const currentIndex = player.getPlaylistItem() || 0;
								const currentItem = playlist[currentIndex];
								if (currentItem && currentItem.file) {
									const metadata = {
										detected: true,
										source: currentItem.file,
										method: 'jwplayer-api',
										playlistIndex: currentIndex,
										playlistLength: playlist.length,
										title: currentItem.title || 'unknown'
									};
									return { found: true, metadata };
								}
							}
						}
					} catch (e) {
						// Silent fail
					}
				}

				// Method 2: Universal video element detection
				const universalSelectors = [
					'video',
					'video[src]',
					'.jwplayer video',
					'video.jw-video',
					'.jw-media video',
					'[data-jwplayer-id] video'
				];

				for (const selector of universalSelectors) {
					const videos = document.querySelectorAll(selector);
					for (const video of videos) {
						if (video.currentSrc || (playerDetected && video.readyState > 0)) {
							const metadata = {
								detected: true,
								source: video.currentSrc || 'jwplayer-active',
								method: 'dom-selector',
								selector: selector,
								readyState: video.readyState
							};
							return { found: true, metadata };
						}
					}
				}

				// Only mark as not found if we never detected a player
				return { found: playerDetected, metadata: null };
			};

			// Initial check
			const initialResult = checkVideoSources();
			updateState(initialResult.found, initialResult.metadata);

			// Hook into JWPlayer events
			if (typeof window.jwplayer === 'function') {
				try {
					const player = window.jwplayer();

					player.on('ready', () => {
						const result = checkVideoSources();
						updateState(result.found, result.metadata);
					});

					player.on('playlistItem', () => {
						setTimeout(() => {
							const result = checkVideoSources();
							updateState(result.found, result.metadata);
						}, 300);
					});

					// Track playback state
					player.on('play', () => {
						console.log("[IA-DETECT] Video playing - enabling continuous trigger");
						isVideoPlaying = true;
					});

					player.on('pause', () => {
						console.log("[IA-DETECT] Video paused");
						isVideoPlaying = false;
						const result = checkVideoSources();
						updateState(result.found, result.metadata);
					});

					player.on('complete', () => {
						console.log("[IA-DETECT] Video completed");
						isVideoPlaying = false;
						const result = checkVideoSources();
						updateState(result.found, result.metadata);
					});
				} catch (e) {
					// Silent fail
				}
			}

			// CRITICAL: Continuous monitoring with playback trigger
			const monitorInterval = setInterval(() => {
				const result = checkVideoSources();

				// KEY CHANGE: If video is playing, always keep button enabled
				if (isVideoPlaying && typeof gmod !== 'undefined' && gmod.updateRequestButton) {
					gmod.updateRequestButton(true);
					console.log("[IA-DETECT] Playback trigger - keeping button enabled");
				} else {
					updateState(result.found, result.metadata);
				}
			}, 1000);

			// DOM observer
			const observer = new MutationObserver(() => {
				const result = checkVideoSources();
				updateState(result.found, result.metadata);
			});

			observer.observe(document.body, {
				childList: true,
				subtree: true,
				attributes: true,
				attributeFilter: ['src', 'currentSrc']
			});

			console.log("[IA-DETECT] Continuous detection with playback trigger initialized");
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		local parts = string.Explode(",", Video:Data())
		local identifier = parts[1]

		if parts[2] then
			identifier = (parts[2] and identifier .. "/" .. parts[2])
		end

		panel:OpenURL( EMBED_URL:format(identifier) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:SearchFunctions(browser)
		if not IsValid(browser) then return end

		browser:RunJavascript(REQUEST_JS)
	end
end

function SERVICE:GetURLInfo(url)
	if not url.path then return false end

	-- Extract identifier
	local identifier = url.path:match("^/details/([^/]+)")
	if not identifier then return false end

	-- Extract specific file if present
	local file = url.path:match("^/details/[^/]+/(.+)$")

	-- Handle URL encoding
	if file then
		file = url2.unescape(file)
	end

	return {
		Data = identifier .. (file and "," .. file or ""),
	}
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local parts = string.Explode(",", data:Data())
	local identifier = parts[1]
	local requestedFile = parts[2]

	local function processMetadata(body, length, headers, code)
		if code ~= 200 or not body then
			return onFailure("Failed to fetch metadata from Internet Archive")
		end

		local response = util.JSONToTable(body)
		if not response or not response.files then
			return onFailure("Invalid metadata response")
		end

		local bestMatch = FindBestVideoFile(response.files, requestedFile)
		if not bestMatch then
			return onFailure("No compatible video files found")
		end

		local info = {
			title = GenerateTitle(response, bestMatch, identifier),
			duration = math.Round(bestMatch.length or 0),
			thumbnail = GetThumbnail(response.files, bestMatch.name)
		}

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local url = METADATA_URL:format(identifier)
	self:Fetch(url, processMetadata, onFailure)
end

theater.RegisterService("ia", SERVICE)