local SERVICE = {
	Name = "DLive",
	IsTimed = false,

	Dependency = DEPENDENCY_COMPLETE
}

local Ignored = {
	["s"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("dlive.tv")
end

if (CLIENT) then
	local THEATER_JS = [[
					
		( () => {
			var checkerInterval = setInterval(function () {

				var matureWarn = document.getElementsByClassName("btn agree")[0]
				if (!!matureWarn) {
					matureWarn.click();
					matureWarn.remove()
				}

				var player = document.getElementsByClassName("dplayer-video")[0]
				if (!!player) {
					clearInterval(checkerInterval);

					var div = document.getElementsByClassName("dplayer-live")[0]
					if (!!div) { document.getElementsByTagName("body")[0].appendChild(div) }

					var appElem = document.getElementById("app");
					if (!!appElem) { appElem.remove(); }

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( ("https://dlive.tv/%s"):format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local data = url.path:match("/([%w%p_]+)")
		if (data and not Ignored[data]) then return { Data = data } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local info = {}
	info.title = ("DLive: %s"):format(data)

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "dlive", SERVICE )