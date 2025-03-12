-- TikTok service for Cinema created by agentsix1 ( https://github.com/agentsix1 )
local SERVICE = {}

SERVICE.Name = "Tiktok"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

local EMBED_URL = "https://www.tiktok.com/embed/v3/%s"
local EMBED_PARAM = "?controls=0&fullscreen_button=0&play_button=0&volume_control=0&timestamp=0&loop=0&description=0&music_info=0&rel=0"

function SERVICE:Match(url)
	return url.host and url.host:match("tiktok.com")
end

if CLIENT then
	local THEATER_JS = [[
			var done = false
			var checkerInterval = setInterval(function () {

				var player = document.getElementsByTagName("VIDEO")[0]
				if (!!player) {

					var banner = document.querySelector("tiktok-cookie-banner")
					if (!!banner && !done) {
						var buttons = banner.shadowRoot.querySelectorAll(".tiktok-cookie-banner .button-wrapper button")

						if (!!buttons && !!buttons[1]) {
							var consent = buttons[1]

							consent.click()
							done = true
						} else {
							done = true
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
				{@Extras} // Added via LUA
				var videosrc = await document.querySelector(`[href$=\"${contentID}\"]`)

				const response = await fetch(`https://www.tiktok.com/oembed?url=${videosrc.href}`)
				const json = await response.json()

				var player = document.getElementsByTagName("VIDEO")[0]
				if (!!player) {
					var title = (json.title.length == 0 && `@${json.author_name} (${contentID})` || json.title.substr(0, 50)) + " ..."
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
		setInterval(() => {
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

		local panel = vgui.Create("DHTML")
		panel:SetSize(500,500)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		function panel:ConsoleMessage(msg)

			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				callback(metadata)
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)

				callback({ err = errmsg })
				panel:Remove()
			end
		end

		panel:OpenURL(EMBED_URL:format(data) ..
			EMBED_PARAM .. "&autoplay=0"
		)

		function panel:OnDocumentReady(url)
			if IsValid(panel) then
				panel:QueueJavascript(METADATA_JS:Replace("{@Extras}", ([[
					var contentID = "%s"
				]]):format(
						data
					)
				))
			end
		end

		timer.Simple(10, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end )
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