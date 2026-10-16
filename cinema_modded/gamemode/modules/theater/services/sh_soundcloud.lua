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
	["tracks"] = true, -- /user/tracks is a list page, not a single track
}

-- ---------------------------------------------------------------------------
-- Shared client_id cache (server + client). Refreshed like yt-dlp when API
-- returns 401/403 or when the cache is older than CLIENT_ID_TTL seconds.
-- ---------------------------------------------------------------------------
local CLIENT_ID_TTL = 6 * 60 * 60 -- 6 hours
local CLIENT_ID_FALLBACK = "nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic" -- last known working widget id

local SoundCloudClientId = {
	value = CLIENT_ID_FALLBACK,
	fetchedAt = 0,
	refreshing = false,
}

local function ClientIdIsFresh()
	return SoundCloudClientId.value
		and SoundCloudClientId.value ~= ""
		and (CurTime() - SoundCloudClientId.fetchedAt) < CLIENT_ID_TTL
end

local function ExtractClientIdFromJS(body)
	if not isstring(body) or body == "" then return nil end
	-- yt-dlp pattern: client_id: "32-char alnum"
	local id = body:match('client_id%s*:%s*"([0-9a-zA-Z]{32})"')
		or body:match("client_id%s*:%s*'([0-9a-zA-Z]{32})'")
		or body:match('"client_id"%s*:%s*"([0-9a-zA-Z]{32})"')
		or body:match("client_id%s*=%s*\"([0-9a-zA-Z]{32})\"")
	return id
end

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

local function NormalizeArtwork(url)
	if not isstring(url) or url == "" then return nil end
	-- Prefer a larger thumbnail when SoundCloud serves size variants.
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

local function MetadataFromResolve(data)
	if not istable(data) then return nil end
	-- Resolve can return a track object or a collection wrapper.
	local track = data
	if data.collection and istable(data.collection[1]) then
		track = data.collection[1]
	end
	if data.kind and data.kind ~= "track" and data.tracks then
		-- playlist / set – not supported as a single queue item
		return nil, "playlists/sets are not supported"
	end

	local durationMs = tonumber(track.full_duration) or tonumber(track.duration) or 0
	local title = track.title
	if not title or title == "" then return nil, "missing title" end

	-- Respect embed policy when present.
	if track.embeddable_by and track.embeddable_by ~= "all" and track.embeddable_by ~= "me" then
		return nil, "Track is not embeddable"
	end
	if track.public == false then
		return nil, "Track is not public"
	end

	return {
		title = BuildTitle(track),
		duration = math.floor(math.max(0, durationMs) / 1000),
		thumbnail = NormalizeArtwork(track.artwork_url or (track.user and track.user.avatar_url)),
	}
end

-- ---------------------------------------------------------------------------
-- Server-side: fetch / refresh client_id from SoundCloud JS bundles
-- ---------------------------------------------------------------------------
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
			-- Prefer later scripts (app bundles usually load last), same as yt-dlp.
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

	--- Resolve track metadata via api-widget / api-v2 (primary server path).
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

				-- Stale client_id → refresh once and retry.
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

-- ---------------------------------------------------------------------------
-- Client: player + metadata probe (dynamic client_id when possible)
-- ---------------------------------------------------------------------------
if CLIENT then
	local PLAYER_HTML = [[
<!doctype html>
<html><head><meta charset="utf-8">
<script src="https://w.soundcloud.com/player/api.js"></script></head>
<body><script>
(async function() {
	const trackUrl = "https://soundcloud.com/{@audioPath}";
	let frame = null;

	// Prefer SoundCloud's recommended iframe, but do not depend on oEmbed being available.
	try {
		const response = await fetch("https://soundcloud.com/oembed?format=json&url=" + encodeURIComponent(trackUrl));
		if (!response.ok) throw new Error("oEmbed HTTP " + response.status);
		const data = await response.json();
		if (data && data.html) {
			const container = document.createElement("div");
			container.innerHTML = data.html;
			frame = container.querySelector("iframe");
		}
	} catch (error) {
		console.log("DEBUG:SoundCloud oEmbed failed; using direct widget URL (" + error + ")");
	}

	if (!frame) {
		frame = document.createElement("iframe");
		frame.src = "https://w.soundcloud.com/player/?url="
			+ encodeURIComponent(trackUrl).replace(/%2F/g, "/")
			+ "&auto_play=true&hide_related=true&show_comments=false&show_user=true&visual=false";
	}
	frame.setAttribute("allow", "autoplay");
	frame.setAttribute("width", "100%");
	frame.setAttribute("height", "166");
	document.body.appendChild(frame);
	document.body.style.margin = "0";
	document.body.style.overflow = "hidden";

	const player = SC.Widget(frame);
	player.bind(SC.Widget.Events.READY, function() {
		let totalDuration = 0;
		let curVolume = 0;
		let curTime = 0;
		player.getDuration(function(duration) {
			totalDuration = Number(duration) || 0;
			frame.setAttribute("height", window.innerHeight);
			setInterval(function() {
				player.getVolume(function(volume) { curVolume = Number(volume) || 0; });
				player.getPosition(function(position) { curTime = Number(position) || 0; });
			}, 250);

			Object.defineProperty(player, "volume", {
				get: function() { return curVolume / 100; },
				set: function(volume) { player.setVolume(Math.max(0, Math.min(1, Number(volume) || 0)) * 100); }
			});
			Object.defineProperty(player, "currentTime", {
				get: function() { return curTime / 1000; },
				set: function(time) { player.seekTo(Math.max(0, Number(time) || 0) * 1000); }
			});
			Object.defineProperty(player, "duration", {
				get: function() { return totalDuration / 1000; }
			});

			player.play();
			window.cinema_controller = player;
			exTheater.controllerReady();
		});
	});
	player.bind(SC.Widget.Events.ERROR, function() {
		console.log("ERROR:SoundCloud widget failed to initialize");
	});
})();
</script></body></html>
]]

	-- Client-side metadata probe:
	-- 1) scrape client_id from JS bundles (yt-dlp style)
	-- 2) api-widget resolve
	-- 3) oEmbed
	-- 4) official Widget API
	local METADATA_HTML = [[
<!doctype html><html><head><meta charset="utf-8">
<script src="https://w.soundcloud.com/player/api.js"></script></head><body>
<script>
(async function() {
	const trackUrl = "https://soundcloud.com/{@audioPath}";
	const FALLBACK_CLIENT_ID = "nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic";
	let completed = false;
	let safetyTimeout = setTimeout(function() {
		if (completed) return;
		completed = true;
		console.log("ERROR:SoundCloud metadata probe timed out");
	}, 12000);

	const emit = function(title, duration, thumbnail) {
		if (completed || !title) return false;
		completed = true;
		clearTimeout(safetyTimeout);
		const payload = {
			title: String(title),
			duration: Math.floor(Math.max(0, Number(duration) || 0) / 1000)
		};
		if (thumbnail) payload.thumbnail = String(thumbnail);
		console.log("METADATA:" + JSON.stringify(payload));
		return true;
	};
	const debug = function(message) { console.log("DEBUG:SoundCloud metadata: " + message); };

	async function scrapeClientId() {
		try {
			const page = await fetch("https://soundcloud.com/", { credentials: "omit" });
			if (!page.ok) throw new Error("homepage HTTP " + page.status);
			const html = await page.text();
			const srcs = [];
			const re = /<script[^>]+src=["']([^"']+)["']/gi;
			let m;
			while ((m = re.exec(html)) !== null) {
				if (/sndcdn\.com|soundcloud\.com/i.test(m[1])) srcs.push(m[1]);
			}
			for (let i = srcs.length - 1; i >= 0; i--) {
				let src = srcs[i];
				if (!/^https?:\/\//i.test(src)) {
					src = "https://a-v2.sndcdn.com" + (src.charAt(0) === "/" ? src : "/" + src);
				}
				try {
					const jsRes = await fetch(src, { credentials: "omit" });
					if (!jsRes.ok) continue;
					const js = await jsRes.text();
					const idMatch = js.match(/client_id\s*:\s*["']([0-9a-zA-Z]{32})["']/)
						|| js.match(/"client_id"\s*:\s*"([0-9a-zA-Z]{32})"/);
					if (idMatch) return idMatch[1];
				} catch (e) { /* try next asset */ }
			}
		} catch (error) {
			debug("client_id scrape failed (" + error + ")");
		}
		return FALLBACK_CLIENT_ID;
	}

	function normalizeArt(url) {
		if (!url) return null;
		return String(url).replace(/-large\./, "-t500x500.").replace(/-t300x300\./, "-t500x500.");
	}

	function titleFromTrack(data) {
		if (!data || !data.title) return null;
		const user = data.user && (data.user.username || data.user.permalink);
		if (user && data.title.indexOf(user) === -1) return user + " - " + data.title;
		return data.title;
	}

	// Stage 1: resolve with fresh (or fallback) client_id
	try {
		const clientId = await scrapeClientId();
		const resolveUrl = "https://api-widget.soundcloud.com/resolve?url="
			+ encodeURIComponent(trackUrl)
			+ "&format=json&client_id=" + encodeURIComponent(clientId);
		const response = await fetch(resolveUrl, { credentials: "omit" });
		if (!response.ok) throw new Error("resolve HTTP " + response.status);
		const data = await response.json();
		const track = (data && data.collection && data.collection[0]) || data;
		const duration = track && (track.full_duration || track.duration);
		const title = titleFromTrack(track);
		if (title && Number(duration) > 0 && emit(title, duration, normalizeArt(track.artwork_url))) return;
		debug("resolve response was incomplete");
	} catch (error) {
		debug("resolve unavailable; trying oEmbed/widget (" + error + ")");
	}

	// Stage 2: oEmbed title and iframe URL
	let embedTitle = null;
	let embedUrl = null;
	try {
		const response = await fetch("https://soundcloud.com/oembed?format=json&url=" + encodeURIComponent(trackUrl));
		if (!response.ok) throw new Error("oEmbed HTTP " + response.status);
		const data = await response.json();
		embedTitle = data && data.title;
		const match = data && data.html && data.html.match(/src=["']([^"']+)["']/i);
		if (match) embedUrl = match[1].replace(/&amp;/g, "&");
	} catch (error) {
		debug("oEmbed failed (" + error + ")");
	}

	// Stage 3: official widget API
	try {
		const frame = document.createElement("iframe");
		frame.setAttribute("allow", "autoplay");
		frame.setAttribute("width", "100%");
		frame.setAttribute("height", "166");
		frame.src = embedUrl || ("https://w.soundcloud.com/player/?url="
			+ encodeURIComponent(trackUrl) + "&auto_play=false&hide_related=true&show_comments=false");
		document.body.appendChild(frame);
		const player = SC.Widget(frame);
		let finished = false;
		const finish = function(title, duration, thumbnail) {
			if (finished) return;
			finished = true;
			if (!emit(title || embedTitle, duration, thumbnail)) {
				console.log("ERROR:SoundCloud widget returned incomplete metadata");
			}
		};
		player.bind(SC.Widget.Events.READY, function() {
			player.getCurrentSound(function(sound) {
				player.getDuration(function(duration) {
					const title = (sound && sound.title) || embedTitle;
					const art = sound && (sound.artwork_url || (sound.user && sound.user.avatar_url));
					finish(title, duration || (sound && sound.duration) || 0, normalizeArt(art));
				});
			});
		});
		player.bind(SC.Widget.Events.ERROR, function() {
			debug("widget emitted an error");
			if (!finished && embedTitle) {
				finish(embedTitle, 0, null);
			}
		});
	} catch (error) {
		debug("widget fallback failed (" + error + ")");
		if (embedTitle && emit(embedTitle, 0, null)) return;
		console.log("ERROR:SoundCloud metadata probe exhausted");
	}
})();
</script></body></html>
]]

	function SERVICE:LoadProvider(Video, panel)
		local html = PLAYER_HTML:Replace("{@audioPath}", Video:Data())

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
		end

		panel:SetHTML(html)
	end

	function SERVICE:SearchFunctions(browser)
		if not IsValid(browser) then return end

		browser:RunJavascript([[
			setInterval(function() {
				var cookieBanner = document.querySelector("#onetrust-banner-sdk #onetrust-reject-all-handler");
				if (cookieBanner) cookieBanner.click();
			}, 500);
		]])
	end

	function SERVICE:GetMetadata(data, callback)
		local trackPath = isstring(data) and data or (istable(data) and (data.Data or data.data)) or ""
		local panel = self:CreateWebCrawler(callback)
		panel:SetHTML(METADATA_HTML:Replace("{@audioPath}", trackPath))
	end
end

-- ---------------------------------------------------------------------------
-- URL matching
-- ---------------------------------------------------------------------------
function SERVICE:Match(url)
	return url.host and url.host:match("soundcloud.com")
end

function SERVICE:GetURLInfo(url)
	if not url.path then return false end

	-- https://soundcloud.com/artist/track-name
	-- https://soundcloud.com/artist/track-name?in=...
	local path1, path2 = url.path:match("^/([%a%d-_]+)/([%a%d-_]+)/?$")
	if path1 and path2 and not Ignored[path1] and not Ignored[path2] then
		return { Data = ("%s/%s"):format(path1, path2) }
	end

	return false
end

-- ---------------------------------------------------------------------------
-- Server HTML hydration parser (fallback)
-- ---------------------------------------------------------------------------
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

			return {
				title = BuildTitle(metadata),
				thumbnail = NormalizeArtwork(metadata.artwork_url),
				duration = math.floor((metadata.full_duration or metadata.duration or 0) / 1000)
			}
		end
	end

	return nil, "Sound metadata not found in hydration data"
end

-- ---------------------------------------------------------------------------
-- GetVideoInfo: server resolve → client crawler → hydration HTML
-- ---------------------------------------------------------------------------
function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local function deliver(metadata)
		local info = {
			title = metadata.title,
			duration = tonumber(metadata.duration) or 0,
			thumbnail = metadata.thumbnail
		}
		if onSuccess then pcall(onSuccess, info) end
	end

	local trackPath = data:Data()

	local function runHydrationFallback(primaryError)
		local pageUrl = "https://soundcloud.com/" .. trackPath
		self:Fetch(pageUrl, function(body)
			local ok, metadata, err = pcall(ParseSoundCloudHTML, body)
			if ok and metadata and metadata.title then
				deliver(metadata)
			elseif onFailure then
				onFailure(primaryError or (ok and err) or tostring(metadata) or "Theater_RequestFailed")
			end
		end, function(err)
			if onFailure then onFailure(primaryError or err or "Theater_RequestFailed") end
		end)
	end

	local function runClientCrawler(primaryError)
		theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
			if metadata and not metadata.err and metadata.title and metadata.title ~= "" and metadata.title ~= "Unknown" then
				deliver(metadata)
				return
			end
			runHydrationFallback(primaryError or (metadata and metadata.err))
		end)
	end

	-- Prefer pure server resolve (no client CEF required for metadata).
	if SERVER and self.ResolveTrack then
		self:ResolveTrack(trackPath, function(metadata)
			deliver(metadata)
		end, function(err)
			runClientCrawler(err)
		end)
		return
	end

	runClientCrawler(nil)
end

theater.RegisterService("soundcloud", SERVICE)
