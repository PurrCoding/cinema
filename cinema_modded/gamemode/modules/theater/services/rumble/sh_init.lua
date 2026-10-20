local SERVICE = {
	Name = "Rumble",
	IsTimed = true,
	OEmbedURL = "https://rumble.com/api/Media/oembed.json?url=https://rumble.com/%s",

	NeedsCodecFix = true,
}


function SERVICE:Match( url )
	return url.host and url.host:match("rumble.com")
end


function SERVICE:GetURLInfo( url )

	if url.path then
		local data = url.path:match("/([%a%d%p-_]+).html")
		if data then
			return { Data = data }
		end

		local shortId = url.path:match("^/shorts/([%w%-_]+)")
		if shortId then
			return { Data = "shorts/" .. shortId }
		end
	end

	return false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )
		local response = util.JSONToTable(body)
		if not response then
			return onFailure( "Theater_RequestFailed" )
		end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if response.duration == 0 then
			info.type = "rumblelive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local isShort = isstring(data) and data:StartWith("shorts/")
	local url = API_URL:format( data ) .. (isShort and "" or ".html")
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "rumble", SERVICE )

theater.RegisterService( "rumblelive", {
	Name = "Rumble Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and function( _, Video, panel )
		local service = theater.GetServiceByClass( "rumble" )
		if service and service.LoadProvider then return service:LoadProvider( Video, panel ) end
	end or function() end
} )
