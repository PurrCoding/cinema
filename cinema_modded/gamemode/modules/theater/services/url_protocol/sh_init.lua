local SERVICE = {
	Name = "URL (Protocol)",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

local validExtensions = {
	["m3u8"] = "hls",      -- HLS
	["mpd"] = "dash",      -- DASH
}

local function ParseURL( urlString )
	local status, parsed = pcall(url.parse2, urlString)
	if status then
		return parsed
	end
	return nil
end

local function GetProtocol( url )
	if url.file and validExtensions[ url.file.ext ] then
		return validExtensions[ url.file.ext ]
	end
	return nil
end

function SERVICE:Match( url )
	if url.file and validExtensions[ url.file.ext ] then
		return true
	end
	return false
end

function SERVICE:GetURLInfo( url )
	if url and url.encoded then
		return { Data = url.encoded }
	end
	return false
end


function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)
		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		local urlParsed = ParseURL(data:Data())
		local protocol = GetProtocol(urlParsed) or "unknown"
		info.title = ("%s: %s"):format(protocol:upper(), data:Data())

		if metadata.live then
			info.type = "url_protocol_live"
			info.duration = 0
		else
			info.duration = math.Round(tonumber(metadata.duration) or 0)
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)
end

-- Register the multi-protocol service
theater.RegisterService( "url_protocol", SERVICE )

-- Register live streaming variant
theater.RegisterService( "url_protocol_live", {
	Name = "URL (Protocol, Live)",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and function( _, Video, panel )
		local service = theater.GetServiceByClass( "url_protocol" )
		if service and service.LoadProvider then return service:LoadProvider( Video, panel ) end
	end or function() end
} )