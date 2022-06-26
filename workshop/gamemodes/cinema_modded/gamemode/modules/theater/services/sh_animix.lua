--[[
	 █████╗ ███╗   ██╗██╗███╗   ███╗██╗██╗  ██╗    ██████╗ ██╗      █████╗ ██╗   ██╗
	██╔══██╗████╗  ██║██║████╗ ████║██║╚██╗██╔╝    ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝
	███████║██╔██╗ ██║██║██╔████╔██║██║ ╚███╔╝     ██████╔╝██║     ███████║ ╚████╔╝
	██╔══██║██║╚██╗██║██║██║╚██╔╝██║██║ ██╔██╗     ██╔═══╝ ██║     ██╔══██║  ╚██╔╝
	██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║██╔╝ ██╗    ██║     ███████╗██║  ██║   ██║
	╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝

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

--[[ NOTE:

	This service has no API or method to collect metadata like the duration.
	For this reason, a length of 10 hours is displayed for each video.

	For security and reliability reasons, only GOGO Stream is supported.
]]--

local SERVICE = {}
SERVICE.Name = "AniMix Play"
SERVICE.IsTimed = true
SERVICE.ExtentedVideoInfo = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local Versions = {
	["v1"] = true, -- GOGO Stream
}

function SERVICE:Match( url )
	return url.host and url.host:match("animixplay.to")
end

if (CLIENT) then
	local BASE_URL = "https://animixplay.to/v1/%s"

	local JS_BASE = [[
		var checkerInterval = setInterval(function() {
			if (typeof (iframeplayer) != 'undefined') {
				if (!iframeplayer.src) {return;}
				clearInterval(checkerInterval);

				window.location.replace(iframeplayer.src);
			} else {
				if (typeof (player1) != 'undefined') {
					if (!player1.media) {return;}

					{@JS_Content}
				}
			}
		}, 50);
	]]

	local THEATER_JS = JS_BASE:Replace("{@JS_Content}", [[
		if (player1.paused) { player1.play(); return;}
		player1.muted = false;

		clearInterval(checkerInterval);

		window.cinema_controller = player1.media;
		exTheater.controllerReady();
	]])

	local METADATA_JS = JS_BASE:Replace("{@JS_Content}", [[
		if (!player1.paused) { player1.pause(); }
		player1.muted = true;

		clearInterval(checkerInterval);

		var metadata = { duration: player1.duration }
		console.log("METADATA:" + JSON.stringify(metadata))
	]])

	function SERVICE:LoadProvider( Video, panel )

		local url = BASE_URL:format(Video:Data())
		do	-- backwards compatibility
			local _, src = Video:Data():match("^/(v%d+)/(.+)")
			if src then
				url = BASE_URL:format(src)
			end
		end

		panel:OpenURL(url)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )
		local panel = vgui.Create("DHTML")
		panel:SetSize(100,100)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		panel.OnDocumentReady = function(pnl)
			pnl:QueueJavascript(METADATA_JS)
		end

		function panel:ConsoleMessage(msg)
			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				callback(metadata)
				panel:Remove()
			end

		end

		panel:OpenURL(BASE_URL:format(data))
	end
end

function SERVICE:GetURLInfo( url )
	if url.path then
		local version, src = url.path:match("^/(v%d+)/(.+)")
		if ( version and Versions[version] and src ) then
			return { Data = src }
		end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = ("AniMix Play: %s"):format(data:Data())
		info.thumbnail = self.PlaceholderThumb
		info.duration = tonumber(metadata.duration)

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "animixplay_v1", SERVICE )