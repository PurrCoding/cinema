-- Soundcloud service for Cinema created by agentsix1 ( https://github.com/agentsix1 )
local SERVICE = {
	Name = "Soundcloud",
	IsTimed = true,

	Dependency = DEPENDENCY_COMPLETE,
	ExtentedVideoInfo = true
}

local Ignored = {
	["sets"] = true,
}


function SERVICE:Match(url)
	return url.host and url.host:match("soundcloud.com")
end

if CLIENT then
	local EMBED_HTML = [[
		<!doctype html>
		<html>

		<head>
			<script src="https://w.soundcloud.com/player/api.js"></script>
		</head>

		<body>
			<script>
				(async () => {
					const audioTrack = "https://soundcloud.com/{@audioPath}"
					const shouldPlay = {@shouldPlay}

					const response = await fetch(`https://soundcloud.com/oembed?format=json&url=${audioTrack}`)
					const json = await response.json()

					if (!!json && !!json.html) {
						const container = document.createElement('div');
						container.innerHTML = json.html;

						document.body.appendChild(container)
						document.body.style.overflow = 'hidden';

						const frame = container.firstElementChild
						var player = SC.Widget(frame);
						player.bind(SC.Widget.Events.READY, function () {
							var totalDuration = 0
							var curVol = 0
							var curTime = 0

							player.getDuration((duration) => {
								totalDuration = duration

								if (shouldPlay) {
									frame.setAttribute("height", window.innerHeight)

									setInterval(function () {
										player.getVolume((volume) => { curVol = volume });
										player.getPosition((currentTime) => { curTime = currentTime });
									}, 100);

									{ // Native audio controll
										player.volume = 0;
										player.currentTime = 0;
										player.duration = 0;

										Object.defineProperty(player, "volume", {
											get() {
												return curVol / 100;
											},
											set(volume) {
												player.setVolume(volume * 100);
											},
										});

										Object.defineProperty(player, "currentTime", {
											get() {
												return curTime / 1000;
											},
											set(time) {
												player.seekTo(time * 1000);
											},
										});

										Object.defineProperty(player, "duration", {
											get() {
												return totalDuration / 1000;
											},
										});

										player.play()
										window.cinema_controller = player
										exTheater.controllerReady()
									}
								} else {
									var metadata = {
										duration: Math.round(totalDuration / 1000),
										thumbnail: json.thumbnail_url,
										title: json.title
									}

									console.log("METADATA:" + JSON.stringify(metadata))
								}
							});
						});
					}
				})()

			</script>
		</body>

		</html>
	]]

	local BROWSER_JS = [[
		setInterval(() => {
			var cookieBanner = document.querySelector("#onetrust-banner-sdk #onetrust-reject-all-handler")
			if (!!cookieBanner) {cookieBanner.click()}
		}, 500);
	]]

	function SERVICE:LoadProvider(Video, panel)
		local html = EMBED_HTML
		html = html:Replace("{@audioPath}", Video:Data())
		html = html:Replace("{@shouldPlay}", "true")

		panel:SetHTML(html)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )

		local panel = self:CreateWebCrawler(callback)

		local html = EMBED_HTML
		html = html:Replace("{@audioPath}", data)
		html = html:Replace("{@shouldPlay}", "false")

		panel:SetHTML(html)

	end

	function SERVICE:SearchFunctions( browser )
		if not IsValid( browser ) then return end

		browser:RunJavascript(BROWSER_JS)
	end
end

function SERVICE:GetURLInfo(url)

	if url.path then
		local path1, path2 = url.path:match("/([%a%d-_]+)/([%a%d-_]+)$")
		if path1 and not Ignored[path1] and path2 then return { Data = ("%s/%s"):format(path1, path2)} end
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

theater.RegisterService("soundcloud", SERVICE)