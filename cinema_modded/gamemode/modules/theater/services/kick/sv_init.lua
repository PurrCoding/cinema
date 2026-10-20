local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("kick", SERVICE)

theater.RegisterService( "kickvod", {
	Name = "Kick VOD",
	IsTimed = true,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
