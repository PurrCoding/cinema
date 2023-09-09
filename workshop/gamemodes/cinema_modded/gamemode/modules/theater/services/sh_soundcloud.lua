local SERVICE = {}

SERVICE.Name = "Soundcloud"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_PARTIAL

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

	function SERVICE:LoadProvider( Video, panel )

		local path = string.Explode(",", Video:Data())
		local url = GetGlobal2String( "cinema_url", "" ) .. "soundcloud.html?url=https://soundcloud.com/%s/%s"

		panel:OpenURL(url:format( path[1], path[2] ))
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
		info.thumbnail = ( response.artwork_url and response.artwork_url:Replace("-large.jpg", "-original.jpg") ) or ""
		info.duration = math.ceil(response.duration / 1000)

		if onSuccess then
			pcall(onSuccess, info)
		end

	end
	self:Fetch( API_URL:format(escapedUrl, SRV_API_KEY), onReceive, onFailure )

end

theater.RegisterService( "soundcloud", SERVICE )