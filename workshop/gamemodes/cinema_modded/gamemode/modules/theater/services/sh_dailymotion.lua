local SERVICE = {
	Name = "Dailymotion",
	IsTimed = true,

	NeedsCodecFix = true
}

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
			if (document.querySelector(".consent_screen-button.consent_screen-accept")) {
				document.querySelector(".consent_screen-button.consent_screen-accept").click();
			}

			var player = document.querySelector("video#video");
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = startTime
		else startTime = 0 end

		panel:OpenURL( DAILYMOTION_URL:format( Video:Data() ) .. (self.IsTimed and "&start=" .. startTime or "" ) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:RunJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://dailymotion/video/xxxxxxxxx
	if (url.path and url.path:match("^/video/([%a%d-_]+)")) then
		info.Data = url.path:match("^/video/([%a%d-_]+)")
	end

	if (url.query) then

		if url.query.start and url.query.start ~= "" then
			local time = tonumber(url.query.start)
			if time and time ~= 0 then
				info.StartTime = time
			end
		end

	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable(body)
		if not response then
			return onFailure( "Theater_RequestFailed" )
		end

		if response.private or response.status ~= "published" then
			return onFailure( "Service_EmbedDisabled" )
		end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if (response.mode == "live" and response.duration == 0) then
			info.type = "dailymotionlive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format( data )
	self:Fetch( url, onReceive, onFailure )

end
theater.RegisterService( "dailymotion", SERVICE )

theater.RegisterService( "dailymotionlive", {
	Name = "Dailymotion Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )