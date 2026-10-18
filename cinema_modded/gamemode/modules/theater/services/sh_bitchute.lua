local SERVICE = {
	Name = "BitChute",
	IsTimed = true,

	NeedsCodecFix = true,
}

local META_API = "https://api.bitchute.com/api/beta9/video"
local EMBED_URL = "https://www.bitchute.com/api/beta9/embed/%s?startTime=%d&autoPlay=true"

local function ParseDuration( str )
	if not str or str == "" then return 0 end

	local h, m, s = string.match( str, "^(%d+):(%d+):(%d+)$" )
	if h then
		return tonumber( h ) * 3600 + tonumber( m ) * 60 + tonumber( s )
	end

	m, s = string.match( str, "^(%d+):(%d+)$" )
	if m then
		return tonumber( m ) * 60 + tonumber( s )
	end

	return tonumber( str ) or 0
end

function SERVICE:Match( url )
	if not url or not url.host then return false end
	if not url.host:match( "bitchute%.com" ) then return false end
	if not url.path then return false end

	-- Only /video/ID or /embed/ID (not homepage / channels)
	if url.path:match( "^/video/[%w%-_]+" ) then return true end
	if url.path:match( "^/embed/[%w%-_]+" ) then return true end

	return false
end

if (CLIENT) then

	--[[
		Embed API: autoPlay + startTime.
		Isolate <video> once playing (MEGA-style) so Video.js cannot fight controls.
	]]
	local THEATER_JS = [[
		(function() {
			function isolate(player) {
				document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
				document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";

				document.body.appendChild(player);

				var nodes = Array.prototype.slice.call(document.body.childNodes);
				for (var i = 0; i < nodes.length; i++) {
					if (nodes[i] !== player) {
						try { document.body.removeChild(nodes[i]); } catch (e) {}
					}
				}

				var scripts = document.querySelectorAll("script");
				for (var s = 0; s < scripts.length; s++) {
					try { scripts[s].remove(); } catch (e) {}
				}

				player.style.cssText = [
					"position:fixed",
					"top:0",
					"left:0",
					"width:100%",
					"height:100%",
					"max-width:100%",
					"max-height:100%",
					"object-fit:contain",
					"background:#000",
					"z-index:9999",
					"margin:0",
					"padding:0",
					"border:none"
				].join(";");

				player.removeAttribute("controls");
				player.controls = false;

				window.cinema_controller = player;
			}

			var checkerInterval = setInterval(function() {
				var player = document.getElementById("player_one")
					|| document.querySelector("video");
				if (!player) return;

				if (player.paused) {
					try {
						player.setAttribute("webkit-playsinline", "webkit-playsinline");
						var req = player.play();
						if (req && req.catch) req.catch(function() {});
					} catch (e) {}
					return;
				}

				if (player.readyState < 2) return;

				clearInterval(checkerInterval);
				isolate(player);

				var req = player.play();
				if (req && req.catch) req.catch(function() {});

				exTheater.controllerReady();
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = 0
		if self.IsTimed then
			startTime = math.Round( CurTime() - Video:StartTime() )
			if startTime < 0 then startTime = 0 end
		end

		panel:OpenURL( EMBED_URL:format( Video:Data(), startTime ) )
		panel.OnDocumentReady = function( pnl )
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript( THEATER_JS )
		end

	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://www.bitchute.com/video/xxxxxxxxx
	-- https://www.bitchute.com/embed/xxxxxxxxx
	if url.path then
		local videoId = url.path:match( "^/video/([%w%-_]+)" )
			or url.path:match( "^/embed/([%w%-_]+)" )
		if videoId then
			info.Data = videoId
		end
	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable( body )
		if not response or not response.video_id then
			return onFailure( "Theater_RequestFailed" )
		end

		if response.state_id and response.state_id ~= "published" and response.state_id ~= "live" then
			return onFailure( "Theater_RequestFailed" )
		end

		local duration = ParseDuration( response.duration )
		local isLive = ( response.state_id == "live" )
			or ( response.duration == "0:00" )

		local info = {}
		info.title = response.video_name or "BitChute Video"
		info.thumbnail = response.thumbnail_url

		if isLive then
			info.type = "bitchutelive"
			info.duration = 0
		else
			info.duration = duration
		end

		if onSuccess then
			pcall( onSuccess, info )
		end

	end

	-- SERVICE:Fetch is GET-only; BitChute metadata requires POST
	HTTP( {
		url = META_API,
		method = "POST",
		headers = {
			["Content-Type"] = "application/json",
			["Cache-Control"] = "no-cache",
			["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
		},
		body = util.TableToJSON( { video_id = data } ),
		success = function( code, body, respHeaders )
			code = tonumber( code ) or 0
			if code ~= 200 then
				return pcall( onFailure, "Theater_RequestFailed" )
			end
			onReceive( body, body and body:len() or 0, respHeaders, code )
		end,
		failed = function( err )
			if onFailure then
				pcall( onFailure, err )
			end
		end,
	} )

end

theater.RegisterService( "bitchute", SERVICE )

-- Hidden live variant (same player, no seeking / no end-of-media)
theater.RegisterService( "bitchutelive", {
	Name = "BitChute Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
