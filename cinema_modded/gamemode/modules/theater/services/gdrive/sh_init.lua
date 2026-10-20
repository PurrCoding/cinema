local SERVICE = {
	Name = "Google Drive",
	IsTimed = true,
	PreviewURL = "https://drive.google.com/file/d/%s/preview?autoplay=true",

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}


function SERVICE:Match( url )
	return url.host and url.host:match("drive.google.com")
end


function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://drive.google.com/file/d/(fileId)
	if url.path and url.path:match("^/file/d/([%a%d-_]+)/") then
		info.Data = url.path:match("^/file/d/([%a%d-_]+)/")
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

theater.RegisterService( "gdrive", SERVICE )