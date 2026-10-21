local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local function ParseURL(urlString)
	local status, parsed = pcall(url.parse2, urlString)
	if status then
		return parsed
	end
	return nil
end

local validExtensions = {
	["m3u8"] = "hls", -- HLS
	["mpd"] = "dash", -- DASH
}

local function GetProtocol(url)
	if url.file and validExtensions[url.file.ext] then
		return validExtensions[url.file.ext]
	end
	return nil
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
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

theater.RegisterService("url_protocol", SERVICE)

-- Register live streaming variant
theater.RegisterService("url_protocol_live", {
	Name = "URL (Protocol, Live)",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
