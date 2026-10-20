local SERVICE = theater.GetServiceByClass( "bilibili_legacy" )

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
