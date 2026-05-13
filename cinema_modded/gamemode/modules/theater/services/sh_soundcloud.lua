-- Soundcloud service for Cinema created by agentsix1 ( https://github.com/agentsix1 )
local SERVICE = {
	Name = "Soundcloud",
	IsTimed = true,

	NeedsCodecFix = false,
	ExtentedVideoInfo = true
}

local Ignored = {
	["sets"] = true,
}

function SERVICE:Match(url)
	return url.host and url.host:match("soundcloud.com")
end

if CLIENT then
	function SERVICE:LoadProvider(Video, panel)
		local html = [[
			<!doctype html>
			<html>
			<head>
				<script src="https://w.soundcloud.com/player/api.js"></script>
			</head>
			<body>
				<script>
					(async () => {
						const audioTrack = "https://soundcloud.com/{@audioPath}"

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
									frame.setAttribute("height", window.innerHeight)

									setInterval(function () {
										player.getVolume((volume) => { curVol = volume });
										player.getPosition((currentTime) => { curTime = currentTime });
									}, 100);

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
								});
							});
						}
					})()
				</script>
			</body>
			</html>
		]]

		html = html:Replace("{@audioPath}", Video:Data())
		panel:SetHTML(html)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
		end
	end

	function SERVICE:SearchFunctions(browser)
		if not IsValid(browser) then return end

		browser:RunJavascript([[
			setInterval(() => {
				var cookieBanner = document.querySelector("#onetrust-banner-sdk #onetrust-reject-all-handler")
				if (!!cookieBanner) {cookieBanner.click()}
			}, 500);
		]])
	end
end

function SERVICE:GetURLInfo(url)
	if url.path then
		local path1, path2 = url.path:match("/([%a%d-_]+)/([%a%d-_]+)$")
		if path1 and not Ignored[path1] and path2 then return { Data = ("%s/%s"):format(path1, path2)} end
	end

	return false
end

local function ParseSoundCloudHTML(body)
	local json = body:match('<script>window%.__sc_hydration = (.-);</script>')
	if not json then
		return nil, "Hydration JSON not found"
	end

	local data = util.JSONToTable(json)
	if not data then
		return nil, "Failed to parse JSON"
	end

	for i = 1, #data do
		if data[i]["hydratable"] and data[i]["hydratable"] == "sound" and data[i]["data"] then
			local metadata = data[i]["data"]

			if metadata.embeddable_by ~= "all" or not metadata.public then
				return nil, "Track is not embeddable"
			end

			local duration = metadata.duration or metadata.full_duration or 0
			duration = math.floor(duration / 1000)

			return {
				title = metadata.title or "Unknown",
				thumbnail = metadata.artwork_url,
				duration = duration
			}
		end
	end

	return nil, "Sound metadata not found in hydration data"
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local onReceive = function(body, length, headers, code)
		local success, result = pcall(ParseSoundCloudHTML, body)

		if not success then
			return onFailure(result or "Theater_RequestFailed")
		end

		local metadata, err = result
		if not metadata then
			return onFailure(err or "Theater_RequestFailed")
		end

		local info = {}
		info.title = metadata.title
		info.duration = metadata.duration
		info.thumbnail = metadata.thumbnail

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local url = "https://soundcloud.com/" .. data:Data()
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("soundcloud", SERVICE)