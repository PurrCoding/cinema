local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local function DecodeURIComponent(str)
	if not str then return str end
	return string.gsub(str, "%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end)
end

local function ParseOdyseeHTML(body)
	local jsonData = string.match(body, '<script type="application/ld%+json">(.-)</script>')
	if not jsonData then return nil end

	local videoData = util.JSONToTable(jsonData)
	if not videoData or videoData["@type"] ~= "VideoObject" then
		return nil
	end

	local title = videoData.name or "Odysee Video"
	title = string.gsub(title, "&quot;", '"')
	title = string.gsub(title, "&amp;", "&")
	title = string.gsub(title, "&lt;", "<")
	title = string.gsub(title, "&gt;", ">")

	local duration = 0
	if videoData.duration then
		duration = string.match(videoData.duration, "^PT") and util.ISO_8601ToSeconds(videoData.duration) or 0
	end

	local embedUrl = ""
	if videoData.embedUrl and videoData.embedUrl ~= "" then
		embedUrl = DecodeURIComponent(videoData.embedUrl)
	end

	return {
		title = title,
		duration = duration,
		embedUrl = embedUrl,
		thumbnail = videoData.thumbnailUrl or "",
	}
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	-- data is the embed path (@channel/claim or claim)
	local pageUrl = "https://odysee.com/" .. data

	self:Fetch(pageUrl, function(body, length, headers, code)
		local metadata = ParseOdyseeHTML(body)

		if metadata and metadata.title then
			if metadata.duration == 0 then
				metadata.type = "odyseelive"
			end
			pcall(onSuccess, metadata)
			return
		end

		-- Fallback: oEmbed
		local oembedUrl = "https://odysee.com/$/oembed?url=" .. pageUrl .. "&format=json"
		self:Fetch(oembedUrl, function(oBody)
			local response = util.JSONToTable(oBody)
			if not response then
				return onFailure("Theater_RequestFailed")
			end

			local info = {
				title = response.title or "Odysee Livestream",
				duration = 0,
				type = "odyseelive",
			}

			if response.thumbnail_url then
				info.thumbnail = response.thumbnail_url
			end

			if response.html then
				local src = string.match(response.html, 'src="([^"]+)"')
				if src then
					local embed = DecodeURIComponent(src)
					embed = string.match(embed, "^([^?]+)") or embed
					info.embedUrl = embed
				end
			end

			pcall(onSuccess, info)
		end, onFailure)
	end, onFailure)
end

theater.RegisterService("odysee", SERVICE)

theater.RegisterService("odyseelive", {
	Name = "Odysee Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
