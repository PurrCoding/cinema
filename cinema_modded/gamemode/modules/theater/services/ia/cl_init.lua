local url2 = url -- keep reference for extracting url data

local SERVICE = {
	Name = "Internet Archive",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,
	NeedsExtraChecks = true,

	EmbedURL = "https://archive.org/embed/%s?autoplay=1",
}

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
				var vid = root.querySelector && root.querySelector("video");
				if (vid) return vid;

				// Handle archive.org <play-av> shadow DOM
				var playAv = root.querySelector && root.querySelector("play-av");
				if (playAv && playAv.shadowRoot) {
					var v = findVideo(playAv.shadowRoot);
					if (v) return v;
				}

				// Traverse all elements and check for nested shadow roots
				var all = root.querySelectorAll ? root.querySelectorAll("*") : [];
				for (var i = 0; i < all.length; i++) {
					var el = all[i];
					if (el.shadowRoot) {
						var nested = findVideo(el.shadowRoot);
						if (nested) return nested;
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
			identifier = parts[2] and identifier .. "/" .. parts[2]
		end

		panel:OpenURL(SERVICE.EmbedURL:format(identifier))
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

if SERVER then
	return SERVICE
end

theater.RegisterService("ia", SERVICE)
