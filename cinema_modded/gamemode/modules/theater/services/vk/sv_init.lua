local SERVICE = include "cl_init.lua"
if not SERVICE then return end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
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

theater.RegisterService("vk", SERVICE)

theater.RegisterService("vklive", {
	Name = "VK Video (Live)",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
