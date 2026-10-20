--[[
	Bilibili Support by OriginalSnow
	Note: You can edit this code. But you cant upload anymore.
]]

local SERVICE = {
    Name = "哔哩哔哩", -- 服务名称
    IsTimed = true, -- 是否是计时视频

    NeedsCodecFix = true
}

-- 目前支持AV号与BV号
local META_URL = "https://www.bilibili.com/video/%s"

function SERVICE:Match(url) -- 匹配B站网址
    local host = url.host or ""
    local path = url.path or ""
    local bv = host:match("www.bilibili.com") and string.match(path, "BV[%w*]+")
    local b23 = host:match("b23.tv") and string.match(path, "BV[%w*]+")
    return bv or b23 or false
end

if CLIENT then
    local PLAYURL = "https://player.bilibili.com/player.html?bvid=%s&p=%s&autoplay=1"
    local JS = [[
        (function() {
            var started = false;
            var failed = false;
            var elapsed = 0;
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
                    errorText.indexOf("版权") !== -1 && errorText.indexOf("地区") !== -1;

                if (blocked) {
                    failed = true;
                    clearInterval(checkerInterval);
                    console.error("[Cinema][Bilibili] Playback blocked by Bilibili:", bodyText);
                    if (window.exTheater && typeof exTheater.controllerError === "function") {
                        exTheater.controllerError("Bilibili playback blocked by Bilibili");
                    }
                    return;
                }

                var player = document.querySelector("video");
                if (!player) {
                    if (elapsed >= 30000) {
                        failed = true;
                        clearInterval(checkerInterval);
                        console.error("[Cinema][Bilibili] No HTML5 video element was created.");
                        if (window.exTheater && typeof exTheater.controllerError === "function") {
                            exTheater.controllerError("Bilibili player did not create a video element");
                        }
                    }
                    return;
                }

                if (player.error) {
                    failed = true;
                    clearInterval(checkerInterval);
                    console.error("[Cinema][Bilibili] HTML5 video error:", player.error.code, player.error.message || "");
                    if (window.exTheater && typeof exTheater.controllerError === "function") {
                        exTheater.controllerError("Bilibili HTML5 video error");
                    }
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
                }

                if (elapsed >= 30000) {
                    failed = true;
                    clearInterval(checkerInterval);
                    console.error("[Cinema][Bilibili] Player timed out. URL:", window.location.href);
                    if (window.exTheater && typeof exTheater.controllerError === "function") {
                        exTheater.controllerError("Bilibili player timed out");
                    }
                }
            }, 250);
        })();
    ]]
    function SERVICE:LoadProvider(vi, p)
        local vedioID = vi:Data()
        local vid = string.Split(vedioID, " ")
        local bvid = vid[1]
        local page = tonumber(vid[2]) or 1

        p:OpenURL(PLAYURL:format(bvid, page))
        p.OnDocumentReady = function(pnl)
            self:LoadExFunctions(pnl)
            pnl:QueueJavascript(JS)
        end
    end
end

function SERVICE:GetURLInfo(url)
    local info = {}
    local bp
    if url.query ~= nil then
        bp = url.query["p"] or 1
    else
        bp = 1
    end

    local host = url.host or ""
    local path = url.path or ""
    if host:match("www.bilibili.com") or host:match("b23.tv") then
        local bv = string.match(path, "BV[%w*]+")
        if bv then info.Data = bv .. " " .. bp end
    end
    return info.Data and info or false
end

function SERVICE:GetVideoInfo(d, onSuccess, onFailure)
    local sT = string.Split(d, " ")
    local f = Format("https://api.bilibili.com/x/web-interface/view?bvid=%s", sT[1])
    local onReceive = function(b, l, h, c)
        http.Fetch(f, function(r, s)
            if s == 0 then return onFailure("Theater_RequestFailed") end
            local rT = util.JSONToTable(r)
            local data = rT and rT.data
            if data == nil or not data.pages then return onFailure("Theater_RequestFailed") end
            local pdata = data.pages[tonumber(sT[2])] or data.pages[1]
            if pdata == nil then return onFailure("Theater_RequestFailed") end
            local info = {}
            info.thumbnail = data.pic
            info.title = data.title .. " (" .. sT[2] .. "p)"
            info.duration = pdata.duration + 1
            if onSuccess then pcall(onSuccess, info) end
        end)
    end

    local url = META_URL:format(sT[1])
    self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibili", SERVICE)