-- TikTok service for Cinema created by agentsix1 ( https://github.com/agentsix1 )
local SERVICE = {
	Name = "Tiktok",
	IsTimed = true,

	Dependency = DEPENDENCY_COMPLETE,
	ExtentedVideoInfo = true
}


local EMBED_URL = "https://www.tiktok.com/embed/v3/%s"
local EMBED_PARAM = "?controls=0&fullscreen_button=0&play_button=0&volume_control=0&timestamp=0&loop=0&description=0&music_info=0&rel=0"

function SERVICE:Match(url)
	return url.host and url.host:match("tiktok.com")
end

if CLIENT then
	local THEATER_JS = [[
			var cookieClicked = false
			var checkerInterval = setInterval(function () {

				var player = document.getElementsByTagName("VIDEO")[0]
				if (!!player) {

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

					clearInterval(checkerInterval)

					player.setAttribute('controls', '')
					player.muted = false

					window.cinema_controller = player
					exTheater.controllerReady()
				}
			}, 50)
	]]

	local METADATA_JS = [[

		setTimeout(function(){
			(async () => {
				var contentID = "{@contentID}"
				var videosrc = await document.querySelector(`[href$=\"${contentID}\"]`)

				const response = await fetch(`https://www.tiktok.com/oembed?url=${videosrc.href}`)
				const json = await response.json()

				var player = document.getElementsByTagName("VIDEO")[0]
				if (!!player) {
					var title = json.title.length == 0 && `@${json.author_name} (${contentID})` || json.title.substr(0, 75) + " ..."
					var metadata = {
						duration: Math.round(player.duration),
						thumbnail: json.thumbnail_url,
						title: title
					}

					console.log("METADATA:" + JSON.stringify(metadata))
				}
			})()
		}, 500)
	]]

	local BROWSER_JS = [[
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
	]]

	function SERVICE:LoadProvider(Video, panel)
		panel:OpenURL(EMBED_URL:format(Video:Data()) ..
			EMBED_PARAM .. "&autoplay=1"
		)

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

		panel:OpenURL(EMBED_URL:format(data) ..
			EMBED_PARAM .. "&autoplay=0"
		)
	end

	function SERVICE:SearchFunctions( browser )
		if not IsValid( browser ) then return end

		browser:RunJavascript(BROWSER_JS)
	end
end

function SERVICE:GetURLInfo(url)

	if url.path then
		local data = url.path:match("/@[%a%w%d%_%.]+/video/(%d+)$")
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