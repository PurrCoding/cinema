local SERVICE = theater.GetServiceByClass( "bilibiliep" )

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
