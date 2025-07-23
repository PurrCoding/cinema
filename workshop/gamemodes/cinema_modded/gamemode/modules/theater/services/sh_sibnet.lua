local SERVICE = {
	Name = "Sibnet",
	IsTimed = true,

	NeedsCodecFix = true
}

local API_URL = "https://video.sibnet.ru/shell.php?videoid=%s"

function SERVICE:Match( url )
	return url.host and url.host:match("video.sibnet.ru")
end

if (CLIENT) then
	local EMBED_URL = "https://video.sibnet.ru/shell.php?videoid=%s"
	local THEATER_JS = [[
		function check() {
			var preplayer = document.getElementById("video_html5_wrapper_html5_api")
			if (!!preplayer) {
				clearInterval(checkerInterval);
		
				window.location.href = preplayer.src;
			} else {
				var player = document.getElementsByTagName('video')[0];
	
				if (!!player) {
					if (player.error && player.error.code && player.error.code === 4) {return;} 
	
					if (player.paused) { player.play(); }
					if (!player.paused && player.readyState === 4) {
						clearInterval(checkerInterval);
						window.cinema_controller = player;
	
						exTheater.controllerReady();
		
						player.preload = 'auto';
						player.autoplay = true;
						player.style.height = "100%";
						player.style.width = "100%";
						player.style.background = "black"
						player.style.overflow = 'hidden';
		
					}
				}
			}
		}
		var checkerInterval = setInterval(check, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( EMBED_URL:format(Video:Data()) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local videoID = url.path:match("/video(%d+)-")
		if videoID then return { Data = videoID } end
	end

	return false
end

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sproperty=\"og:title\"%s-content=%b\"\"/>",
	["thumb"] = "<meta%sproperty=\"og:image\"%s-content=%b\"\"/>",
	["duration"] = "<meta%sproperty=\"og:duration\"%s-content=%b\"\"[%s]/>"
}

---
-- Function to parse video metadata straight from the html instead of using the API
--
local function ParseMetaDataFromHTML( html )
	local metadata, html = {}, html

	metadata.title = util.ParseElementAttribute(html:match(patterns["title"]), "content")
	metadata.title = url.htmlentities_decode(metadata.title) -- Parse HTML entities in the title into symbols
	metadata.title = util.win_to_utf8(metadata.title, 1251) -- Convert Windows-1251 Charset to UTF-8

	metadata.thumbnail = util.ParseElementAttribute(html:match(patterns["thumb"]), "content")
	metadata.duration = tonumber(util.ParseElementAttribute(html:match(patterns["duration"]), "content"))

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
		info.duration = metadata.duration

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format(data)
	self:Fetch( url, onReceive, onFailure, {
		["Accept-Encoding"] = "identity;q=1, *;q=0",
		["Accept-Language"] = "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7,zh-CN;q=0.6,zh;q=0.5",
	} )

end

theater.RegisterService( "sibnet", SERVICE )