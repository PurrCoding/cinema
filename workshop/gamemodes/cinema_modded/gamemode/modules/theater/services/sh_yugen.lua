--[[
    This "YugenAnime" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}
SERVICE.Name = "YugenAnime"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

function SERVICE:Match( url )
	return url.host and url.host:match("yugen.to")
end

local function extractUrlInfo(data)
	local urlinfo = string.Explode(",", data)

	return urlinfo[1], urlinfo[2], urlinfo[3]
end

local function getBase64Path(data)
	local entry, anime, episode = extractUrlInfo(data)
	local path = ("%d|%d"):format(entry, episode)

	if anime:match("-dub", -4) then
		path = path .. "|dub"
	end

	return util.Base64Encode(path)
end

if (CLIENT) then
	local BASE_URL = "https://yugen.to/e/%s/"

	local JS_BASE = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0]
			if (typeof (player) != 'undefined') {
				{@JS_Content}
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
		player.addEventListener('error', (event) => {
			console.log("ERROR:" + player.error.code )
		});
	]])

	local MEDIA_ERR = { -- https://developer.mozilla.org/en-US/docs/Web/API/MediaError
		[1] = "The user canceled the media.", -- MEDIA_ERR_ABORTED
		[2] = "A network error occurred while fetching the media.", -- MEDIA_ERR_NETWORK
		[3] = "An error occurred while decoding the media.", -- MEDIA_ERR_DECODE
		[4] = "The audio is missing or is in a format not supported by your browser.", -- MEDIA_ERR_SRC_NOT_SUPPORTED
		[5] = "An unknown error occurred.", -- MEDIA_ERR_UNKOWN
	}

	function SERVICE:LoadProvider( Video, panel )

		local url = BASE_URL:format(getBase64Path(Video:Data()))

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

			if msg:StartWith("ERROR:") then
				local code = tonumber(string.sub(msg, 7))

				callback({ err = MEDIA_ERR[code] or MEDIA_ERR[5] })
				panel:Remove()
			end
		end

		panel:OpenURL(BASE_URL:format(getBase64Path(data)))
	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local entry, anime, episode = url.path:match("watch/(%d+)/([%a%d-_]+)/(%d+)")
		if (entry and anime and episode) then return { Data = ("%s,%s,%s"):format(entry, anime, episode) } end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local _, anime, episode = extractUrlInfo(data:Data())

		local info = {}
		info.title = ("%s - Episode %s"):format(anime, episode)
		info.thumbnail = self.PlaceholderThumb
		info.duration = math.Round(tonumber(metadata.duration))

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "yugen", SERVICE )