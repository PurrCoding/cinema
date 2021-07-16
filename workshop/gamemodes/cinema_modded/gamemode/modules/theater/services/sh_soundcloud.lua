--[[
    ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗  ██████╗██╗      ██████╗ ██╗   ██╗██████╗
    ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗
    ███████╗██║   ██║██║   ██║██╔██╗ ██║██║  ██║██║     ██║     ██║   ██║██║   ██║██║  ██║
    ╚════██║██║   ██║██║   ██║██║╚██╗██║██║  ██║██║     ██║     ██║   ██║██║   ██║██║  ██║
    ███████║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝
    ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝  ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝

                ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗
                ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝
                ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗
                ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝
                ███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗
                ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝

    This Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://steamcommunity.com/id/FarukGamer )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}
SERVICE.Name 	= "Soundcloud"
SERVICE.IsTimed = true

local client_id = "2e0e541854cbabd873d647c1d45f79e8" -- Nothing special, its from GM Media Player.
local API_URL = "https://api.soundcloud.com/resolve.json?url=https://soundcloud.com/%s/%s&client_id=%s"

function SERVICE:Match( url )
	return url.host and url.host:match("soundcloud.com")
end

if (CLIENT) then
	local PLAYER_URL = "https://workers.knab-networks.com/cinema/services/soundcloud/"

	function SERVICE:LoadProvider( Video, panel )

		local path = string.Explode(",", Video:Data())

		panel:OpenURL(PLAYER_URL)
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )

			local str = string.format("loadSoundCloudAPI('%s/%s')", path[1], path[2])
			pnl:QueueJavascript(str)
		end

	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local user, title = url.path:match("^/([%w%-_]+)/([%w%-_]+)")
		if (user and title) then return { Data = user .. "," .. title } end
	end

	return false

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local path = string.Explode(",", data)

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable( body )
		if not response then return onFailure("No response from the API") end
		if not response.title or not response.duration then return onFailure("Cannot get duration or title from song") end

		local info = {}
		info.title = response.title
		info.thumbnail = response.artwork_url or self.PlaceholderThumb
		info.duration = response.duration / 1000

		if onSuccess then
			pcall(onSuccess, info)
		end

	end
	self:Fetch( API_URL:format(path[1], path[2], client_id), onReceive, onFailure )

end

theater.RegisterService( 'soundcloud', SERVICE )