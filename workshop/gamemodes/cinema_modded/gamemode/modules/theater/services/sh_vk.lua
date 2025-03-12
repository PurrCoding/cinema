local SERVICE = {
	Name = "VKontakte",
	IsTimed = true,

	Dependency = DEPENDENCY_COMPLETE,
	ExtentedVideoInfo = true
}

function SERVICE:Match( url )
	return url.host and url.host:match("vk.com")
end

if (CLIENT) then
	local EMBED_URL = "https://vk.com/video_ext.php?oid=-%s&id=%s&autoplay=1"

	local JS_BASE = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName('video')[0]
			if (typeof (player) != 'undefined') {
				{@JS_Content}
			}
		}, 50);
	]]

	local THEATER_JS = JS_BASE:Replace("{@JS_Content}", [[
		var player = document.getElementsByTagName('video')[0];
		if (!!player) {

			if (player.paused) { player.play(); }
			if (!player.paused && player.readyState === 4) {
				if (player.muted) {player.muted = false}

				clearInterval(checkerInterval);

				window.cinema_controller = player;
				exTheater.controllerReady();

				document.body.style.backgroundColor = "black";

				player.addEventListener("seeking", function () {
					if (!player.paused) { player.pause() }

					this.addEventListener("progress", function progessCheck() {
						if (player.paused && player.readyState === 4) {
							this.removeEventListener("progress", progessCheck);
							player.play();
						}
					});
				});
			}
		}
	]])

	local METADATA_JS = JS_BASE:Replace("{@JS_Content}", [[
		player.muted = true;
		clearInterval(checkerInterval);
		if (window.metaevent_set) {return;}

		var title = document.getElementsByClassName("videoplayer_title_link _clickable")[0].innerText

		player.addEventListener('loadedmetadata', (event) => {
			window.metaevent_set = true;

			var thumb = document.getElementsByClassName("videoplayer_thumb")[0].style.backgroundImage.slice(4, -1).replace(/["']/g, "")

			var metadata = {
				title: title,
				thumbnail: thumb,
				duration: player.duration,
			};

			console.log("METADATA:" + JSON.stringify(metadata));

		});
		player.addEventListener('error', (event) => {
			console.log("ERROR:" + player.error.code )
		});
	]])

	local function extractData(data)
		local oid, id = data:match("video%-(%d+)_(%d+)")
		return oid, id
	end

	function SERVICE:LoadProvider( Video, panel )

		local startTime = math.Round(CurTime() - Video:StartTime())
		if startTime > 0 then
			startTime = util.SecondsToISO_8601(startTime)
		else startTime = 0 end

		local url = EMBED_URL:format(extractData(Video:Data())) ..
			(self.IsTimed and "&t=" .. startTime or "")

		panel:OpenURL(url)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end

	function SERVICE:GetMetadata( data, callback )

		local panel = vgui.Create("DHTML")
		panel:SetSize(512,512)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		panel.OnDocumentReady = function(pnl)
			pnl:QueueJavascript(METADATA_JS)
		end

		function panel:ConsoleMessage(msg)
			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				callback(metadata)
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local code = tonumber(string.sub(msg, 7))

				callback({ err = util.MEDIA_ERR[code] or util.MEDIA_ERR[5] })
				panel:Remove()
			end
		end
		panel:OpenURL(EMBED_URL:format(extractData(data)))
	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://vk.com/video-xxxxxxxxx_xxxxxxxxx
	local videoID = url.path:match("[video%-(%d+)_(%d+)]+")
	if (videoID and videoID ~= "video") then
		info.Data = videoID
	end

	if (url.query) then

		-- https://vk.com/video?z=video-xxxxxxxxx_xxxxxxxxx
		if url.query.z then
			local data = url.query.z:match("[video%-(%d+)_(%d+)]+")
			if data then info.Data = data end
		end

		if url.query.t and url.query.t ~= "" then
			local time = util.ISO_8601ToSeconds(url.query.t)
			if time and time ~= 0 then
				info.StartTime = time
			end
		end

	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = metadata.thumbnail

		local duration = metadata.duration
		if not duration or (isnumber(duration) and duration == 0) then
			info.type = "vklive"
			info.duration = 0
		else
			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "vk", SERVICE )
theater.RegisterService( "vklive", {
	Name = "VKontakte Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )