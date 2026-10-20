local SERVICE = theater.GetServiceByClass( "bilibili" )

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
