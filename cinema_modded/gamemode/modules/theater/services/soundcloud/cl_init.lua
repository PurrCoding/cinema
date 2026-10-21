local SERVICE = {
	Name = "SoundCloud",
	IsTimed = true,

	NeedsCodecFix = true,
	ExtentedVideoInfo = true,

	PlayerAPIURL = "https://w.soundcloud.com/player/api.js",
	TrackURLTemplate = "https://soundcloud.com/{@audioPath}",
	OEmbedURL = "https://soundcloud.com/oembed?format=json&url=",
	PlayerURL = "https://w.soundcloud.com/player/?url=",
	HomeURL = "https://soundcloud.com/",
	AssetBaseURL = "https://a-v2.sndcdn.com",
	ResolveURL = "https://api-widget.soundcloud.com/resolve?url=",
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

if CLIENT then
	local PLAYER_HTML = [[
<!doctype html>
<html><head><meta charset="utf-8">
<script src="__SC_PLAYER_API_URL__"></script></head>
<body><script>
(async function() {
    const trackUrl = "__SC_TRACK_URL_TEMPLATE__";
    let frame = null;

    try {
        const response = await fetch("__SC_OEMBED_URL__" + encodeURIComponent(trackUrl));
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
        frame.src = "__SC_PLAYER_URL__"
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
	PLAYER_HTML = PLAYER_HTML:Replace("__SC_PLAYER_API_URL__", SERVICE.PlayerAPIURL)
		:Replace("__SC_TRACK_URL_TEMPLATE__", SERVICE.TrackURLTemplate)
		:Replace("__SC_OEMBED_URL__", SERVICE.OEmbedURL)
		:Replace("__SC_PLAYER_URL__", SERVICE.PlayerURL)
		:Replace("__SC_HOME_URL__", SERVICE.HomeURL)
		:Replace("__SC_ASSET_BASE_URL__", SERVICE.AssetBaseURL)
		:Replace("__SC_RESOLVE_URL__", SERVICE.ResolveURL)

	local METADATA_HTML = [[
<!doctype html><html><head><meta charset="utf-8"></head><body>
<script>
(async function() {
    const trackUrl = "__SC_TRACK_URL_TEMPLATE__";
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
            const page = await fetch("__SC_HOME_URL__", { credentials: "omit" });
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
                    src = "__SC_ASSET_BASE_URL__" + (src.charAt(0) === "/" ? src : "/" + src);
                }
                try {
                    const jsRes = await fetch(src, { credentials: "omit" });
                    if (!jsRes.ok) continue;
                    const js = await jsRes.text();
                    const idMatch = js.match(/client_id\s*:\s*["']([0-9a-zA-Z]{32})["']/)
                        || js.match(/"client_id"\s*:\s*"([0-9a-zA-Z]{32})"/);
                    if (idMatch) return idMatch[1];
                } catch (e) {}
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

    try {
        const clientId = await scrapeClientId();
        const resolveUrl = "__SC_RESOLVE_URL__"
            + encodeURIComponent(trackUrl)
            + "&format=json&client_id=" + encodeURIComponent(clientId);
        const response = await fetch(resolveUrl, { credentials: "omit" });
        if (!response.ok) throw new Error("resolve HTTP " + response.status);
        const data = await response.json();
        const track = (data && data.collection && data.collection[0]) || data;
        const duration = track && (track.full_duration || track.duration);
        const title = titleFromTrack(track);
        if (track && track.media && Array.isArray(track.media.transcodings) && track.media.transcodings.length > 0) {
            const playable = track.media.transcodings.some(function(t) {
                const proto = ((t.format && t.format.protocol) || t.protocol || "").toLowerCase();
                return proto && proto.indexOf("encrypted") === -1
                    && proto.indexOf("cbc-") !== 0 && proto.indexOf("ctr-") !== 0;
            });
            if (!playable) {
                completed = true;
                clearTimeout(safetyTimeout);
                console.log("ERROR:SoundCloud track only offers encrypted/DRM streams (not playable in GMod)");
                return;
            }
        }
        if (title && Number(duration) > 0 && emit(title, duration, normalizeArt(track.artwork_url))) return;
        debug("resolve response was incomplete");
    } catch (error) {
        debug("resolve unavailable (" + error + ")");
    }

    console.log("ERROR:SoundCloud metadata probe exhausted");
})();
</script></body></html>
]]
	METADATA_HTML = METADATA_HTML:Replace("__SC_PLAYER_API_URL__", SERVICE.PlayerAPIURL)
		:Replace("__SC_TRACK_URL_TEMPLATE__", SERVICE.TrackURLTemplate)
		:Replace("__SC_OEMBED_URL__", SERVICE.OEmbedURL)
		:Replace("__SC_PLAYER_URL__", SERVICE.PlayerURL)
		:Replace("__SC_HOME_URL__", SERVICE.HomeURL)
		:Replace("__SC_ASSET_BASE_URL__", SERVICE.AssetBaseURL)
		:Replace("__SC_RESOLVE_URL__", SERVICE.ResolveURL)

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

if SERVER then
	return SERVICE
end

theater.RegisterService("soundcloud", SERVICE)
