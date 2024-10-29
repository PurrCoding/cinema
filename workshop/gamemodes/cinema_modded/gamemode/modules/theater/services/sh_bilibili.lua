local SERVICE = {}
SERVICE.Name = "哔哩哔哩"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_COMPLETE
local META_URL = "https://www.bilibili.com/video/%s"
function SERVICE:Match(url) -- 匹配B站网址
    local bv = url.host:match("www.bilibili.com") and string.match(url.path, "BV[%w*]+")
    local b23 = url.host:match("b23.tv") and string.match(url.path, "BV[%w*]+")
    return bv or b23 or false
end

if CLIENT then
    local PLAYURL = "https://www.bilibili.com/blackboard/newplayer.html?bvid=%s&page=%s&autoplay=1&t=0.1"
    local JS = [[
        var Checked = false
        var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4 && !Checked) {
                Checked = true
				clearInterval(checkerInterval);
				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
        setInterval(function(){
            document.getElementsByClassName("bpx-player-top-wrap")[0].hidden = true 
            document.getElementsByClassName("bpx-player-control-wrap")[0].hidden = true
            document.getElementsByClassName("bpx-player-relation-button")[0].style.opacity = 0
        }, 1000)
    ]]
    function SERVICE:LoadProvider(vi, p)
        local vedioID = vi:Data()
        local vid = string.Split(vedioID, " ")
        p:OpenURL(PLAYURL:format(vid[1], vid[2]))
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
    if url.host:match("www.bilibili.com") or url.host:match("b23.tv") then
        info.Data = string.match(url.path,"BV[%w*]+").." "..bp
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
            local data = rT.data
            local pdata = data.pages[tonumber(sT[2])] or data.pages[1]
            if data == nil then return onFailure("Theater_RequestFailed") end
            local info = {}
            info.title = data.title .. " (" .. sT[2] .. "p)"
            info.duration = pdata.duration + 1
            if onSuccess then pcall(onSuccess, info) end
        end)
    end

    local url = META_URL:format(sT[1])
    self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibili", SERVICE)