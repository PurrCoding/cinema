# Implementing a Custom Video Service

This guide walks through creating a new media service for Cinema (Fixed Edition) from scratch.  
Services live under:

```
cinema_modded/gamemode/modules/theater/services/
```

Every service is a Lua table that inherits from the **base** service via `theater.RegisterService`.

---

## 1. Architecture overview

```
URL pasted / requested
        │
        ▼
theater.ExtractURLData(url)          -- parses URL, finds matching service
        │
        ▼
SERVICE:Match(url)                   -- does this service handle the host?
        │
        ▼
SERVICE:GetURLInfo(url)              -- extracts video ID + optional start time
        │
        ▼
SERVICE:GetVideoInfo(data, ok, fail) -- fetches title, duration, thumbnail
        │
        ▼
VIDEO object created & queued
        │
        ▼
CLIENT: SERVICE:LoadProvider(Video, panel)  -- opens embed / HTML player
        │
        ▼
JavaScript sets window.cinema_controller
exTheater.controllerReady()          -- volume, seek, pause become available
```

The base service (`sh_base.lua`) already implements HTTP helpers, the DHTML crawler, the CinemaPlayer JS bridge, and `LoadVideo`. You only override what you need.

---

## 2. Minimal service skeleton

Create a new file, e.g. `sh_myservice.lua`:

```lua
local SERVICE = {
	Name = "My Service",          -- shown in UI / history
	IsTimed = true,               -- true = seekable VOD; false = live / infinite
	IsCacheable = true,           -- store in cinema_history DB
	NeedsCodecFix = false,        -- set true if H.264 / proprietary codecs needed
	ExtentedVideoInfo = false,    -- true = GetVideoInfo receives full video table
	TheaterType = THEATER_NONE,   -- THEATER_NONE | THEATER_PRIVATE | …
	NeedsExtraChecks = false,     -- advanced request-button control
}

-- 1) Can this service handle the URL?
function SERVICE:Match(url)
	return url.host and url.host:match("example%.com")
end

-- 2) Extract stable video ID (+ optional start time)
function SERVICE:GetURLInfo(url)
	local info = {}

	-- Example: https://example.com/watch/abc123?t=30
	if url.path then
		local id = url.path:match("^/watch/([%w%-_]+)")
		if id then
			info.Data = id
		end
	end

	if url.query and url.query.t then
		local t = tonumber(url.query.t)
		if t and t > 0 then
			info.StartTime = t
		end
	end

	return info.Data and info or false
end

-- 3) Fetch metadata (title, duration, thumbnail)
function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	-- data is the string returned as info.Data above
	local apiUrl = ("https://api.example.com/v1/videos/%s"):format(data)

	self:Fetch(apiUrl, function(body, length, headers, code)
		local response = util.JSONToTable(body)
		if not response then
			return onFailure("Theater_RequestFailed")
		end

		local info = {
			title     = response.title or "Unknown",
			duration  = tonumber(response.duration) or 0,  -- seconds; 0 = live
			thumbnail = response.thumbnail_url or "",
		}

		-- Optional: switch to a live variant
		-- if response.is_live then
		--     info.type = "myservicelive"
		--     info.duration = 0
		-- end

		pcall(onSuccess, info)
	end, onFailure)
end

-- 4) Client: load the actual player
if CLIENT then
	local EMBED_URL = "https://example.com/embed/%s?autoplay=1"

	local THEATER_JS = [[
		(function() {
			var checkerInterval = setInterval(function() {
				var player = document.querySelector("video");
				if (player && player.readyState >= 3) {
					clearInterval(checkerInterval);
					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 50);
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		local startTime = 0
		if self.IsTimed then
			startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))
		end

		local url = EMBED_URL:format(Video:Data())
		if self.IsTimed and startTime > 0 then
			url = url .. "&start=" .. startTime
		end

		panel:OpenURL(url)

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)   -- injects CinemaPlayer bridge
			pnl:RunJavascript(THEATER_JS)
		end
	end
end

theater.RegisterService("myservice", SERVICE)
```

That is enough for a working VOD service.

---

## 3. Required & optional properties

| Property | Type | Default | Meaning |
|----------|------|---------|---------|
| `Name` | string | `"Base"` | Display name |
| `IsTimed` | bool | `true` | Supports seeking / has finite duration |
| `IsCacheable` | bool | `true` | Allowed in `cinema_history` |
| `NeedsCodecFix` | bool | `false` | Requires GMod CEF Codec Fix |
| `ExtentedVideoInfo` | bool | `false` | `GetVideoInfo` receives full video object |
| `TheaterType` | flag | `THEATER_NONE` | Restrict to certain theater types |
| `NeedsExtraChecks` | bool | `false` | Custom request-button logic via JS |
| `Hidden` | bool | `false` | Not shown in service lists (used for live variants) |

---

## 4. Core methods you implement

### `SERVICE:Match(url)`

- `url` is a parsed table (`url.host`, `url.path`, `url.query`, …) from the shared URL library.
- Return any truthy value when this service should handle the link.
- Keep it cheap; it is called for every request against every registered service.

### `SERVICE:GetURLInfo(url)`

Must return either:

```lua
{
	Data = "stable-video-id",   -- required, string
	StartTime = 42,             -- optional, seconds
}
```

or `false` if the URL cannot be parsed.

`Data` is what later appears as `Video:Data()` and is passed to `GetVideoInfo` / `LoadProvider`.

### `SERVICE:GetVideoInfo(data, onSuccess, onFailure)`

- Runs on the **server** for most services (or triggers a client crawler).
- Call `onSuccess(info)` with:

```lua
{
	title     = "Video Title",
	duration  = 123,            -- seconds; 0 = treated as live
	thumbnail = "https://…",    -- optional
	type      = "myservicelive" -- optional: force another service class
}
```

- Call `onFailure("Theater_RequestFailed")` (or any i18n key / string) on error.

Use the inherited helper:

```lua
self:Fetch(url, onReceive, onFailure [, extraHeaders])
```

### `SERVICE:LoadProvider(Video, panel)` (CLIENT)

- `panel` is a DHTML panel that will fill the theater screen.
- Open an embed URL or inject HTML, then make sure JavaScript eventually does:

```js
window.cinema_controller = <HTMLMediaElement or compatible object>;
exTheater.controllerReady();
```

The base method `LoadExFunctions` injects a `window.theater` CinemaPlayer that supports `setVolume`, `seek`, `play`, `pause`, and `sync`.

---

## 5. Live-stream variant pattern

Many platforms need a second, non-timed service for live content:

```lua
theater.RegisterService("myservice", SERVICE)

theater.RegisterService("myservicelive", {
	Name = "My Service Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,   -- players never pick this directly
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
})
```

In `GetVideoInfo`, when you detect a live stream:

```lua
info.type = "myservicelive"
info.duration = 0
```

The theater system then switches the video type automatically.

---

## 6. Client-side metadata (YouTube-style crawler)

If the platform has no usable server API, implement `GetMetadata` on the client:

```lua
if CLIENT then
	function SERVICE:GetMetadata(data, callback)
		local panel = self:CreateWebCrawler(callback)
		panel:OpenURL("https://example.com/watch/" .. data)

		panel.OnDocumentReady = function(pnl)
			pnl:QueueJavascript([[
				// extract title / duration and print:
				// console.log("METADATA:" + JSON.stringify({title, duration, isLive}));
				// or console.log("ERROR:message");
			]])
		end
	end
end
```

`CreateWebCrawler` returns an invisible DHTML panel that listens for `METADATA:` / `ERROR:` console messages and then calls your callback.

---

## 7. JavaScript player contract

The theater expects a controller object with roughly this interface (already provided by `LoadExFunctions` when you assign an HTML5 `<video>`):

```js
window.cinema_controller = videoElement;  // must support:
// .volume (0–1)
// .currentTime
// .play() / .pause()
// .readyState
```

For custom players (iframe APIs, etc.) you can implement a thin adapter:

```js
window.cinema_controller = {
	get volume() { return api.getVolume() / 100; },
	set volume(v) { api.setVolume(v * 100); },
	get currentTime() { return api.getCurrentTime(); },
	set currentTime(t) { api.seekTo(t); },
	play() { api.play(); },
	pause() { api.pause(); },
	readyState: 4
};
exTheater.controllerReady();
```

---

## 8. Real-world reference implementations

| File | Pattern to study |
|------|------------------|
| `sh_dailymotion.lua` | Clean API + live dual-service |
| `sh_youtube.lua` | Client crawler, pause offset, hash parameters |
| `sh_url.lua` | Direct HTML5 / image / audio fallback |
| `sh_bilibili*.lua` | Multi-part IDs, several related services |
| `sh_jellyfin.lua` | Self-hosted media server |
| `sh_soundcloud.lua` | Audio-only + extended video info |

Always start from `sh_dailymotion.lua` or the skeleton above unless you need crawler complexity.

---

## 9. Registration & loading order

`sh_services.lua` does:

```lua
include("services/sh_base.lua")          -- must be first
Loader.Load("modules/theater/services")  -- loads every sh_*.lua
```

Your file is picked up automatically as long as it is named `sh_something.lua` inside the services folder and calls `theater.RegisterService`.

---

## 10. Testing checklist

1. Restart the server / changelevel after adding the file.
2. In a theater, paste a matching URL → request should appear in the queue.
3. Confirm title, duration and thumbnail look correct.
4. Confirm playback starts for all players in the theater.
5. Test seek / pause / volume if `IsTimed = true`.
6. Test a live URL if you registered a live variant.
7. Check console for JavaScript errors (`cinema_html_filter 1` helps).
8. Verify `NeedsCodecFix` behaviour with and without GMod CEF Codec Fix.

---

## 11. Common pitfalls

- **Forgetting `theater.RegisterService`** → service never appears.
- **Returning non-string `Data`** → later code breaks.
- **Not calling `exTheater.controllerReady()`** → volume/seek stay broken.
- **Blocking the main thread** in `GetVideoInfo` → use `self:Fetch` (async).
- **Hard-coding HTTP instead of `self:Fetch`** → missing User-Agent / headers.
- **Overlapping `Match` with another service** → first registered match wins; be specific.
- **Live streams with `IsTimed = true`** → seek UI appears and confuses players.

---

## Related pages

- [Video Services](video-services) – list of built-in providers
- [Development](development) – module layout
- [Commands](commands) – `cinema_video_request` etc.
