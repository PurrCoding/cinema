local SERVICE = {
	Name = "Dailymotion",
	IsTimed = true,

	NeedsCodecFix = true
}

local API_URL = "https://api.dailymotion.com/video/%s?fields=id,title,duration,thumbnail_url,status,mode,private"

function SERVICE:Match( url )
	return url.host and url.host:match("dailymotion.com")
end


function SERVICE:GetURLInfo( url )

	local info = {}

	-- https://dailymotion/video/xxxxxxxxx
	if (url.path and url.path:match("^/video/([%a%d-_]+)")) then
		info.Data = url.path:match("^/video/([%a%d-_]+)")
	end

	if (url.query) then

		if url.query.start and url.query.start ~= "" then
			local time = tonumber(url.query.start)
			if time and time ~= 0 then
				info.StartTime = time
			end
		end

	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local onReceive = function( body, length, headers, code )

		local response = util.JSONToTable(body)
		if not response then
			return onFailure( "Theater_RequestFailed" )
		end

		if response.private or response.status ~= "published" then
			return onFailure( "Service_EmbedDisabled" )
		end

		local info = {}
		info.title = response.title
		info.thumbnail = response.thumbnail_url

		if (response.mode == "live" and response.duration == 0) then
			info.type = "dailymotionlive"
			info.duration = 0
		else
			info.duration = response.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = API_URL:format( data )
	self:Fetch( url, onReceive, onFailure )

end
theater.RegisterService( "dailymotion", SERVICE )

theater.RegisterService( "dailymotionlive", {
	Name = "Dailymotion Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and function( ... )
		local service = theater.GetServiceByClass( "dailymotion" )
		if service and service.LoadProvider then return service:LoadProvider( ... ) end
	end or function() end
} )