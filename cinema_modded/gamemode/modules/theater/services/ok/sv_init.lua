local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("ok", SERVICE)

theater.RegisterService( "oklive", {
	Name = "Ok Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
