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

-- length parsing
local function ParseLength(value)
	if value == nil then return nil end

	-- Plain seconds string/number, e.g. "213.44"
	local seconds = tonumber(value)
	if isnumber(seconds) then
		return seconds
	end

	-- Colon-separated time string: MM:SS or HH:MM:SS
	if isstring(value) then
		local parts = string.Explode(":", value)
		local total = 0

		for _, part in ipairs(parts) do
			local n = tonumber(part)
			if not isnumber(n) then
				return nil -- unparseable segment
			end
			total = total * 60 + n
		end

		if #parts > 0 then
			return total
		end
	end

	return nil
end

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
		(function() {

			// Recursively search for a <video> element, including inside Shadow DOM
			function findVideo(root) {
				if (!root) return null;

				// Direct video element
				let vid = root.querySelector && root.querySelector("video");
				if (vid) return vid;

				// Handle archive.org <play-av> shadow DOM
				let playAv = root.querySelector && root.querySelector("play-av");
				if (playAv && playAv.shadowRoot) {
					let v = findVideo(playAv.shadowRoot);
					if (v) return v;
				}

				// Traverse all elements and check for nested shadow roots
				let all = root.querySelectorAll ? root.querySelectorAll("*") : [];
				for (let el of all) {
					if (el.shadowRoot) {
						let v = findVideo(el.shadowRoot);
						if (v) return v;
					}
				}

				return null;
			}

			// Poll until video element is available and ready
			var checkerInterval = setInterval(function() {
				var player = findVideo(document);

				if (player && player.readyState >= 2) {
					clearInterval(checkerInterval);

					// Expose player globally for Lua controls
					window.cinema_controller = player;

					// Force fullscreen-like layout
					player.style.width = "100%";
					player.style.height = "100%";
					document.body.style.backgroundColor = "black";

					exTheater.controllerReady();
				}
			}, 100);

		})();
	]]

	-- It's overkill, but hey, why not? ¯\_(ツ)_/¯
	local REQUEST_JS = [[
	(function watchForJWPlayer() {

		let lastState = null;
		let lastVideoSrc = null;
		let playerDetected = false;
		let isVideoPlaying = false;

		// --- Deep Shadow DOM video search (supports play-av and nested players)
		function findVideoDeep(root) {
			if (!root) return null;

			let vid = root.querySelector && root.querySelector("video");
			if (vid && (vid.currentSrc || vid.readyState > 0)) return vid;

			let all = root.querySelectorAll ? root.querySelectorAll("*") : [];
			for (let el of all) {
				if (el.shadowRoot) {
					let v = findVideoDeep(el.shadowRoot);
					if (v) return v;
				}
			}
			return null;
		}

		// --- Update UI state
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

		// --- Core detection logic
		const checkVideoSources = () => {

			// Method 0: Deep Shadow DOM scan (NEW - covers play-av)
			const deepVideo = findVideoDeep(document);
			if (deepVideo) {
				return {
					found: true,
					metadata: {
						detected: true,
						source: deepVideo.currentSrc,
						method: 'deep-shadow-scan',
						readyState: deepVideo.readyState
					}
				};
			}

			// Method 1: JWPlayer API
			if (typeof window.jwplayer === 'function') {
				try {
					const player = window.jwplayer();
					if (player && player.getPlaylist) {
						const playlist = player.getPlaylist();
						if (playlist && playlist.length > 0) {
							const currentIndex = player.getPlaylistItem() || 0;
							const currentItem = playlist[currentIndex];
							if (currentItem && currentItem.file) {
								return {
									found: true,
									metadata: {
										detected: true,
										source: currentItem.file,
										method: 'jwplayer-api',
										playlistIndex: currentIndex,
										playlistLength: playlist.length,
										title: currentItem.title || 'unknown'
									}
								};
							}
						}
					}
				} catch (e) {
					// silent fail
				}
			}

			// Method 2: Standard DOM selectors
			const selectors = [
				'video',
				'video[src]',
				'.jwplayer video',
				'video.jw-video',
				'.jw-media video',
				'[data-jwplayer-id] video'
			];

			for (const selector of selectors) {
				const videos = document.querySelectorAll(selector);
				for (const video of videos) {
					if (video.currentSrc || (playerDetected && video.readyState > 0)) {
						return {
							found: true,
							metadata: {
								detected: true,
								source: video.currentSrc || 'jwplayer-active',
								method: 'dom-selector',
								selector: selector,
								readyState: video.readyState
							}
						};
					}
				}
			}

			// fallback: keep previous state if player was already detected
			return { found: playerDetected, metadata: null };
		};

		// --- Initial detection
		const initialResult = checkVideoSources();
		updateState(initialResult.found, initialResult.metadata);

		// --- JWPlayer event hooks (if present)
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

				player.on('play', () => {
					console.log("[IA-DETECT] Video playing");
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
				// silent fail
			}
		}

		// --- Continuous monitoring
		const monitorInterval = setInterval(() => {
			const result = checkVideoSources();

			// keep button enabled while actively playing
			if (isVideoPlaying && typeof gmod !== 'undefined' && gmod.updateRequestButton) {
				gmod.updateRequestButton(true);
			} else {
				updateState(result.found, result.metadata);
			}
		}, 1000);

		// --- DOM observer for dynamic changes
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

		console.log("[IA-DETECT] Shadow DOM + JWPlayer detection initialized");

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

		local duration = ParseLength(bestMatch.length)
		if not isnumber(duration) then
			return onFailure("Invalid video length in metadata")
		end

		local info = {
			title = GenerateTitle(response, bestMatch, identifier),
			duration = math.Round(duration),
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