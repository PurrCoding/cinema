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
	LoadProvider = CLIENT and function( ... )
		local service = theater.GetServiceByClass( "bitchute" )
		if service and service.LoadProvider then return service:LoadProvider( ... ) end
	end or function() end
} )
