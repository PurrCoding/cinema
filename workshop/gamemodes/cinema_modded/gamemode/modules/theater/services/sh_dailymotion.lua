--[[
    This "Dailymotion" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}
SERVICE.Name = "Dailymotion"
SERVICE.IsTimed = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local API_URL = "https://api.dailymotion.com/video/%s?fields=id,title,duration,thumbnail_url,status,mode,private"

function SERVICE:Match( url )
	return url.host and url.host:match("dailymotion.com")
end

if (CLIENT) then
	local DAILYMOTION_URL = "https://www.dailymotion.com/embed/video/%s?rel=0&autoplay=1"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			if (document.querySelector(".np_DialogConsent-accept")) {
				document.querySelector(".np_DialogConsent-accept").click();
			}

			var player = document.querySelector("video#dmp_Video");
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( DAILYMOTION_URL:format( Video:Data() ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:RunJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local data = url.path:match("^/video/([%a%d-_]+)")
		if data then return { Data = data} end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable(body)
		if not response then return onFailure("Dailymotion: Cannot get video data.") end
		if response.private then return onFailure("Dailymotion: This video is Private.") end
		if response.status ~= "published" then return onFailure("Dailymotion: This video is not Published.") end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url
		info.duration = response.duration

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format( data )
	self:Fetch( url, onReceive, onFailure )

end
theater.RegisterService( "dailymotion", SERVICE )