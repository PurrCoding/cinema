local SERVICE = {
	Name = "Dailymotion",
	IsTimed = true,

	NeedsCodecFix = true,

	PlayerURL = "https://geo.dailymotion.com/player/x1nqri.html?video=%s&rel=0&autoplay=1",
}

function SERVICE:Match(url)
	return url.host and url.host:match("dailymotion.com")
end

if CLIENT then

	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.querySelector(".video_view video");
			if (player && player.paused === false && player.readyState === 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;
				exTheater.controllerReady();

				player.muted = false;
			}
		}, 50);
	]]

	function SERVICE:LoadProvider(Video, panel)
		local startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))
		local url = SERVICE.PlayerURL:format(Video:Data())

		if self.IsTimed and startTime > 0 then
			url = url .. "&start=" .. startTime
		end

		panel:OpenURL(url)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}

	-- https://dailymotion.com/video/xxxxxxxxx
	if url.path then
		local videoId = url.path:match("^/video/([%a%d-_]+)")
		if videoId then
			info.Data = videoId
		end
	end

	if url.query and url.query.start and url.query.start ~= "" then
		local time = tonumber(url.query.start)
		if time and time ~= 0 then
			info.StartTime = time
		end
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("dailymotion", SERVICE)

theater.RegisterService("dailymotionlive", {
	Name = "Dailymotion Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
