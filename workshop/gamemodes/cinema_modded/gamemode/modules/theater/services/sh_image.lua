--[[
    This "Image" Cinema service was created with time and effort by Shadowsun™ (STEAM_0:1:75888605 | https://bio.link/shadowsun )
    Don't be a bad person who steals other people's works and uses it for their own benefit, keep the credits and don't remove them!
--]]

local SERVICE = {}
SERVICE.Name = "Image"
SERVICE.IsTimed = false
SERVICE.IsCacheable = false
SERVICE.Dependency = DEPENDENCY_NONE

--[[
	Uncomment this line below to restrict Image
	only to Private Theaters.
]]--
-- SERVICE.TheaterType = THEATER_PRIVATE

local validExtensions = {
	["jpg"] = true,
	["png"] = true,
	["bmp"] = true,
	["jpeg"] = true,
	["gif"] = true,
}

function SERVICE:Match( url )
	return validExtensions[ string.GetExtensionFromFilename( url.path ) ]
end

if (CLIENT) then
	function SERVICE:LoadProvider( Video, panel )
		panel:OpenURL(Video:Data())
	end
end

if (SERVER) then
	CreateConVar("cinema_service_imageduration", "0", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "0 = Infinite, 60sec Max", 0, 60 )
end

function SERVICE:GetURLInfo( url )

	if url and url.encoded then
		return { Data = url.encoded }
	end

	return false

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	local info = {}
	info.title = ("Image: %s"):format(data)
	info.thumbnail = self.PlaceholderThumb

	local duration = GetConVar("cinema_service_imageduration"):GetInt()
	if duration > 0 then
		info.type = "image_timed"
		info.duration = duration
	end

	if onSuccess then
		pcall(onSuccess, info)
	end

end

theater.RegisterService( "image", SERVICE )

theater.RegisterService( "image_timed", {
	Name = SERVICE.Name,
	IsTimed = true,
	IsCacheable = false,
	Dependency = SERVICE.Dependency,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )