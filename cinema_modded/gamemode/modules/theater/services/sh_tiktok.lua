-- TikTok service for Cinema created by agentsix1 ( https://github.com/agentsix1 )
local SERVICE = {
	Name = "Tiktok",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

local EMBED_PARAM = "?controls=1&fullscreen_button=0&play_button=0&volume_control=0&timestamp=0&loop=0&description=0&music_info=0&rel=0"
local EMBED_URL = "https://www.tiktok.com/embed/v3/%s" .. EMBED_PARAM

function SERVICE:Match(url)
	return url.host and url.host:match("tiktok.com")
end

if CLIENT then
	local THEATER_JS = [[
		(async function() {
			let cookieClicked = false;
			let playerReady = false;
			const startTime = Date.now();

			const observePlayer = () => {
				return new Promise((resolve) => {
					const observer = new MutationObserver(async (mutations, obs) => {
						const player = document.querySelector("video");

						if (player && !playerReady) {
							// Handle cookie banner first
							const banner = document.querySelector("tiktok-cookie-banner");
							if (banner && !cookieClicked) {
								const buttons = banner.shadowRoot?.querySelectorAll(".tiktok-cookie-banner .button-wrapper button");
								if (buttons?.[0]) {
									buttons[0].click();
									cookieClicked = true;
									return;
								}
								cookieClicked = true;
							}

							// Wait for video to be ready
							if (player.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA) {
								playerReady = true;
								obs.disconnect();

								// Setup video controls
								player.setAttribute('controls', '');

								// Click to enable audio context
								player.click();

								// Start playback
								player.play().catch(error => {
									console.log("Play failed, trying again:", error);
									// Retry after a short delay
									setTimeout(() => {
										player.click();
										player.play();
									}, 100);
								});

								window.cinema_controller = player
								exTheater.controllerReady()
								resolve(player);
							}
						} else if (Date.now() - startTime > 10000 && !playerReady) {
							obs.disconnect();
							console.log("Video player not found or not ready");
							resolve(null);
						}
					});

					observer.observe(document.body, {
						childList: true,
						subtree: true,
						attributes: true,
						attributeFilter: ['readyState']
					});
				});
			};

			await observePlayer();
		})();
	]]

local METADATA_JS = [[
		setTimeout(() => {
			(async () => {
				const contentID = "{@contentID}";
				let videosrc = document.querySelector(`[href$="${contentID}"]`);

				if (!videosrc) {
					videosrc = { href: `https://www.tiktok.com/@unknown/video/${contentID}` };
				}

				try {
					const response = await fetch(`https://www.tiktok.com/oembed?url=${videosrc.href}`);
					const json = await response.json();

					// Check if video is embeddable
					if (json.error || !json.html) {
						console.log("ERROR:Video is not embeddable or private");
						return;
					}

					const player = document.getElementsByTagName("VIDEO")[0];
					if (!!player) {
						// Wait for metadata to load with timeout
						let attempts = 0;
						const maxAttempts = 10; // 5 seconds

						const checkDuration = setInterval(() => {
							attempts++;

							if (player.duration && player.duration > 0 && !isNaN(player.duration)) {
								clearInterval(checkDuration);

								const title = json.title.length == 0 ? `@${json.author_name} (${contentID})` : json.title.substr(0, 75) + " ...";
								const metadata = {
									duration: Math.round(player.duration),
									thumbnail: json.thumbnail_url,
									title: title
								};

								console.log("METADATA:" + JSON.stringify(metadata));
							} else if (attempts >= maxAttempts) {
								clearInterval(checkDuration);
								console.log("ERROR:Video duration cannot be detected after timeout");
							}
						}, 500);
					} else {
						console.log("ERROR:Video player not found - may not be embeddable");
					}
				} catch (error) {
					console.log("ERROR:Failed to fetch video metadata - " + error.message);
				}
			})();
		}, 500);
	]]

	local BROWSER_JS = [[
		(async function() {
			var cookieClicked = false

			setInterval(() => {
				{ // Guestmode
					const guestModeContainer = document.querySelector('[class*="DivGuestModeContainer"]');
					if (guestModeContainer) {
						console.log('DivGuestModeContainer found:', guestModeContainer);

						const boxContainer = guestModeContainer.querySelector('[class*="DivBoxContainer"]');
						if (boxContainer) {
							boxContainer.click();
							console.log('DivBoxContainer clicked:', boxContainer);
						} else {
							console.log('DivBoxContainer not found inside DivGuestModeContainer');
						}
					} else {
						console.log('DivGuestModeContainer not found');
					}
				}

				{ // Cookie Consent
					var banner = document.querySelector("tiktok-cookie-banner")
						if (!!banner && !cookieClicked) {
							var buttons = banner.shadowRoot.querySelectorAll(".tiktok-cookie-banner .button-wrapper button")

							if (!!buttons && !!buttons[0]) {
								var consent = buttons[0]

								consent.click()
								cookieClicked = true
							} else {
								cookieClicked = true
							}

							return;
						}
					}
			}, 500);
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		panel:OpenURL(EMBED_URL:format(Video:Data()))

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )

		local panel = self:CreateWebCrawler(callback)
		local js = METADATA_JS
		js = js:Replace("{@contentID}", data)

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(js)
			end
		end

		print(EMBED_URL:format(data))
		panel:OpenURL(EMBED_URL:format(data))
	end

	function SERVICE:SearchFunctions( browser )
		if not IsValid( browser ) then return end

		browser:RunJavascript(BROWSER_JS)
	end
end

function SERVICE:GetURLInfo(url)

	if url.path then
		local data = url.path:match("/@[^/]+/video/(%d+)")
		if data then return { Data = data} end
	end

	return false
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.duration = tonumber(metadata.duration)
		info.thumbnail = metadata.thumbnail

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)
end

theater.RegisterService("tiktok", SERVICE)