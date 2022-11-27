--[[
    This "AniMix Play" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

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
				var player = document.getElementsByTagName('video')[0]
				if (typeof (player) != 'undefined') {

					{@JS_Content}
				}
			}
		}, 50);
	]]

	local THEATER_JS = JS_BASE:Replace("{@JS_Content}", [[
		if (player.paused) { player.play(); return;}
		player.muted = false;

		clearInterval(checkerInterval);

		window.cinema_controller = player;
		exTheater.controllerReady();
	]])

	local METADATA_JS = JS_BASE:Replace("{@JS_Content}", [[
		player.muted = true;

		clearInterval(checkerInterval);

		if (window.metaevent_set) {return;}
		player.addEventListener('loadedmetadata', (event) => {
			window.metaevent_set = true;

			var metadata = { duration: player.duration };
			console.log("METADATA:" + JSON.stringify(metadata));
		});
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
		info.duration = math.Round(tonumber(metadata.duration))

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "animixplay_v1", SERVICE )