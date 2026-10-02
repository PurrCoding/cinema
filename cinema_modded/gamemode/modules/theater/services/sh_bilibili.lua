--[[
    Unified Bilibili service for Cinema.

    Supports:
    - Regular BV videos
    - Legacy AV videos
    - Bilibili live rooms
    - Bangumi / episode URLs

    All Bilibili URL handling lives here so the player, metadata and
    URL parsing stay consistent across the different Bilibili formats.
]]

local SERVICE = {
    Name = "哔哩哔哩",
    IsTimed = true,
    NeedsCodecFix = true
}

local VIDEO_META_URL = "https://www.bilibili.com/video/%s"
local LIVE_META_URL = "https://live.bilibili.com/%s"
local EP_META_URL = "https://www.bilibili.com/bangumi/play/ep%s"

local function GetHost(url)
    return string.lower(url.host or "")
end

local function GetPath(url)
    return url.path or ""
end

local function GetPage(url)
    return tonumber(url.query and url.query.p) or 1
end

local function IsVideoHost(host)
    return host:match("www%.bilibili%.com") or host:match("b23%.tv")
end

function SERVICE:Match(url)
    local host = GetHost(url)
    local path = GetPath(url)

    if host:match("live%.bilibili%.com") and path:match("^/[%w_%-]+") then
        return "live"
    end

    if host:match("www%.bilibili%.com") and path:match("/bangumi/play/ep[%w_%-]+") then
        return "episode"
    end

    if IsVideoHost(host) and (
        path:match("BV[%w_%-]+") or
        path:match("av[%w_%-]+")
    ) then
        return "video"
    end

    return false
end

if CLIENT then
    local PLAYERS = {
        bv = "https://player.bilibili.com/player.html?bvid=%s&p=%s&autoplay=1",
        av = "https://player.bilibili.com/player.html?aid=%s&p=%s&autoplay=1",
        live = "https://www.bilibili.com/blackboard/live/live-mobile-playerV3.html?roomId=%s&danmaku=1&autoplay=1",
        episode = "https://www.bilibili.com/bangumi/play/ep%s"
    }

    local VIDEO_JS = [[
        (function() {
            var started = false;
            var failed = false;
            var elapsed = 0;

            var fail = function(message) {
                if (failed || started) return;
                failed = true;
                clearInterval(checkerInterval);
                console.error("[Cinema][Bilibili] " + message);
                if (window.exTheater && typeof exTheater.controllerError === "function") {
                    exTheater.controllerError(message);
                }
            };

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

                if (blocked) {
                    fail("Bilibili playback blocked by Bilibili");
                    return;
                }

                var player = document.querySelector("video");

                if (!player) {
                    if (elapsed >= 30000) {
                        fail("Bilibili player did not create a video element");
                    }
                    return;
                }

                if (player.error) {
                    fail("Bilibili HTML5 video error");
                    return;
                }

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

                if (elapsed >= 30000) {
                    fail("Bilibili player timed out");
                }
            }, 250);
        })();
    ]]

    local LIVE_JS = [[
        (function() {
            var started = false;
            var failed = false;
            var elapsed = 0;

            var checkerInterval = setInterval(function() {
                if (started || failed) return;

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
                    failed = true;
                    clearInterval(checkerInterval);
                    console.error("[Cinema][Bilibili] Live player timed out.");
                    if (window.exTheater && typeof exTheater.controllerError === "function") {
                        exTheater.controllerError("Bilibili live player timed out");
                    }
                }
            }, 250);
        })();
    ]]

    local EPISODE_JS = [[
        (function() {
            var started = false;
            var failed = false;
            var elapsed = 0;

            var checkerInterval = setInterval(function() {
                if (started || failed) return;

                elapsed += 250;

                var player = document.querySelector("video");
                if (player) {
                    if (player.readyState >= 2) {
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

                    if (player.error) {
                        failed = true;
                        clearInterval(checkerInterval);
                        if (window.exTheater && typeof exTheater.controllerError === "function") {
                            exTheater.controllerError("Bilibili episode HTML5 video error");
                        }
                        return;
                    }
                }

                if (elapsed >= 30000) {
                    failed = true;
                    clearInterval(checkerInterval);
                    if (window.exTheater && typeof exTheater.controllerError === "function") {
                        exTheater.controllerError("Bilibili episode player timed out");
                    }
                }
            }, 250);
        })();
    ]]

    function SERVICE:LoadProvider(vi, panel)
        local data = vi:Data()
        local kind, value, page = string.match(data, "^(%w+)|([^|]+)|?(%d*)$")

        -- Lua patterns don't support optional groups, so parse the payload explicitly.
        local parts = string.Explode("|", data)
        kind = parts[1]
        value = parts[2]
        page = tonumber(parts[3]) or 1

        local url
        local js

        if kind == "bv" then
            url = PLAYERS.bv:format(value, page)
            js = VIDEO_JS
        elseif kind == "av" then
            url = PLAYERS.av:format(value, page)
            js = VIDEO_JS
        elseif kind == "live" then
            url = PLAYERS.live:format(value)
            js = LIVE_JS
        elseif kind == "ep" then
            url = PLAYERS.episode:format(value)
            js = EPISODE_JS
        else
            return
        end

        panel:OpenURL(url)
        panel.OnDocumentReady = function(pnl)
            self:LoadExFunctions(pnl)
            pnl:QueueJavascript(js)
        end
    end
end

function SERVICE:GetURLInfo(url)
    local host = GetHost(url)
    local path = GetPath(url)

    if host:match("live%.bilibili%.com") then
        local room = path:match("^/([%w_%-]+)")
        return room and { Data = "live|" .. room } or false
    end

    if host:match("www%.bilibili%.com") then
        local episode = path:match("/bangumi/play/ep([%w_%-]+)")
        if episode then
            return { Data = "ep|" .. episode } 
        end
    end

    if IsVideoHost(host) then
        local bv = path:match("(BV[%w_%-]+)")
        if bv then
            return { Data = "bv|" .. bv .. "|" .. GetPage(url) }
        end

        local av = path:match("(av[%w_%-]+)")
        if av then
            return { Data = "av|" .. av:sub(3) .. "|" .. GetPage(url) }
        end
    end

    return false
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
    local parts = string.Explode("|", data or "")
    local kind = parts[1]
    local value = parts[2]
    local page = tonumber(parts[3]) or 1

    if not kind or not value then
        return onFailure("Theater_RequestFailed")
    end

    if kind == "live" then
        local api = Format("https://api.live.bilibili.com/room/v1/Room/get_info?room_id=%s", value)

        http.Fetch(api, function(body, status)
            if status == 0 then return onFailure("Theater_RequestFailed") end

            local response = util.JSONToTable(body)
            local info = response and response.data
            if not info then return onFailure("Theater_RequestFailed") end
            if info.live_status == 0 then return onFailure("Service_StreamOffline") end

            onSuccess({
                thumbnail = info.user_cover,
                title = info.title
            })
        end, function()
            onFailure("Theater_RequestFailed")
        end)

        return
    end

    if kind == "ep" then
        local api = Format("https://api.bilibili.com/pgc/view/web/season?ep_id=%s", value)

        http.Fetch(api, function(body, status)
            if status == 0 then return onFailure("Theater_RequestFailed") end

            local response = util.JSONToTable(body)
            local result = response and response.result
            if not result or not result.episodes then
                return onFailure("Theater_RequestFailed")
            end

            for _, episode in pairs(result.episodes) do
                if tostring(episode.id) == tostring(value) then
                    return onSuccess({
                        title = episode.share_copy or episode.long_title or tostring(value),
                        duration = (tonumber(episode.duration) or 0) / 1000 + 1
                    })
                end
            end

            onFailure("Theater_RequestFailed")
        end, function()
            onFailure("Theater_RequestFailed")
        end)

        return
    end

    local api
    if kind == "bv" then
        api = Format("https://api.bilibili.com/x/web-interface/view?bvid=%s", value)
    elseif kind == "av" then
        api = Format("https://api.bilibili.com/x/web-interface/view?aid=%s", value)
    else
        return onFailure("Theater_RequestFailed")
    end

    http.Fetch(api, function(body, status)
        if status == 0 then return onFailure("Theater_RequestFailed") end

        local response = util.JSONToTable(body)
        local info = response and response.data
        if not info or not info.pages then
            return onFailure("Theater_RequestFailed")
        end

        local pageInfo = info.pages[page] or info.pages[1]
        if not pageInfo then
            return onFailure("Theater_RequestFailed")
        end

        onSuccess({
            thumbnail = info.pic,
            title = string.format("%s (%dp)", info.title or value, page),
            duration = (tonumber(pageInfo.duration) or 0) + 1
        })
    end, function()
        onFailure("Theater_RequestFailed")
    end)
end

theater.RegisterService("bilibili", SERVICE)
