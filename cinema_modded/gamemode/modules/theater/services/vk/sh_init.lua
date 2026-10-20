local SERVICE = {
	Name = "VK Video",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

function SERVICE:Match( url )
	return url.host and url.host:match("vkvideo.ru")
end


function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://vkvideo.ru/video-xxxxxxxxx_xxxxxxxxx
	-- https://vkvideo.ru/live-xxxxxxxxx_xxxxxxxxx
	if url.path then
		local videoID = url.path:match("(video%-%d+_%d+)")
			or url.path:match("(live%-%d+_%d+)")
		if videoID then
			info.Data = videoID
		end
	end

	if url.query then

		-- ?z=video-... or ?z=live-...
		if url.query.z then
			local data = url.query.z:match("(video%-%d+_%d+)")
				or url.query.z:match("(live%-%d+_%d+)")
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

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = metadata.thumbnail

		local duration = metadata.duration
		local isLivePath = isstring(data) and data:StartWith("live-")

		if isLivePath or not duration or (isnumber(duration) and duration == 0) then
			info.type = "vklive"
			info.duration = 0
		else
			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "vk", SERVICE )
theater.RegisterService( "vklive", {
	Name = "VK Video (Live)",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and function( _, Video, panel )
		local service = theater.GetServiceByClass( "vk" )
		if service and service.LoadProvider then return service:LoadProvider( Video, panel ) end
	end or function() end
} )
