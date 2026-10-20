local SERVICES = include "cl_init.lua"
if not SERVICES then return end

if (SERVER) then
	CreateConVar("cinema_service_imageduration", "0", {FCVAR_ARCHIVE, FCVAR_NEVER_AS_STRING}, "0 = Infinite, 60sec Max", 0, 60 )
end


theater.RegisterService("url_basic", SERVICES.url_basic)
theater.RegisterService("url_proprietary", SERVICES.url_proprietary)
theater.RegisterService("image_timed", SERVICES.image_timed)
theater.RegisterService("image", SERVICES.image)
