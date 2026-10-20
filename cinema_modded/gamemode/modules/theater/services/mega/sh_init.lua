local SERVICE = {
	Name = "Mega",
	IsTimed = true,
	PreviewURL = "https://mega.nz/embed/%s",

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}


local ValidTypes = {
	["embed"] = true,
	["file"] = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("mega.nz")
end


function SERVICE:GetURLInfo( url )

	local info = {}

	local authority, path, data, key = url.encoded:match("^https?://(.+%..+)/(%a+)/([%a%d-_]+)#([%a%d-_]+)$")
	if (authority and authority == "mega.nz") and ValidTypes[path] and key then
		info.Data = ("%s#%s"):format(data, key)
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
		info.duration = tonumber(metadata.duration)

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "mega", SERVICE )
