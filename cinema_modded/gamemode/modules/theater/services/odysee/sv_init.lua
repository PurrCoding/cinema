local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("odysee", SERVICE)

theater.RegisterService( "odyseelive", {
	Name = "Odysee Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
} )
