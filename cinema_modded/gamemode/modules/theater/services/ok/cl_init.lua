local SERVICE = {
	Name = "OK",
	IsTimed = true,

	NeedsCodecFix = true,

	EmbedURL = "https://ok.ru/videoembed/%s?autoplay=1",
}

local ValidTypes = {
	["video"] = true,
	["live"] = true,
}

function SERVICE:Match(url)
	return url.host and url.host:match("ok.ru")
end

if CLIENT then

	local THEATER_JS = [[
		(function() {
			function findVideo(root) {
				if (!root) return null;

				var vid = root.querySelector && root.querySelector("video");
				if (vid) return vid;

				var rootContainer = root.querySelector && root.querySelector(".shadow-root-container");
				if (rootContainer && rootContainer.shadowRoot) {
					var v = findVideo(rootContainer.shadowRoot);
					if (v) return v;
				}

				var all = root.querySelectorAll ? root.querySelectorAll("*") : [];
				for (var i = 0; i < all.length; i++) {
					var el = all[i];
					if (el.shadowRoot) {
						var nested = findVideo(el.shadowRoot);
						if (nested) return nested;
					}
				}

				return null;
			}

			var checkerInterval = setInterval(function() {
				var player = findVideo(document);
				if (player && !player.paused && player.readyState === 4) {
					clearInterval(checkerInterval);
					window.cinema_controller = player;
					exTheater.controllerReady();
				}
			}, 100);
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		local data = string.Explode(",", Video:Data())
		local typeID, videoID = data[1], data[2]

		panel:OpenURL(SERVICE.EmbedURL:format(videoID))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

end

function SERVICE:GetURLInfo(url)
	if url.path then
		local typeID, videoID = url.path:match("^/([%w%-_]+)/(%d+)")
		if typeID and videoID and ValidTypes[typeID] then
			return { Data = typeID .. "," .. videoID }
		end
	end

	return false
end

if SERVER then
	return SERVICE
end

theater.RegisterService("ok", SERVICE)

theater.RegisterService("oklive", {
	Name = "Ok Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
