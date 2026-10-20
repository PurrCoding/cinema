--[[
			 Cinema Modded Bilibili Live Support
					Powered by OriginalSnow

		You can edit this code.But you cant upload anymore.
]]

-- Last update : 2026/05/07

local SERVICE = {
	Name = "哔哩哔哩直播",
	IsTimed = false,

	NeedsCodecFix = true
}

local META_URL = "https://live.bilibili.com/%s"

function SERVICE:Match( url )
	local host = url.host or ""
	local path = url.path or ""
	return host:match("live.bilibili.com") and string.find(path, "/[%w*].")
end


function SERVICE:GetURLInfo( url )
	local info = {}
	local host = url.host or ""
	local path = url.path or ""
	if host:match("live.bilibili.com") then
		info.Data = string.match(path,"[%w*]+")
	end
	return info.Data and info or false
end

function SERVICE:GetVideoInfo( ID , onSuccess, onFailure )
	local f = Format("https://api.live.bilibili.com/room/v1/Room/get_info?room_id=%s", ID)

	local onReceive = function(b, l, h, c)
		http.Fetch(f, function(r, s)
			if s == 0 then
				return onFailure( "Theater_RequestFailed" )
			end

			local rT = util.JSONToTable(r)
			local data = rT.data

			if data == nil then
				return onFailure( "Theater_RequestFailed" )
			end

			if data.live_status == 0 then
				return onFailure( "Service_StreamOffline" )
			end

			local info = {}
			info.thumbnail = data.user_cover
			info.title = data.title

			if onSuccess then
				pcall(onSuccess, info)
			end
		end)
	end

	local url = META_URL:format( ID )
	self:Fetch( url, onReceive, onFailure )
end

theater.RegisterService( "bilibili_live", SERVICE )
