local SERVICE = {}

SERVICE.Name = "YouTube"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_PARTIAL
SERVICE.ExtentedVideoInfo = true

--[[
	Credits to veitikka (https://github.com/veitikka) for fixing YouTube service and writing the
	Workaround with a Metadata parser.

	Src: https://github.com/samuelmaddock/gm-mediaplayer/pull/34
--]]

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["duration"] = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"] = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"] = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">",
	["age_restriction"] = "<meta%sproperty=\"og:restrictions:age\"%s-content=%b\"\">"
}

---
-- Function to parse video metadata straight from the html instead of using the API
--
local function ParseMetaDataFromHTML( html )
	--MetaData table to return when we're done
	local metadata, html = {}, html

	-- Fetch title, with fallbacks if needed
	metadata.title = util.ParseElementAttribute(html:match(patterns["title"]), "content")
		or util.ParseElementContent(html:match(patterns["title_fallback"]))

	-- Parse HTML entities in the title into symbols
	metadata.title = url.htmlentities_decode(metadata.title)

	metadata.familyfriendly = util.ParseElementAttribute(html:match(patterns["age_restriction"]), "content") or ""

	-- See if the video is an ongoing live broadcast
	-- Set duration to 0 if it is, otherwise use the actual duration
	local isLiveBroadcast = tobool(util.ParseElementAttribute(html:match(patterns["live"]), "content"))
	local broadcastEndDate = html:match(patterns["live_enddate"])
	if isLiveBroadcast and not broadcastEndDate then
		-- Mark as live video
		metadata.duration = 0
	else
		local durationISO8601 = util.ParseElementAttribute(html:match(patterns["duration"]), "content")
		if isstring(durationISO8601) then
			metadata.duration = math.max(1, util.ISO_8601ToSeconds(durationISO8601))
		end
	end

	return metadata
end

function SERVICE:Match( url )
	return url.host and url.host:match("youtu.?be[.com]?")
end

if (CLIENT) then

	local THEATER_JS = [[
		(async () => {
			var checkerInterval = setInterval(function () {
				if (!YT || !YT.get) { return; }

				var player = YT.get("widget2");

				if (!!player && !!player.getDuration) {
					clearInterval(checkerInterval);

					{ // Native video controll
						player.volume = 0;
						player.currentTime = 0;
						player.duration = player.getDuration();

						Object.defineProperty(player, "volume", {
							get() {
								return player.getVolume();
							},
							set(volume) {
								if (player.isMuted()) {
									player.unMute();
								}
								player.setVolume(volume * 100);
							},
						});

						Object.defineProperty(player, "currentTime", {
							get() {
								return Number(player.getCurrentTime());
							},
							set(time) {
								player.seekTo(time, true);
							},
						});
					}

					{ // Player resizer
						var frame = player.g;

						document.body.appendChild(frame);

						frame.style.backgroundColor = "#000";
						frame.style.height = "100vh";
						frame.style.left = "0px";
						frame.style.width = "100%";

						document.getElementById("root").remove();
					}

					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL(("https://youtube-lite.js.org/#/watch?v=%s"):format(Video:Data()))

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:RunJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )

		http.Fetch(("https://www.youtube.com/watch?v=%s"):format(data), function(body, length, headers, code)
			if not body or code ~= 200 then
				callback({ err = ("Not expected response received from YouTube (Code: %d)"):format(code) })
				return
			end

			local status, metadata = pcall(ParseMetaDataFromHTML, body)
			if not status  then
				callback({ err = "Failed to parse MetaData from YouTube" })
				return
			end

			callback(metadata)
		end, function(error)
			callback({ err = ("YouTube Error: %s"):format(error) })
		end, {})

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- http://www.youtube.com/watch?v=(videoId)
	if url.query and url.query.v and #url.query.v > 0 then
		info.Data = url.query.v

	-- http://www.youtube.com/v/(videoId)
	elseif url.path and url.path:match("^/v/([%a%d-_]+)") then
		info.Data = url.path:match("^/v/([%a%d-_]+)")

		-- http://www.youtube.com/shorts/(videoId)
	elseif url.path and url.path:match("^/shorts/([%a%d-_]+)") then
		info.Data = url.path:match("^/shorts/([%a%d-_]+)")

	-- http://youtu.be/(videoId)
	elseif url.host:match("youtu.be") and
		url.path and url.path:match("^/([%a%d-_]+)$") and
		( not info.query or #info.query == 0 ) then -- short url
		info.Data = url.path:match("^/([%a%d-_]+)$")
	end

	-- Start time, ?t=123s
	if (url.query and url.query.t and url.query.t ~= "") then
		local time = util.ISO_8601ToSeconds(url.query.t)
		if time and time ~= 0 then
			info.StartTime = time
		end
	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = ("https://img.youtube.com/vi/(%s)/hqdefault.jpg"):format(data)

		if metadata.duration == 0 then
			info.type = "youtubelive"
			info.duration = 0
		else
			if metadata.familyfriendly == "18+" then
				-- info.type = "youtubensfw"
				return onFailure( "YouTube age-restricted content is currently not supported." )
			end

			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "youtube", SERVICE )

-- Implementation is found in "youtube" service.
-- GetVideoInfo switches to "youtubelive"
theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	Dependency = DEPENDENCY_COMPLETE,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )

-- theater.RegisterService( "youtubensfw", {
-- 	Name = "YouTube NSFW",
-- 	IsTimed = true,
-- 	Dependency = DEPENDENCY_PARTIAL,
-- 	Hidden = true,
-- 	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
-- } )