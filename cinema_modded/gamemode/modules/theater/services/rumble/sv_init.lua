local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("rumble", SERVICE)

theater.RegisterService( "rumblelive", {
	Name = "Rumble Live",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
