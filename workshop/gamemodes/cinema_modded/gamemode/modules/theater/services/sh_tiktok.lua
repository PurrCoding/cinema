local SERVICE = {}
SERVICE.Name = "Tiktok"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

function SERVICE:Match(url)
    return url.host and url.host:match("www.tiktok.com")
end

local EMBED_URL = "https://www.tiktok.com/player/v1/%s?controls=0&autoplay=1&fullscreen_button=0&play_button=0&volume_control=0&timestamp=0&loop=0&description=0&music_info=0&rel=0"
local API_URL = "https://www.tiktok.com/oembed?url=%s"

if CLIENT then
    local THEATER_JS = [[ 
          
        setInterval(function() { 
            document.querySelector('video').setAttribute('controls', '');
            document.querySelector('video').muted = false;
            window.cinema_controller = document.querySelector('video');
            exTheater.controllerReady();
        }, 100);

    ]]
    function SERVICE:LoadProvider(Video, panel)
        panel:OpenURL(EMBED_URL:format(Video:Data():match("/@[%a%w%d%_%.]+/video/(%d+)$")))
        panel.OnDocumentReady = function(pnl)
            SERVICE:LoadExFunctions(pnl, THEATER_INTERFACE)
            pnl:QueueJavascript(THEATER_JS)
        end
    end

    function SERVICE:GetMetadata(data, callback)
        local panel = vgui.Create("DHTML")
        panel:SetMouseInputEnabled(false)
        panel.OnDocumentReady = function(pnl)
            local METADATA_JS = [[
                const convertToSeconds = time => {
                    const [minutes, seconds] = time.split(':').map(Number);
                    return (minutes * 60) + seconds;
                };
                
                // Check and return the value when conditions are met
                const checkSeekBarTime = () => {
                    const seekBarTimeDiv = Array.from(document.querySelectorAll('div'))
                        .find(div => /DivSeekBarTimeContainer/.test(div.className));
                
                    if (seekBarTimeDiv) {
                        const [ , endTime ] = seekBarTimeDiv.textContent.split('/').map(s => s.trim());
                        const totalSeconds = convertToSeconds(endTime);
                
                        if (totalSeconds > 1) {
                            console.log("CINEMA: " + totalSeconds);
                        }
                    }
                };
                var timeout = 50;
                var i = 0;
                setInterval(function() { 
                    if ( i >= timeout ) { console.log( "CINEMA: Terminate" ); }
                    document.querySelector('video').setAttribute('controls', '');
                    document.querySelector('video').muted = true;
                    checkSeekBarTime();
                    i = i + 1;
                }, 100);
            ]]
            pnl:QueueJavascript(METADATA_JS)
        end

        function panel:ConsoleMessage(msg)
            if not string.StartsWith(msg, "CINEMA: ") then
                print(msg)
                return
            end

            local seconds = string.sub(msg, 9, string.len(msg))
            callback({
                dur = seconds
            })

            panel:Remove()
        end

        panel:OpenURL(data)
    end
end

function SERVICE:GetURLInfo(url)

    if url.path then
        local data = url.path:match("/@[%a%w%d%_%.]+/video/(%d+)$")
        if data and data ~= nil then
            return {
                Data = url.host .. url.path
            }
        end
    end

    return false
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)

    theater.FetchVideoMedata(data:GetOwner(), data, function(metadata)
        if not isnumber(tonumber(metadata.dur)) or tonumber(metadata.dur) < 1 then
            pcall(onFailure, "Duration Not Found")
            return
        end

        http.Fetch(API_URL:format("https://" .. data:Data()), function(body)

            local json = util.JSONToTable(body)
            if json then
                local info = {
                    title = "coming soon",
                    thumbnail = "about:blank",
                }

                info.title = string.sub(json.title, 1, 42)
                info.thumbnail = json.thumbnail_url
                info.duration = tonumber(metadata.dur) + 2

                if onSuccess then
                    pcall(onSuccess, info)
                end
            end
        end)
    end)
end

theater.RegisterService("tiktok", SERVICE)