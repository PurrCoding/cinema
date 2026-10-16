local SERVICE = {
	Name = "Kick",
	IsTimed = false,

	NeedsCodecFix = true
}

local Ignored = {
	["category"] = true,
	["browse"] = true,
	["videos"] = true,
}

local PlaybackApi = "https://web.kick.com/api/v1/stream/%s/playback"

function SERVICE:Match( url )
	return url.host and url.host:match("kick.com")
end

if (CLIENT) then
	local THEATER_JS = [[
		(async () => {
			var checkerInterval = setInterval(function () {

				var matureWarn = document.querySelector("button[data-test=\"mature\"]")
				if (!!matureWarn) {
					matureWarn.click();
					matureWarn.remove()
				}

				var player = document.getElementById("video-player")
				if (!!player) {
					clearInterval(checkerInterval);

					if (player.muted) {player.muted = false}

					document.body.appendChild(player)
					var main = document.querySelector("div[class^=\"group/main\"]")
					if (main) { main.remove() }
					document.body.style.backgroundColor = "black";

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( ("https://kick.com/%s"):format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )
	if not url.path then return false end

	-- VOD: /channel/videos/{uuid}
	local channel, uuid = url.path:match("^/([%a%d-_]+)/videos/([%w%-]+)")
	if channel and uuid then
		return { Data = channel .. "/videos/" .. uuid }
	end

	-- Live: /channel
	local data = url.path:match("^/([%a%d-_]+)")
	if data and not Ignored[data] then
		return { Data = data }
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	-- VOD path contains /videos/
	local uuid = isstring(data) and data:match("/videos/([%w%-]+)")
	if uuid then
		local onReceive = function( body, length, headers, code )
			local response = util.JSONToTable(body)
			if not response then
				return onFailure( "Theater_RequestFailed" )
			end

			local session = response.video_session or {}
			local info = {}
			info.title = session.video_title or ("Kick VOD: %s"):format(uuid)
			info.duration = tonumber(session.video_duration) or 0

			local playback = response.playback_url or {}
			if isstring(playback.thumbnail) and playback.thumbnail ~= "" then
				info.thumbnail = playback.thumbnail:gsub("%{index%}", "0")
			end

			if info.duration > 0 then
				info.type = "kickvod"
			end

			if onSuccess then
				pcall(onSuccess, info)
			end
		end

		self:Fetch( PlaybackApi:format(uuid), onReceive, onFailure )
		return
	end

	-- Live channel
	local info = {}
	info.title = ("Kick: %s"):format(data)

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "kick", SERVICE )

theater.RegisterService( "kickvod", {
	Name = "Kick VOD",
	IsTimed = true,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
