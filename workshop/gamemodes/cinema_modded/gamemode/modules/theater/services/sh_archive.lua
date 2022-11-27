--[[
    This "Internet Archive" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
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

SERVICE.Name = "Internet Archive"
SERVICE.IsTimed = true

--[[
	Uncomment this line below to restrict Videostreaming
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

function SERVICE:Match( url )
	return url.host and url.host:match("archive.org")
end

if (CLIENT) then
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("VIDEO")[0]
			if (!!player) {
				if (player.paused) {player.play();}
				if (player.paused === false && player.readyState === 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					player.style = "width:100%; height: 100%;";

					exTheater.controllerReady();
				}
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local Data = string.Explode(",", Video:Data())
		local identifier, file = Data[1], ( Data[2] and Data[2] or nil )
		local url = DOWNLOAD_URL:format(identifier, Video:Title() )

		panel:OpenURL( url )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

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
		local name, duration

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

		if not name or not duration  then -- Do we have everything that we want?
			return onFailure( "Theater_RequestFailed" )
		end

		local info, thumbnail = {}, self:GetThumbnail(response, file or name)
		info.title = name
		info.duration = math.Round(duration)
		info.thumbnail = thumbnail and DOWNLOAD_URL:format(identifier, thumbnail) or self.PlaceholderThumb

		if onSuccess then
			pcall(onSuccess, info)
		end

	end

	local url = METADATA_URL:format( identifier )
	self:Fetch( url, onReceive, onFailure )

end

theater.RegisterService( "archive", SERVICE )