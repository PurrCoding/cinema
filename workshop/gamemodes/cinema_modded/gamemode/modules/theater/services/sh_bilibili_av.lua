--[[
            Cinema Modded Bilibili Legacy Support
                   Powered by OriginalSnow

        You can edit this code.But you cant upload anymore.
]]

-- 用前注意：我们不推荐使用av号进行解析，因为会导致加载滞后
-- Last update : 2023/2/5

local SERVICE = {}
SERVICE.Name = "哔哩哔哩Legacy"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_PARTIAL
local META_URL = "https://www.bilibili.com/video/%s"
function SERVICE:Match( url )
    local av = url.host:match("www.bilibili.com") and string.match(url.path,"av[%w*]+")
    return av or b23 or false
end
if CLIENT then
    local PLAYURL = "www.bilibili.com/blackboard/html5mobileplayer.html?aid=%s&autoplay=1&p=%s"
    local JS = [[
        var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (!!player && player.paused == false && player.readyState == 4) {
				clearInterval(checkerInterval);

				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}, 50);
    ]]
    function SERVICE:LoadProvider( vi, p )
        local vedioID = vi:Data()
        local vid = string.Split(vedioID," ")
        local aid = string.Split(vid[1],"av")
        p:OpenURL( PLAYURL:format(aid[2],vid[2]) )
        p.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(JS)
		end
    end
end
function SERVICE:GetURLInfo( url )
    local info = {}
    local p
    if url.query ~= nil then p = url.query["p"] or 1 else p = 1 end
    if url.host:match("www.bilibili.com") or url.host:match("b23.tv") then info.Data = string.match(url.path,"av[%w*]+").." "..p end
	return info.Data and info or false
end
function SERVICE:GetVideoInfo( d , onSuccess, onFailure )
    local sT = string.Split(d," ")
    local aid = string.Split(sT[1],"av")
    local f = Format("https://api.bilibili.com/x/web-interface/view?aid=%s", aid[2])
    local onReceive = function(b,l,h,c)
        http.Fetch(f, function(r,s)
            if s == 0 then return onFailure( "Theater_RequestFailed" ) end
            local rT = util.JSONToTable(r)
            local data = rT.data
            local pdata = data.pages[self.p] or data.pages[1]
            if data == nil then return onFailure( "Theater_RequestFailed" ) end
            local info = {}
            info.title = data.title.." ("..sT[2].."p)"
            info.duration = pdata.duration + 1
            if onSuccess then pcall(onSuccess, info) end
        end)
    end
    local url = META_URL:format( aid[2] )
    self:Fetch( url, onReceive, onFailure )
end
theater.RegisterService( "bilibili_legacy", SERVICE )