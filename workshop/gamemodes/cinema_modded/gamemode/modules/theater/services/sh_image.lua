local SERVICE = {}

SERVICE.Name = "Image"
SERVICE.IsTimed = false

SERVICE.IsCacheable = false
SERVICE.Dependency = DEPENDENCY_NONE

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