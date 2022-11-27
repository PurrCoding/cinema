--[[
    This "VKontakte" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}

SERVICE.Name = "VKontakte"
SERVICE.IsTimed = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local API_URL = "https://vk.com/video?z=%s"

function SERVICE:Match( url )
	return url.host and url.host:match("vk.com")
end

if (CLIENT) then
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player) {

				if (player.paused) { player.play(); }
				if (!player.paused && player.readyState === 4) {
					if (player.muted) {player.muted = false}

					clearInterval(checkerInterval);

					window.cinema_controller = player;
					exTheater.controllerReady();

					document.body.style.backgroundColor = "black";

					player.addEventListener("seeking", function () {
						if (!player.paused) { player.pause() }

						this.addEventListener("progress", function progessCheck() {
							if (player.paused && player.readyState === 4) {
								this.removeEventListener("progress", progessCheck);
								player.play();
							}
						});
					});
				}
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = util.SecondsToISO_8601(startTime)
		else startTime = 0 end

		panel:OpenURL( Video:Data() .. "&autoplay=1" .. (self.IsTimed and "&t=" .. startTime or "" ))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://vk.com/video-xxxxxxxxx_xxxxxxxxx
	local videoID = url.path:match("[video%-(%d+)_(%d+)]+")
	if (videoID and videoID ~= "video") then
		info.Data = videoID
	end

	if (url.query) then

		-- https://vk.com/video?z=video-xxxxxxxxx_xxxxxxxxx
		if url.query.z then
			local data = url.query.z:match("[video%-(%d+)_(%d+)]+")
			if data then info.Data = data end
		end

		if url.query.t and url.query.t ~= "" then
			local time = util.ISO_8601ToSeconds(url.query.t)
			if time and time ~= 0 then
				info.StartTime = time
			end
		end

	end

	return info.Data and info or false
end

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sitemprop=\"name\"%s-content=%b\"\"%s/>",
	["thumb"] = "<link%sitemprop=\"thumbnailUrl\"%s-href=%b\"\"%s/>",
	["duration"] = "<meta%sitemprop=\"duration\"%s-content=%b\"\"%s/>",
	["live"] = "<meta%sitemprop=\"isLiveBroadcast\"%s-content=%b\"\"%s/>",
	["age_restriction"] = "<meta%sitemprop=\"isFamilyFriendly\"%s-content=%b\"\"%s/>",
	["embed"] = "<link%sitemprop=\"embedUrl\"%s-href=%b\"\"%s/>",
}

---
-- Function to parse video metadata straight from the html instead of using the API
--
local function ParseMetaDataFromHTML( html )
	local metadata, html = {}, html

	metadata.title = util.ParseElementAttribute(html:match(patterns["title"]), "content")
	metadata.title = url.htmlentities_decode(metadata.title) -- Parse HTML entities in the title into symbols

	metadata.thumbnail = util.ParseElementAttribute(html:match(patterns["thumb"]), "href")
	metadata.familyfriendly = util.ParseElementAttribute(html:match(patterns["age_restriction"]), "content") or ""
	metadata.embed = util.ParseElementAttribute(html:match(patterns["embed"]), "href")

	local isLiveBroadcast = tobool(util.ParseElementAttribute(html:match(patterns["live"]), "content"))
	local durationISO8601 = util.ParseElementAttribute(html:match(patterns["duration"]), "content")
	local duration = util.ISO_8601ToSeconds(durationISO8601)

	if isLiveBroadcast and duration == 0 then
		metadata.duration = 0 -- Mark as live video
	else
		metadata.duration = math.max(1, duration)
	end

	return metadata
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )
		local status, metadata = pcall(ParseMetaDataFromHTML, body)
		if not status  then
			return onFailure( "Theater_RequestFailed" )
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = metadata.thumbnail
		info.data = metadata.embed

		if metadata.duration == 0 then
			info.type = "vklive"
			info.duration = 0
		else
			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format(data)
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "vk", SERVICE )

theater.RegisterService( "vklive", {
	Name = "VKontakte Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )