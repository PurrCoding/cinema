--[[
	Bilibili Bangumi Support by OriginalSnow
	Note: You can edit this code. But you cant upload anymore.
]]

local SERVICE = {
	Name = "哔哩哔哩番剧",
	IsTimed = true,

	NeedsCodecFix = true
}

local META_URL = "https://www.bilibili.com/bangumi/play/ep%s"

function SERVICE:Match(url)
	return url.host:match("www.bilibili.com") and string.find(url.path, "/bangumi/play/ep[%w*].") or false
end

if CLIENT then
	local PLAYURL = "https://www.bilibili.com/bangumi/play/ep%s"
	local JS = [[
		var checkerVideoInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0];
			if (player&&player.paused != false) {
				document.getElementsByClassName('squirtle-video-pagefullscreen squirtle-video-item')[0].click();
				clearInterval(checkerVideoInterval);
				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]
	local fullscreenRequest = [[
		var checkerFullScreenInterval = setInterval(function(){
			var IsFullScreen = document.getElementById("bilibili-player-wrap").classList[0].indexOf("video_playerFullScreen")>-1
			if(!IsFullScreen){
				document.getElementsByClassName('squirtle-video-pagefullscreen squirtle-video-item')[0].click();
			}
		}, 50)    
	]]
	function SERVICE:LoadProvider(vi, p)
		p:OpenURL(PLAYURL:format(vi:Data()))
		p.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(JS)
			timer.Simple(5, function() pnl:QueueJavascript(fullscreenRequest) end)
		end
	end
end

function SERVICE:GetURLInfo(url)
	local info = {}
	if url.host:match("www.bilibili.com") then
		local s = string.match(url.path, "ep[%w*]+")
		s1 = string.Split(s, "ep")
		info.Data = s1[2]
	end
	return info.Data and info or false
end

function SERVICE:GetVideoInfo(d, onSuccess, onFailure)
	local f = Format("https://api.bilibili.com/pgc/view/web/season?ep_id=%s", d)
	local c = Format("https://api.bilibili.com/pgc/player/web/playurl/html5?ep_id=%s", d)
	local onReceive = function(b, l, h, c)
		http.Fetch(c, function(r, s)
			if s == 0 then return onFailure("Theater_RequestFailed") end
			local rT = util.JSONToTable(r)
			local data = rT.result
			if rT.message == "success" and data ~= nil then
			else
				return onFailure("Theater_RequestFailed")
			end
		end)

		http.Fetch(f, function(r, s)
			if s == 0 then return onFailure("Theater_RequestFailed") end
			local rT = util.JSONToTable(r)
			local data = rT.result
			if data == nil then return onFailure("Theater_RequestFailed") end
			local info = {}
			for k, v in pairs(data.episodes) do
				if tostring(v.id) == d then
					info.title = data.episodes[k].share_copy
					info.duration = v.duration / 1000 + 1
				end
			end

			if onSuccess then pcall(onSuccess, info) end
		end)
	end

	local url = META_URL:format(d)
	self:Fetch(url, onReceive, onFailure)
end

theater.RegisterService("bilibiliep", SERVICE)