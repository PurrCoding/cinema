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
local DOWNLOAD_URL = "https://cors.archive.org/download/%s/%s"

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

	local BROWSERVER_JS = [[
		(function watchForJWVideo() {
			const selector = "video.jw-video";

			const updateState = (hasVideo) => {
				gmod.updateRequestButton(!!hasVideo);
			};

			const attachWatcher = (video) => {
				console.log("[JWVideo] Watcher attached:", video);

				const onMetadataLoaded = () => {
					const hasVideo = !!video.currentSrc;
					updateState(hasVideo);

					if (hasVideo) {
						const playPromise = video.play();
						if (playPromise) {
							playPromise.catch(err => {
								console.warn("[JWVideo] Autoplay blocked:", err.message);
							});
						}
					}
				};

				const onError = () => {
					console.warn("[JWVideo] Failed to load video:", video.src);
					updateState(false);
				};

				const observer = new MutationObserver(mutations => {
					for (const m of mutations) {
						if (m.attributeName === "src") {
							console.log("[JWVideo] Source changed to:", video.src);
							updateState(false);
							video.removeEventListener("loadedmetadata", onMetadataLoaded);
							video.removeEventListener("error", onError);
							video.addEventListener("loadedmetadata", onMetadataLoaded, { once: true });
							video.addEventListener("error", onError, { once: true });
						}
					}
				});

				observer.observe(video, { attributes: true });

				// Handle initial state
				if (video.src) {
					if (video.readyState >= 1) {
						onMetadataLoaded();
					} else {
						video.addEventListener("loadedmetadata", onMetadataLoaded, { once: true });
						video.addEventListener("error", onError, { once: true });
					}
				} else {
					updateState(false);
				}
			};

			// --- Fast detection helper ---
			const detectVideo = () => document.querySelector(selector);

			const tryAttach = () => {
				const video = detectVideo();
				if (video) {
					attachWatcher(video);
					return true;
				}
				return false;
			};

			// If video already exists right now → attach immediately
			if (tryAttach()) return;

			// --- Early repeated microtask checks ---
			// This loop checks multiple times within the first 2 seconds — faster than waiting for DOM mutation
			let quickTries = 0;
			const fastCheck = setInterval(() => {
				if (tryAttach()) {
					clearInterval(fastCheck);
					clearTimeout(stopFastCheck);
				}
				quickTries++;
				if (quickTries > 20) return; // safeguard
			}, 100);

			const stopFastCheck = setTimeout(() => {
				clearInterval(fastCheck);

				// Fallback: full MutationObserver if still not found
				const domObserver = new MutationObserver(() => {
					if (tryAttach()) {
						domObserver.disconnect();
						console.log("[JWVideo] Video detected via MutationObserver.");
					}
				});

				domObserver.observe(document.body, { childList: true, subtree: true });
				console.log("[JWVideo] Using fallback DOM observer (video not found quickly).");
			}, 2000);

			console.log("[JWVideo] Watching for video creation...");
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		local parts = string.Explode(",", Video:Data())
		local identifier = parts[1]
		local fileName = parts[2]

		if not fileName then
			return -- Should not happen with metadata handling
		end

		local videoUrl = DOWNLOAD_URL:format(identifier, fileName)

		panel:OpenURL(videoUrl)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:SearchFunctions(browser)
		if not IsValid(browser) then return end

		browser:RunJavascript(BROWSERVER_JS)
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
			thumbnail = GetThumbnail(response.files, bestMatch.name),
			data = identifier .. "," .. bestMatch.name
		}

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local url = METADATA_URL:format(identifier)
	self:Fetch(url, processMetadata, onFailure)
end

theater.RegisterService("ia", SERVICE)