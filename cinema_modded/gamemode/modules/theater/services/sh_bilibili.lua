--[[
    Unified Bilibili service router for Cinema.

    One implementation, four service states:
    - bilibili        -> BV videos
    - bilibili_legacy -> AV videos
    - bilibili_live   -> live rooms
    - bilibiliep      -> Bangumi episodes

    The router owns URL matching/parsing. The state chooser owns playback,
    metadata and timing differences. This keeps all Bilibili logic in one file
    while preserving Cinema's existing service types and networking semantics.
]]

local ROUTER = {}
local STATES = {}

local function Host(url)
    return string.lower(url.host or "")
end

local function Path(url)
    return url.path or ""
end

local function Page(url)
    return tonumber(url.query and url.query.p) or 1
end

local function VideoHost(host)
    return host:match("www%.bilibili%.com") or host:match("b23%.tv")
end

function ROUTER.Match(url)
    local host = Host(url)
    local path = Path(url)

    if host:match("live%.bilibili%.com") then
        local room = path:match("^/([%w_%-]+)")
        if room then return "live", room end
    end

    if host:match("www%.bilibili%.com") then
        local episode = path:match("/bangumi/play/ep([%w_%-]+)")
        if episode then return "episode", episode end
    end

    if VideoHost(host) then
        local bv = path:match("(BV[%w_%-]+)")
        if bv then return "bv", bv, Page(url) end

        local av = path:match("[/]?(av[%w_%-]+)")
        if av then return "av", av:sub(3), Page(url) end
    end

    return false
end

function ROUTER.Resolve(data)
    local parts = string.Explode("|", data or "")
    local state = parts[1]
    local value = parts[2]
    local page = tonumber(parts[3]) or 1

    if not state or not value then return false end
    if not STATES[state] then return false end

    return STATES[state], value, page
end

local function VideoData(kind, value, page)
    return kind .. "|" .. value .. "|" .. tostring(page or 1)
end

STATES.bv = {
    class = "bilibili",
    route = "bv",
    timed = true,
    api = "https://api.bilibili.com/x/web-interface/view?bvid=%s",
    player = "https://player.bilibili.com/player.html?bvid=%s&p=%s&autoplay=1"
}

STATES.av = {
    class = "bilibili_legacy",
    route = "av",
    timed = true,
    api = "https://api.bilibili.com/x/web-interface/view?aid=%s",
    player = "https://player.bilibili.com/player.html?aid=%s&p=%s&autoplay=1"
}

STATES.live = {
    class = "bilibili_live",
    route = "live",
    timed = false,
    api = "https://api.live.bilibili.com/room/v1/Room/get_info?room_id=%s",
    player = "https://www.bilibili.com/blackboard/live/live-mobile-playerV3.html?roomId=%s&danmaku=1&autoplay=1"
}

STATES.episode = {
    class = "bilibiliep",
    route = "episode",
    timed = true,
    api = "https://api.bilibili.com/pgc/view/web/season?ep_id=%s",
    player = "https://www.bilibili.com/bangumi/play/ep%s"
}

local BASE = {
    Name = "哔哩哔哩",
    NeedsCodecFix = true
}

function BASE:Match(url)
    local state = ROUTER.Match(url)
    return state and true or false
end

function BASE:GetURLInfo(url)
    local state, value, page = ROUTER.Match(url)
    if not state then return false end

    if state == "bv" then
        return { Data = VideoData("bv", value, page) }
    elseif state == "av" then
        return { Data = VideoData("av", value, page) }
    elseif state == "live" then
        return { Data = "live|" .. value }
    elseif state == "episode" then
        return { Data = "episode|" .. value }
    end

    return false
end

if CLIENT then
    local VIDEO_JS = [[
        (function() {
            var started = false;
            var failed = false;
            var elapsed = 0;

            function fail(message) {
                if (started || failed) return;
                failed = true;
                clearInterval(checkerInterval);
                console.error("[Cinema][Bilibili] " + message);
                if (window.exTheater && typeof exTheater.controllerError === "function") {
                    exTheater.controllerError(message);
                }
            }

            var checkerInterval = setInterval(function() {
                if (started || failed) return;
                elapsed += 250;

                var bodyText = (document.body && document.body.innerText || "").toLowerCase();
                var titleText = (document.title || "").toLowerCase();
                var errorText = bodyText + " " + titleText;

                var blocked =
                    errorText.indexOf("not available in your country") !== -1 ||
                    errorText.indexOf("not available in your region") !== -1 ||
                    errorText.indexOf("copyright restrictions") !== -1 ||
                    errorText.indexOf("regional restrictions") !== -1 ||
                    errorText.indexOf("region restricted") !== -1 ||
                    errorText.indexOf("该视频在您所在地区不可用") !== -1 ||
                    errorText.indexOf("您所在地区") !== -1 ||
                    (errorText.indexOf("版权") !== -1 && errorText.indexOf("地区") !== -1);

                if (blocked) return fail("Bilibili playback blocked by Bilibili");

                var player = document.querySelector("video");
                if (!player) {
                    if (elapsed >= 30000) fail("Bilibili player did not create a video element");
                    return
                }

                if (player.error) return fail("Bilibili HTML5 video error");

                if (player.readyState >= 2 && player.duration > 0) {
                    started = true;
                    clearInterval(checkerInterval);
                    document.body.style.backgroundColor = "black";
                    window.cinema_controller = player;

                    var playPromise = player.play();
                    if (playPromise && typeof playPromise.catch === "function") {
                        playPromise.catch(function(err) {
                            console.warn("[Cinema][Bilibili] Autoplay was rejected:", err);
                        });
                    }

                    exTheater.controllerReady();
                    return;
                }

                if (elapsed >= 30000) fail("Bilibili player timed out");
            }, 250);
        })();
    ]]

    local LIVE_JS = [[
        (function() {
            var started = false;
            var elapsed = 0;

            var checkerInterval = setInterval(function() {
                elapsed += 250;
                var player = document.querySelector("video");

                if (player && player.readyState >= 2) {
                    started = true;
                    clearInterval(checkerInterval);
                    document.body.style.backgroundColor = "black";
                    window.cinema_controller = player;

                    var playPromise = player.play();
                    if (playPromise && typeof playPromise.catch === "function") {
                        playPromise.catch(function(err) {
                            console.warn("[Cinema][Bilibili] Live autoplay was rejected:", err);
                        });
                    }

                    exTheater.controllerReady();
                    return;
                }

                if (elapsed >= 30000) {
                    clearInterval(checkerInterval);
                    if (window.exTheater && typeof exTheater.controllerError === "function") {
                        exTheater.controllerError("Bilibili live player timed out");
                    }
                }
            }, 250);
        })();
    ]]

    local EPISODE_JS = [[
        (function() {
            (function() {
                var started = false;
                var elapsed = 0;

                var checkerInterval = setInterval(function() {
                    elapsed += 250;
                    var player = document.querySelector("video");

                    if (player && player.readyState >= 2) {
                        started = true;
                        clearInterval(checkerInterval);

                        document.body.style.backgroundColor = "black";
                        window.cinema_controller = player;

                        var fullscreen = document.querySelector(
                            ".squirtle-video-pagefullscreen.squirtle-video-item"
                        );
                        if (fullscreen) fullscreen.click();

                        var playPromise = player.play();
                        if (playPromise && typeof playPromise.catch === "function") {
                            playPromise.catch(function(err) {
                                console.warn("[Cinema][Bilibili] Episode autoplay was rejected:", err);
                            });
                        }

                        exTheater.controllerReady();
                        return;
                    }

                    if (elapsed >= 30000) {
                        clearInterval(checkerInterval);
                        if (window.exTheater && typeof exTheater.controllerError === "function") {
                            exTheater.controllerError("Bilibili episode player timed out");
                        }
                    }
                }, 250);
            })();
        })();
    ]]

    local STATE_SCRIPTS = {
        live = LIVE_JS,
        episode = EPISODE_JS,
        bv = VIDEO_JS,
        av = VIDEO_JS
    }

    function BASE:LoadProvider(vi, panel)
        local state, value, page = ROUTER.Resolve(vi:Data())
        if not state then return end

        local url = state.player:format(value, page)
        local js = STATE_SCRIPTS[state.route]
        if not js then return end

        panel:OpenURL(url)
        panel.OnDocumentReady = function(pnl)
            self:LoadExFunctions(pnl)
            pnl:QueueJavascript(js)
        end
    end
end

local INFO_HANDLERS

local INFO_HANDLERS = {
    live = function(state, value, page, onSuccess, onFailure)
        http.Fetch(state.api:format(value), function(body, status)
            if status == 0 then return onFailure("Theater_RequestFailed") end
            local response = util.JSONToTable(body)
            local info = response and response.data
            if not info then return onFailure("Theater_RequestFailed") end
            if info.live_status == 0 then return onFailure("Service_StreamOffline") end
            onSuccess({ thumbnail = info.user_cover, title = info.title })
        end, function() onFailure("Theater_RequestFailed") end)
    end,

    episode = function(state, value, page, onSuccess, onFailure)
        http.Fetch(state.api:format(value), function(body, status)
            if status == 0 then return onFailure("Theater_RequestFailed") end
            local response = util.JSONToTable(body)
            local result = response and response.result
            if not result or not result.episodes then return onFailure("Theater_RequestFailed") end
            for _, episode in pairs(result.episodes) do
                if tostring(episode.id) == tostring(value) then
                    return onSuccess({
                        title = episode.share_copy or episode.long_title or tostring(value),
                        duration = (tonumber(episode.duration) or 0) / 1000 + 1
                    })
                end
            end
            onFailure("Theater_RequestFailed")
        end, function() onFailure("Theater_RequestFailed") end)
    end,

    bv = function(state, value, page, onSuccess, onFailure)
        http.Fetch(state.api:format(value), function(body, status)
            if status == 0 then return onFailure("Theater_RequestFailed") end
            local response = util.JSONToTable(body)
            local info = response and response.data
            if not info or not info.pages then return onFailure("Theater_RequestFailed") end
            local pageInfo = info.pages[page] or info.pages[1]
            if not pageInfo then return onFailure("Theater_RequestFailed") end
            onSuccess({
                thumbnail = info.pic,
                title = string.format("%s (%dp)", info.title or value, page),
                duration = (tonumber(pageInfo.duration) or 0) + 1
            })
        end, function() onFailure("Theater_RequestFailed") end)
    end,

    av = function(state, value, page, onSuccess, onFailure)
        return INFO_HANDLERS.bv(state, value, page, onSuccess, onFailure)
    end
}

local function GetVideoInfo(data, onSuccess, onFailure)
    local state, value, page = ROUTER.Resolve(data)
    if not state then return onFailure("Theater_RequestFailed") end

    local handler = INFO_HANDLERS[state.route]
    if not handler then return onFailure("Theater_RequestFailed") end

    return handler(state, value, page, onSuccess, onFailure)
end

local URL_INFO_HANDLERS = {
    bv = function(value, page) return { Data = VideoData("bv", value, page) } end,
    av = function(value, page) return { Data = VideoData("av", value, page) } end,
    live = function(value) return { Data = "live|" .. value } end,
    episode = function(value) return { Data = "episode|" .. value } end
}

local STATE_NAMES = {
    bilibili = "哔哩哔哩",
    bilibili_legacy = "哔哩哔哩Legacy",
    bilibili_live = "哔哩哔哩直播",
    bilibiliep = "哔哩哔哩番剧"
}

local function RegisterState(name, state)
    local service = setmetatable({
        Name = STATE_NAMES[name] or "哔哩哔哩",
        IsTimed = state.timed,
        NeedsCodecFix = true,
        ClassName = name
    }, { __index = BASE })

    function service:Match(url)
        local detected = ROUTER.Match(url)
        return detected == state.route
    end

    function service:GetURLInfo(url)
        local detected, value, page = ROUTER.Match(url)
        if detected ~= state.route then return false end

        local handler = URL_INFO_HANDLERS[detected]
        return handler and handler(value, page) or false
    end

    function service:GetVideoInfo(data, onSuccess, onFailure)
        return GetVideoInfo(data, onSuccess, onFailure)
    end

    theater.RegisterService(name, service)
end

RegisterState("bilibili", STATES.bv)
RegisterState("bilibili_legacy", STATES.av)
RegisterState("bilibili_live", STATES.live)
RegisterState("bilibiliep", STATES.episode)
