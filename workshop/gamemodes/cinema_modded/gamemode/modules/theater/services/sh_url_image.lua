local SERVICE = {
	Name = "URL (Image)",
	IsTimed = false,
	Hidden = true,

	IsCacheable = false,
	Dependency = DEPENDENCY_NONE
}

if (CLIENT) then
	function SERVICE:LoadProvider( Video, panel )
		panel:OpenURL(Video:Data())
	end
end

if (SERVER) then
	CreateConVar("cinema_service_imageduration", "0", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "0 = Infinite, 60sec Max", 0, 60 )
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