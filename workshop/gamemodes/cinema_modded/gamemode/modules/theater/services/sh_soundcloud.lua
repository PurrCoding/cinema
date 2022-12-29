--[[
    This "Soundcloud" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}
SERVICE.Name = "Soundcloud"
SERVICE.IsTimed = true
SERVICE.Dependency = DEPENDENCY_PARTIAL

--[[
	Uncomment this line below to restrict Audiostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local API_URL = "https://api-widget.soundcloud.com/resolve?url=%s&format=json&client_id=%s"
local SRV_API_KEY = "LBCcHmRB8XSStWL6wKH2HPACspQlXg2P"

local Ignored = {
	["sets"] = true,
}

local accessLevel = {
	["all"] = true, -- It can be embedded anywhere.
	["me"] = false, -- It can be embedded only on a specific page.
	["none"] = false, -- It cannot be embedded anywhere.
}

function SERVICE:Match( url )
	return url.host and url.host:match("soundcloud.com")
end

if (CLIENT) then
	local PLAYER_URL = "https://gmod-cinema.pages.dev/cinema/soundcloud.html?url=https://soundcloud.com/%s/%s"

	function SERVICE:LoadProvider( Video, panel )

		local path = string.Explode(",", Video:Data())

		panel:OpenURL(PLAYER_URL:format( path[1], path[2] ))
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local user, title = url.path:match("^/([%w%-_]+)/([%w%-_]+)")
		if (user and title and not Ignored[title]) then return { Data = user .. "," .. title } end
	end

	return false

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local path = string.Explode(",", data)
	local escapedUrl = url.escape( ("https://soundcloud.com/%s/%s"):format(path[1], path[2]) )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable( body )
		if not response then return onFailure("The API servers did not return the requested data.") end

		if (response.embeddable_by and not accessLevel[response.embeddable_by]) then
			return onFailure("The requested song is not playable, as there is a restriction set by SoundCloud")
		end

		local info = {}
		info.title = response.title
		info.thumbnail = ( response.artwork_url and response.artwork_url:Replace("-large.jpg", "-original.jpg") ) or self.PlaceholderThumb
		info.duration = math.ceil(response.duration / 1000)

		if onSuccess then
			pcall(onSuccess, info)
		end

	end
	self:Fetch( API_URL:format(escapedUrl, SRV_API_KEY), onReceive, onFailure )

end

theater.RegisterService( "soundcloud", SERVICE )