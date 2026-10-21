local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local function IsEncryptedStreamError(err)
	return isstring(err) and err:find("encrypted/DRM", 1, true) ~= nil
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

local ENCRYPTED_STREAM_ERR = "SoundCloud track only offers encrypted/DRM streams (not playable in GMod)"

local function BuildTitle(track)
	local title = track.title or "Unknown"
	local user = track.user and (track.user.username or track.user.permalink)
	if user and user ~= "" and not title:find(user, 1, true) then
		return ("%s - %s"):format(user, title)
	end
	return title
end

local function NormalizeArtwork(url)
	if not isstring(url) or url == "" then return nil end
	return url:gsub("%-large%.", "-t500x500."):gsub("%-t300x300%.", "-t500x500.")
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
				duration = math.floor((metadata.full_duration or metadata.duration or 0) / 1000),
			}
		end
	end

	return nil, "Sound metadata not found in hydration data"
end

local CLIENT_ID_FALLBACK = "nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic"

local SoundCloudClientId = {
	value = CLIENT_ID_FALLBACK,
	fetchedAt = 0,
	refreshing = false,
}

local function ExtractScriptSrcs(html)
	local srcs = {}
	if not isstring(html) then return srcs end
	for src in html:gmatch('<script[^>]+src=["\']([^"\']+)["\']') do
		if src:find("sndcdn%.com", 1, false) or src:find("soundcloud%.com", 1, false) then
			srcs[#srcs + 1] = src
		end
	end
	return srcs
end

local function ExtractClientIdFromJS(body)
	if not isstring(body) or body == "" then return nil end
	local id = body:match('client_id%s*:%s*"([0-9a-zA-Z]{32})"')
		or body:match("client_id%s*:%s*'([0-9a-zA-Z]{32})'")
		or body:match('"client_id"%s*:%s*"([0-9a-zA-Z]{32})"')
		or body:match("client_id%s*=%s*\"([0-9a-zA-Z]{32})\"")
	return id
end

local CLIENT_ID_TTL = 6 * 60 * 60

local function ClientIdIsFresh()
	return SoundCloudClientId.value
		and SoundCloudClientId.value ~= ""
		and (CurTime() - SoundCloudClientId.fetchedAt) < CLIENT_ID_TTL
end

local function MetadataFromResolve(data)
	if not istable(data) then return nil end
	local track = data
	if data.collection and istable(data.collection[1]) then
		track = data.collection[1]
	end
	if data.kind and data.kind ~= "track" and data.tracks then
		return nil, "playlists/sets are not supported"
	end

	local durationMs = tonumber(track.full_duration) or tonumber(track.duration) or 0
	local title = track.title
	if not title or title == "" then return nil, "missing title" end

	if track.embeddable_by and track.embeddable_by ~= "all" and track.embeddable_by ~= "me" then
		return nil, "Track is not embeddable"
	end
	if track.public == false then
		return nil, "Track is not public"
	end

	if not HasPlayableTranscoding(track.media) then
		return nil, ENCRYPTED_STREAM_ERR
	end

	local durationSec = math.floor(math.max(0, durationMs) / 1000)
	if durationSec <= 0 then
		return nil, "missing duration"
	end

	return {
		title = BuildTitle(track),
		duration = durationSec,
		thumbnail = NormalizeArtwork(track.artwork_url or (track.user and track.user.avatar_url)),
	}
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local function deliver(metadata)
		local info = {
			title = metadata.title,
			duration = tonumber(metadata.duration) or 0,
			thumbnail = metadata.thumbnail,
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
				local msg = primaryError or (ok and pack and pack.err) or "Theater_RequestFailed"
				onFailure(msg)
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

if SERVER then
	function SERVICE:RefreshClientId(onDone)
		if SoundCloudClientId.refreshing then
			if onDone then onDone(SoundCloudClientId.value) end
			return
		end
		SoundCloudClientId.refreshing = true

		local function finish(id)
			SoundCloudClientId.refreshing = false
			if id and #id == 32 then
				SoundCloudClientId.value = id
				SoundCloudClientId.fetchedAt = CurTime()
			end
			if onDone then onDone(SoundCloudClientId.value) end
		end

		self:Fetch("https://soundcloud.com/", function(body)
			local srcs = ExtractScriptSrcs(body)
			local index = #srcs
			local function tryNext()
				if index < 1 then
					finish(nil)
					return
				end
				local src = srcs[index]
				index = index - 1
				if not src:match("^https?://") then
					src = "https://a-v2.sndcdn.com" .. (src:match("^/") and src or ("/" .. src))
				end
				self:Fetch(src, function(js)
					local id = ExtractClientIdFromJS(js)
					if id then
						finish(id)
					else
						tryNext()
					end
				end, function()
					tryNext()
				end)
			end
			tryNext()
		end, function()
			finish(nil)
		end)
	end

	function SERVICE:GetClientId(onDone)
		if ClientIdIsFresh() then
			if onDone then onDone(SoundCloudClientId.value) end
			return
		end
		self:RefreshClientId(onDone)
	end

	function SERVICE:ResolveTrack(trackPath, onSuccess, onFailure)
		local trackUrl = "https://soundcloud.com/" .. trackPath

		local function attempt(clientId, isRetry)
			local resolveUrl = "https://api-widget.soundcloud.com/resolve?url="
				.. string.gsub(trackUrl, "([^A-Za-z0-9_~%.%-])", function(c)
					return string.format("%%%02X", string.byte(c))
				end)
				.. "&format=json&client_id=" .. clientId

			self:Fetch(resolveUrl, function(body, _, _, code)
				local data = util.JSONToTable(body)
				local meta, err = MetadataFromResolve(data)
				if meta and meta.title then
					onSuccess(meta)
					return
				end

				if not isRetry and (code == 401 or code == 403 or not data) then
					self:RefreshClientId(function(newId)
						if newId and newId ~= clientId then
							attempt(newId, true)
						elseif onFailure then
							onFailure(err or "Theater_RequestFailed")
						end
					end)
					return
				end

				if onFailure then onFailure(err or "Theater_RequestFailed") end
			end, function(err)
				if not isRetry then
					self:RefreshClientId(function(newId)
						if newId and newId ~= clientId then
							attempt(newId, true)
						elseif onFailure then
							onFailure(err or "Theater_RequestFailed")
						end
					end)
				elseif onFailure then
					onFailure(err or "Theater_RequestFailed")
				end
			end)
		end

		self:GetClientId(function(clientId)
			attempt(clientId or CLIENT_ID_FALLBACK, false)
		end)
	end
end

theater.RegisterService("soundcloud", SERVICE)
