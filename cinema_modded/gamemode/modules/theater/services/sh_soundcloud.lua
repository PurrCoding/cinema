-- SoundCloud service for Cinema.
local SERVICE = {
	Name = "SoundCloud",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true
}

local Ignored = {
	["sets"] = true,
}

function SERVICE:Match(url)
	return url.host and url.host:match("soundcloud.com")
end

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

	-- Client-side metadata probe: resolve API first, then oEmbed/widget fallback.
	local METADATA_HTML = [[
<!doctype html><html><head><meta charset="utf-8">
<script src="https://w.soundcloud.com/player/api.js"></script></head><body>
<script>
(async function() {
	const trackUrl = "https://soundcloud.com/{@audioPath}";
	let completed = false;
	let safetyTimeout = setTimeout(function() {
		if (completed) return;
		completed = true;
		console.log("ERROR:SoundCloud metadata probe timed out");
	}, 8000);
	const emit = function(title, duration) {
		if (completed || !title) return false;
		completed = true;
		clearTimeout(safetyTimeout);
		console.log("METADATA:" + JSON.stringify({
			title: String(title),
			duration: Math.floor(Math.max(0, Number(duration) || 0) / 1000)
		}));
		return true;
	};
	const debug = function(message) { console.log("DEBUG:SoundCloud metadata: " + message); };

	// Stage 1: SoundCloud's undocumented resolve endpoint.
	try {
		const resolveUrl = "https://api-widget.soundcloud.com/resolve?url="
			+ encodeURIComponent(trackUrl)
			+ "&format=json&client_id=nIjtjiYnjkOhMyh5xrbqEW12DxeJVnic&app_version=1792051948";
		const response = await fetch(resolveUrl);
		if (!response.ok) throw new Error("resolve HTTP " + response.status);
		const data = await response.json();
		const duration = data && (data.full_duration || data.duration);
		if (data && data.title && Number(duration) > 0 && emit(data.title, duration)) return;
		debug("resolve response was incomplete");
	} catch (error) {
		debug("resolve unavailable; trying oEmbed/widget (" + error + ")");
	}

	// Stage 2: oEmbed title and iframe URL, if available.
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

	// Stage 3: official widget API, using the oEmbed iframe or a direct URL.
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
		const finish = function(title, duration) {
			if (finished) return;
			finished = true;
			if (!emit(title || embedTitle, duration)) {
				console.log("ERROR:SoundCloud widget returned incomplete metadata");
			}
		};
		player.bind(SC.Widget.Events.READY, function() {
			player.getCurrentSound(function(sound) {
				player.getDuration(function(duration) {
					finish((sound && sound.title) || embedTitle, duration || (sound && sound.duration) || 0);
				});
			});
		});
		player.bind(SC.Widget.Events.ERROR, function() {
			debug("widget emitted an error");
		});
	} catch (error) {
		debug("widget fallback failed (" + error + ")");
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

function SERVICE:GetURLInfo(url)
	if not url.path then return false end

	local path1, path2 = url.path:match("/([%a%d-_]+)/([%a%d-_]+)$")
	if path1 and not Ignored[path1] and path2 then
		return { Data = ("%s/%s"):format(path1, path2) }
	end

	return false
end

local function ParseSoundCloudHTML(body)
	local json = body:match('<script>window%.__sc_hydration = (.-);</script>')
	if not json then return nil, "Hydration JSON not found" end

	local data = util.JSONToTable(json)
	if not data then return nil, "Failed to parse JSON" end

	for i = 1, #data do
		if data[i].hydratable == "sound" and data[i].data then
			local metadata = data[i].data
			if metadata.embeddable_by ~= "all" or not metadata.public then
				return nil, "Track is not embeddable"
			end

			return {
				title = metadata.title or "Unknown",
				thumbnail = metadata.artwork_url,
				duration = math.floor((metadata.duration or metadata.full_duration or 0) / 1000)
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
		if onSuccess then pcall(onSuccess, info) end
	end

	local function runServerFallback(primaryError)
		local trackPath = data:Data()
		local url = "https://soundcloud.com/" .. trackPath
		self:Fetch(url, function(body)
			local ok, metadata, err = pcall(ParseSoundCloudHTML, body)
			if ok and metadata and metadata.title then
				deliver(metadata)
			elseif onFailure then
				onFailure(primaryError or (ok and err) or metadata or "Theater_RequestFailed")
			end
		end, function(err)
			if onFailure then onFailure(primaryError or err or "Theater_RequestFailed") end
		end)
	end

	theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
		if metadata and not metadata.err and metadata.title and metadata.title ~= "" and metadata.title ~= "Unknown" then
			deliver(metadata)
			return
		end
		runServerFallback(metadata and metadata.err)
	end)
end

theater.RegisterService("soundcloud", SERVICE)
