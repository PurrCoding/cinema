local SERVICE = {
	Name = "Kick",
	IsTimed = false,

	NeedsCodecFix = true
}

local Ignored = {
	["category"] = true,
	["browse"] = true,
}

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
					document.querySelector("div[class^=\"group/main\"]").remove()
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
	if url.path then
		local data = url.path:match("^/([%a%d-_]+)")
		if (data and not Ignored[data]) then return { Data = data } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local info = {}
	info.title = ("Kick: %s"):format(data)

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "kick", SERVICE )