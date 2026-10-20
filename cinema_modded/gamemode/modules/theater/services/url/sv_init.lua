-- Server-side URL metadata handling.
if not GetConVar("cinema_service_imageduration") then
	CreateConVar("cinema_service_imageduration", "0", { FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING }, "0 = Infinite, 60sec Max", 0, 60)
end

local IMAGE_FORMATS = {
	jpg = true, jpeg = true, png = true, gif = true, bmp = true
}

local BASIC_VIDEO_AUDIO_FORMATS = {
	webm = true,
	mp3 = true, wav = true, ogg = true, m4a = true, aac = true, flac = true,
}

local PROPRIETARY_FORMATS = {
	mp4 = true, mov = true, mkv = true
}

local function AttachServerMethods(class)
	local service = theater.GetServiceByClass(class)
	if not service then return end

	function service:GetVideoInfo(data, onSuccess, onFailure)
		local status, data2 = pcall(url.parse2, data:Data())
		if not status then
			return onFailure("Failed to parse URL: " .. tostring(data2))
		end

		local fileext = data2.file and data2.file.ext
		local filename = data2.file and data2.file.name or "Unknown"
		if not fileext then return onFailure("No file extension found") end

		if BASIC_VIDEO_AUDIO_FORMATS[fileext] then
			theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
				if metadata.err then return onFailure(metadata.err) end
				local info = {
					title = (fileext == "webm" and "Video: %s" or "Audio: %s"):format(filename),
					duration = math.max(0, math.Round(tonumber(metadata.duration) or 0))
				}
				if onSuccess then pcall(onSuccess, info) end
			end)
			return
		end

		if IMAGE_FORMATS[fileext] then
			local info = { title = ("Image: %s"):format(filename) }
			local duration = GetConVar("cinema_service_imageduration"):GetInt()
			if duration > 0 then
				info.type = "image_timed"
				info.duration = duration
			else
				info.type = "image"
			end
			if onSuccess then pcall(onSuccess, info) end
			return
		end

		if PROPRIETARY_FORMATS[fileext] then
			theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
				if metadata.err then return onFailure(metadata.err) end
				local info = {
					title = ("Video: %s"):format(filename),
					duration = math.max(0, math.Round(tonumber(metadata.duration) or 0))
				}
				if onSuccess then pcall(onSuccess, info) end
			end)
		end
	end
end

AttachServerMethods("url_basic")
AttachServerMethods("url_proprietary")
