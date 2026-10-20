local SERVICE = {
	Name = "Odysee",
	IsTimed = true,
	NeedsCodecFix = true,
}

function SERVICE:Match( url )
	return url.host and url.host:match("odysee%.com")
end

function SERVICE:GetURLInfo( url )
	if not url.path then return false end

	-- https://odysee.com/@channel:1/video-title:a
	-- https://odysee.com/video-title:a
	local channel, claim = url.path:match("/(@[^/]+)/([^/]+)$")
	local claimOnly = url.path:match("/([^/]+)$")

	local data
	if channel and claim then
		-- Full path matches official oEmbed embed src
		data = channel .. "/" .. claim
	elseif claimOnly and claimOnly ~= "" and not claimOnly:StartWith("$") then
		data = claimOnly
	else
		return false
	end

	local info = { Data = data }

	if url.query and url.query.t then
		local t = tonumber(url.query.t)
		if t and t > 0 then
			info.StartTime = t
		end
	end

	return info
end

local function ParseISO8601Duration( duration )
	if not duration or not string.match(duration, "^PT") then
		return 0
	end

	local totalSeconds = 0
	local hours = string.match(duration, "(%d+)H")
	local minutes = string.match(duration, "(%d+)M")
	local seconds = string.match(duration, "(%d+)S")

	if hours then totalSeconds = totalSeconds + (tonumber(hours) * 3600) end
	if minutes then totalSeconds = totalSeconds + (tonumber(minutes) * 60) end
	if seconds then totalSeconds = totalSeconds + tonumber(seconds) end

	return totalSeconds > 0 and totalSeconds or 0
end

local function DecodeURIComponent( str )
	if not str then return str end
	return string.gsub(str, "%%(%x%x)", function(h)
		return string.char(tonumber(h, 16))
	end)
end

local function ParseOdyseeHTML( body )
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
		duration = ParseISO8601Duration(videoData.duration)
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

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	-- data is the embed path (@channel/claim or claim)
	local pageUrl = "https://odysee.com/" .. data

	self:Fetch( pageUrl, function( body, length, headers, code )
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
		self:Fetch( oembedUrl, function( oBody )
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
		end, onFailure )
	end, onFailure )
end


theater.RegisterService( "odysee", SERVICE )

theater.RegisterService( "odyseelive", {
	Name = "Odysee Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and function( _, Video, panel )
		local service = theater.GetServiceByClass( "odysee" )
		if service and service.LoadProvider then return service:LoadProvider( Video, panel ) end
	end or function() end,
} )
