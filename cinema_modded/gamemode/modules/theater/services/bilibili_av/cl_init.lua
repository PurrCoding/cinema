--[[
	Bilibili Support Legacy by OriginalSnow
	Note: You can edit this code. But you cant upload anymore.
]]

local SERVICE = {
	Name = "哔哩哔哩Legacy",
	IsTimed = true,

	NeedsCodecFix = true,

	PlayerURL = "https://www.bilibili.com/blackboard/html5mobileplayer.html?aid=%s&autoplay=1&p=%s",
}

function SERVICE:Match(url)
	local host = url.host or ""
	local path = url.path or ""
	local av = host:match("www.bilibili.com") and string.match(path, "av[%w*]+")
	return av or false
end

if CLIENT then

	local JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("video")[0];
			if (player && player.paused === false && player.readyState === 4) {
				clearInterval(checkerInterval);

				document.body.style.backgroundColor = "black";
				window.cinema_controller = player;

				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider(vi, p)
		local videoID = vi:Data()
		local vid = string.Split(videoID, " ")
		local aid = string.Split(vid[1], "av")
		p:OpenURL(SERVICE.PlayerURL:format(aid[2], vid[2]))
		p.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(JS)
		end
	end

end

function SERVICE:GetURLInfo(url)
	local info = {}
	local p = (url.query and url.query["p"]) or 1

	local host = url.host or ""
	local path = url.path or ""
	if host:match("www.bilibili.com") or host:match("b23.tv") then
		local av = string.match(path, "av[%w*]+")
		if av then
			info.Data = av .. " " .. p
		end
	end

	return info.Data and info or false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("bilibili_legacy", SERVICE)
