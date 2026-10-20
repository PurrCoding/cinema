--[[
	Combined URL Media Service
	Separates basic formats (no GModPatchTool needed) from proprietary formats.
	Client playback and server metadata handling live in their respective realm files.
]]

local url2 = url

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

local BASIC_FORMATS = table.Merge(table.Copy(IMAGE_FORMATS), BASIC_VIDEO_AUDIO_FORMATS)

local function createService(name, codecSupport, formats)
	return {
		Name = name,
		IsTimed = true,
		NeedsCodecFix = codecSupport,
		ExtentedVideoInfo = true,
		IsCacheable = true,

		Match = function(self, parsedURL)
			-- Reject archive.org URLs with /details/ path to prevent conflicts.
			if parsedURL.host and parsedURL.host:match("archive%.org")
				and parsedURL.path and parsedURL.path:match("^/details/(.+)$") then
				return false
			end
			return parsedURL.file and formats[parsedURL.file.ext] or false
		end,

		GetURLInfo = function(self, parsedURL)
			if not parsedURL or not parsedURL.encoded then return false end
			return { Data = parsedURL.encoded }
		end
	}
end

local basicService = createService("URL (Basic Media)", false, BASIC_FORMATS)
local proprietaryService = createService("URL (Proprietary Video)", true, PROPRIETARY_FORMATS)

theater.RegisterService("url_basic", basicService)
theater.RegisterService("url_proprietary", proprietaryService)

-- Image entries are aliases. Resolve the provider when called so cl_init.lua
-- can attach it after the shared service registrations have completed.
local function LoadImageProvider(...)
	local service = theater.GetServiceByClass("url_basic")
	if service and service.LoadProvider then
		return service:LoadProvider(...)
	end
end

theater.RegisterService("image_timed", {
	Name = "URL (Timed Images)",
	IsTimed = true,
	NeedsCodecFix = false,
	Hidden = true,
	LoadProvider = LoadImageProvider
})

theater.RegisterService("image", {
	Name = "URL (Images)",
	IsTimed = false,
	NeedsCodecFix = false,
	Hidden = true,
	LoadProvider = LoadImageProvider
})
