local SERVICE = {}
SERVICE.Name = "哔哩哔哩Legacy"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_COMPLETE
local META_URL = "https://www.bilibili.com/video/%s"
function SERVICE:Match(url)
    local av = url.host:match("www.bilibili.com") and string.match(url.path, "av[%w*]+")
    return av or b23 or false
end
if CLIENT then
    local PLAYURL = "https://player.bilibili.com/blackboard/newplayer.html?aid=%s&page=%s&autoplay=1&t=0.1"
    local JS = [[
        var Checked = false
        var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4 && !Checked) {
                Checked = true
				clearInterval(checkerInterval);
                document.getElementsByClassName("bilibili-player-iconfont bilibili-player-iconfont-subtitle")[0].click();
                document.getElementsByClassName('bilibili-player-video-btn bilibili-player-video-web-fullscreen')[0].click();
				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;
                if(document.getElementsByClassName("bilibili-player-iconfont-volume-min")[0] && document.getElementsByTagName("video")[0].muted){
                    document.getElementsByClassName("bilibili-player-iconfont-volume-min")[0].click()
                }
				exTheater.controllerReady();
			}
		}, 50);
    ]]
    function SERVICE:LoadProvider(vi, p)
        local vedioID = vi:Data()
        local vid = string.Split(vedioID, " ")
        local aid = string.Split(vid[1], "av")
        p:OpenURL(PLAYURL:format(aid[2], vid[2]))
        p.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(JS)
		end
    end
end

function SERVICE:GetURLInfo(url)
    local info = {}
    local p
    if url.query ~= nil then
        p = url.query["p"] or 1
    else
        p = 1
    end
    if url.host:match("www.bilibili.com") or url.host:match("b23.tv") then info.Data = string.match(url.path,"av[%w*]+") .. " " .. p end
	return info.Data and info or false
end

function SERVICE:GetVideoInfo(d, onSuccess, onFailure)
    local sT = string.Split(d, " ")
    local aid = string.Split(sT[1], "av")
    local f = Format("https://api.bilibili.com/x/web-interface/view?aid=%s", aid[2])
    local onReceive = function(b, l, h, c)
        http.Fetch(f, function(r, s)
            if s == 0 then return onFailure("Theater_RequestFailed") end
            local rT = util.JSONToTable(r)
            local data = rT.data
            local pdata = data.pages[tonumber(sT[2])] or data.pages[1]
            if data == nil then return onFailure("Theater_RequestFailed") end
            local info = {}
            info.title = data.title .. " (" .. sT[2] .. "p)"
            info.duration = pdata.duration + 1
            if onSuccess then pcall(onSuccess, info) end
        end)
    end

    local url = META_URL:format(aid[2])
    self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibili_legacy", SERVICE)