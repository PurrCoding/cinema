--[[
     █████╗ ██████╗  ██████╗██╗  ██╗██╗██╗   ██╗███████╗    ██████╗ ██████╗  ██████╗ 
    ██╔══██╗██╔══██╗██╔════╝██║  ██║██║██║   ██║██╔════╝   ██╔═══██╗██╔══██╗██╔════╝ 
    ███████║██████╔╝██║     ███████║██║██║   ██║█████╗     ██║   ██║██████╔╝██║  ███╗
    ██╔══██║██╔══██╗██║     ██╔══██║██║╚██╗ ██╔╝██╔══╝     ██║   ██║██╔══██╗██║   ██║
    ██║  ██║██║  ██║╚██████╗██║  ██║██║ ╚████╔╝ ███████╗██╗╚██████╔╝██║  ██║╚██████╔╝
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ 
                                                                                     
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
local METADATA_URL = "https://archive.org/metadata/%s/files/"
local DOWNLOAD_URL = "https://cors.archive.org/download/%s/%s"
local VALID_FORMATS = {
	["MPEG4"] = true,
	["h.264"] = true,
	["h.264 IA"] = true,
	["Ogg Video"] = true,
}

SERVICE.Name 	= "Archive"
SERVICE.IsTimed = true

function SERVICE:Match( url )
	return string.match( url.host, "archive.org" )
end

if (CLIENT) then
	function SERVICE:PreLoadVideo(Video, panel)
		local startTime = CurTime() - Video:StartTime()
		local Data = string.Explode(",", Video:Data())
		local identifier, file = Data[1], ( Data[2] and Data[2] or nil )

		local url = DOWNLOAD_URL:format(identifier, Video:Title() )
		print(url)
		local str = string.format( "if (window.theater) theater.loadVideo( '%s', '%s', %s );",
		Video:Type(), string.JavascriptSafe(url), startTime )

		panel:QueueJavascript( str )
	end
end

function SERVICE:GetURLInfo( url )

	if url.path then
		local identifier = url.path:match("^/details/([%w%-%._]+)")
		if identifier then
			local file = ("^/details/%s/([%%w%%-%%.%%/%%+%%&_]+)"):format(identifier)
			file = url.path:match(file)

			return { Data = ("%s%s"):format(identifier, file and "," .. file or "") }
		end
	end

	return false
end

if (SERVER) then
	function SERVICE:GetThumbnail(response, file)
		local thumbnail
		for k, v in pairs(response) do
			if not thumbnail and (v.format == "Thumbnail" and v.original == file) then
				thumbnail = v.name
				break
			end
		end

		return thumbnail
	end
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local Data = string.Explode(",", data)
	local identifier, file = Data[1], ( Data[2] and Data[2] or nil )

	local onReceive = function( body, length, headers, code )
		if not body or code ~= 200 then
			return onFailure( "Theater_RequestFailed" )
		end

		local response = util.JSONToTable(body)
		if not response or not response.result then
			return onFailure( "Theater_RequestFailed" )
		end

		response = response.result
		local name, duration, thumbnail

		if file then
			oFile = file
			file = file:Replace("+", " ")
		end

		for k, v in pairs(response) do

			if file then

				if (v.original and v.original == file and VALID_FORMATS[v.format]) then
					name, duration = v.name, v.length
					break
				end

				if (v.name and v.name == oFile and VALID_FORMATS[v.format]) then
					name, duration = v.name, v.length
				end

			else
				if (v.format and VALID_FORMATS[v.format]) then
					name, duration = v.name, v.length
					break
				end
			end
		end

		thumbnail = self:GetThumbnail(response, file or name) or self.PlaceholderThumb

		if not name or not duration or not thumbnail then -- Do we have everything that we want?
			return onFailure( "Theater_RequestFailed" )
		end

		local info = {}
		info.title = name
		info.duration = math.Round(duration)
		info.thumbnail = DOWNLOAD_URL:format(identifier, thumbnail)

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = METADATA_URL:format( identifier )
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "archive", SERVICE )