--[[
	██████╗ ██╗     ██╗██╗   ██╗███████╗
	██╔══██╗██║     ██║██║   ██║██╔════╝
	██║  ██║██║     ██║██║   ██║█████╗
	██║  ██║██║     ██║╚██╗ ██╔╝██╔══╝
	██████╔╝███████╗██║ ╚████╔╝ ███████╗
	╚═════╝ ╚══════╝╚═╝  ╚═══╝  ╚══════╝

			███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗
			██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝
			███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗
			╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝
			███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗
			╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝
                                                                           
    This Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )                                                                            
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!

	Info: This service was once only made for "KNAB-Networks Cinema", now some of them are available for third party use.
--]]

local SERVICE = {}
SERVICE.Name = "DLive"
SERVICE.IsTimed = false
-- SERVICE.TheaterType = THEATER_PRIVATE

local Ignored = {
	["s"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("dlive.tv")
end

if (CLIENT) then
	local BASE_URL = "https://dlive.tv/%s"
	local THEATER_JS = [[		
		function check() {
			var matureWarn = document.querySelectorAll(".d-btn-content");
			matureWarn.forEach(function(item, index, array) {
				if (item.innerText.indexOf("Start Watching") === 0) {
					item.click();
				}
			});

			var player = document.getElementsByClassName("dplayer-video")[0];
			if (!!player) {
				if (player.paused) {player.play(); }
				if (player.paused === false && player.readyState === 4) {
					clearInterval(checkerInterval);
	
					window.cinema_controller = player;
	
					var div = document.getElementsByClassName("dplayer-live")[0]
					if (!!div) { document.getElementsByTagName("body")[0].appendChild(div) }
	
					var appElem = document.getElementById("app");
					if (!!appElem) { appElem.remove(); }
	
					exTheater.controllerReady();
				}
			}
		}
		var checkerInterval = setInterval(check, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( BASE_URL:format( Video:Data() ) )
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
	info.thumbnail = self.PlaceholderThumb

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService( "dlive", SERVICE )