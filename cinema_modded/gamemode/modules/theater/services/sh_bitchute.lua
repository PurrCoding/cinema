local SERVICE = {
	Name = "BitChute",
	IsTimed = true,

	NeedsCodecFix = true,
}

local META_API = "https://api.bitchute.com/api/beta9/video"

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
	local EMBED_URL = "https://www.bitchute.com/embed/%s"
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var btn = document.querySelector(".vjs-big-play-button")
				|| document.querySelector("button.vjs-play-control")
				|| document.querySelector(".vjs-play-control");
			if (btn) {
				try { btn.click(); } catch (e) {}
			}

			var player = document.getElementsByTagName("video")[0];
			if (!player) return;

			if (player.paused) {
				try { player.play(); } catch (e) {}
				return;
			}

			if (player.readyState < 2) return;

			clearInterval(checkerInterval);

			document.documentElement.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
			document.body.style.cssText = "margin:0;padding:0;width:100%;height:100%;background:#000;overflow:hidden;";
			document.body.appendChild(player);

			var children = Array.prototype.slice.call(document.body.childNodes);
			for (var i = 0; i < children.length; i++) {
				if (children[i] !== player) {
					try { document.body.removeChild(children[i]); } catch (e) {}
				}
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
			if (player.muted) { player.muted = false; }

			window.cinema_controller = player;
			exTheater.controllerReady();
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round( CurTime() - Video:StartTime() )
		if startTime < 0 then startTime = 0 end

		panel:OpenURL( EMBED_URL:format( Video:Data() ) )
		panel.OnDocumentReady = function( pnl )
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript( THEATER_JS )

			if self.IsTimed and startTime > 3 then
				timer.Simple( 1.5, function()
					if IsValid( pnl ) then
						pnl:QueueJavascript(
							("if (window.cinema_controller) cinema_controller.currentTime = %d;"):format( startTime )
						)
					end
				end )
			end
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

		local info = {}
		info.title = response.video_name or "BitChute Video"
		info.thumbnail = response.thumbnail_url
		info.duration = ParseDuration( response.duration )

		if response.state_id == "live" then
			info.duration = 0
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
