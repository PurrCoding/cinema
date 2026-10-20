-- SoundCloud service for Cinema.
-- Robust metadata crawler (yt-dlp-style client_id refresh + multi-stage fallbacks).
local SERVICE = {
	Name = "SoundCloud",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

local Ignored = {
	["sets"] = true,
	["albums"] = true,
	["likes"] = true,
	["comments"] = true,
	["followers"] = true,
	["following"] = true,
	["tracks"] = true,
}

local function NormalizeArtwork(url)
	if not isstring(url) or url == "" then return nil end
	return url:gsub("%-large%.", "-t500x500."):gsub("%-t300x300%.", "-t500x500.")
end

local function BuildTitle(track)
	local title = track.title or "Unknown"
	local user = track.user and (track.user.username or track.user.permalink)
	if user and user ~= "" and not title:find(user, 1, true) then
		return ("%s - %s"):format(user, title)
	end
	return title
end

local ENCRYPTED_STREAM_ERR = "SoundCloud track only offers encrypted/DRM streams (not playable in GMod)"

local function IsEncryptedStreamError(err)
	return isstring(err) and err:find("encrypted/DRM", 1, true) ~= nil
end


function SERVICE:Match(url)
	return url.host and url.host:match("soundcloud.com")
end

function SERVICE:GetURLInfo(url)
	if not url.path then return false end

	local path1, path2 = url.path:match("^/([%a%d-_]+)/([%a%d-_]+)/?$")
	if path1 and path2 and not Ignored[path1] and not Ignored[path2] then
		return { Data = ("%s/%s"):format(path1, path2) }
	end

	return false
end

local function HasPlayableTranscoding(media)
	if not istable(media) or not istable(media.transcodings) then
		return true
	end
	if #media.transcodings == 0 then
		return false
	end
	for _, t in ipairs(media.transcodings) do
		local proto = ""
		if istable(t.format) and isstring(t.format.protocol) then
			proto = t.format.protocol:lower()
		elseif isstring(t.protocol) then
			proto = t.protocol:lower()
		end
		if proto ~= ""
			and not proto:find("encrypted", 1, true)
			and proto:sub(1, 4) ~= "cbc-"
			and proto:sub(1, 4) ~= "ctr-" then
			return true
		end
	end
	return false
end


local function ParseSoundCloudHTML(body)
	local json = body:match('<script>window%.__sc_hydration%s*=%s*(.-);</script>')
		or body:match('window%.__sc_hydration%s*=%s*(.-);%s*</script>')
	if not json then return nil, "Hydration JSON not found" end

	local data = util.JSONToTable(json)
	if not data then return nil, "Failed to parse JSON" end

	for i = 1, #data do
		local entry = data[i]
		local metadata = entry and (entry.data or entry)
		local isSound = (entry and entry.hydratable == "sound")
			or (metadata and (metadata.kind == "track" or metadata.full_duration or metadata.duration))

		if isSound and metadata and metadata.title then
			if metadata.embeddable_by and metadata.embeddable_by ~= "all" and metadata.embeddable_by ~= "me" then
				return nil, "Track is not embeddable"
			end
			if metadata.public == false then
				return nil, "Track is not public"
			end
			if not HasPlayableTranscoding(metadata.media) then
				return nil, ENCRYPTED_STREAM_ERR
			end

			return {
				title = BuildTitle(metadata),
				thumbnail = NormalizeArtwork(metadata.artwork_url),
				duration = math.floor((metadata.full_duration or metadata.duration or 0) / 1000)
			}
		end
	end

	return nil, "Sound metadata not found in hydration data"
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local function deliver(metadata)
		local info = {
			title = metadata.title,
			duration = tonumber(metadata.duration) or 0,
			thumbnail = metadata.thumbnail
		}
		-- Never queue zero-duration / incomplete metadata.
		if not info.title or info.title == "" or info.duration <= 0 then
			if onFailure then onFailure("Theater_RequestFailed") end
			return
		end
		if onSuccess then pcall(onSuccess, info) end
	end

	local trackPath = data:Data()

	local function runHydrationFallback(primaryError)
		-- Encrypted: stop entirely — no HTML scrape, no client crawl.
		if IsEncryptedStreamError(primaryError) then
			if onFailure then onFailure(primaryError) end
			return
		end
		local pageUrl = "https://soundcloud.com/" .. trackPath
		self:Fetch(pageUrl, function(body)
			local ok, pack = pcall(function()
				local meta, e = ParseSoundCloudHTML(body)
				return { meta = meta, err = e }
			end)
			if ok and pack and istable(pack.meta) and pack.meta.title
				and (tonumber(pack.meta.duration) or 0) > 0 then
				deliver(pack.meta)
			elseif onFailure then
				local msg = primaryError
					or (ok and pack and pack.err)
					or "Theater_RequestFailed"
				if IsEncryptedStreamError(msg) then
					onFailure(msg)
				else
					onFailure(msg)
				end
			end
		end, function(err)
			if onFailure then onFailure(primaryError or err or "Theater_RequestFailed") end
		end)
	end

	local function runClientCrawler(primaryError)
		if IsEncryptedStreamError(primaryError) then
			if onFailure then onFailure(primaryError) end
			return
		end
		theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
			local err = metadata and metadata.err
			if IsEncryptedStreamError(err) or IsEncryptedStreamError(primaryError) then
				if onFailure then onFailure(err or primaryError) end
				return
			end
			local dur = metadata and tonumber(metadata.duration) or 0
			if metadata and not metadata.err and metadata.title and metadata.title ~= "" and metadata.title ~= "Unknown" and dur > 0 then
				deliver(metadata)
				return
			end
			runHydrationFallback(primaryError or err)
		end)
	end

	-- Server resolve is authoritative for DRM. Encrypted → hard stop, no further stages.
	if SERVER and self.ResolveTrack then
		self:ResolveTrack(trackPath, function(metadata)
			deliver(metadata)
		end, function(err)
			if IsEncryptedStreamError(err) then
				if onFailure then onFailure(err) end
				return
			end
			runClientCrawler(err)
		end)
		return
	end

	runClientCrawler(nil)
end

theater.RegisterService("soundcloud", SERVICE)
