local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("bitchute", SERVICE)

-- Hidden live variant (same player, no seeking / no end-of-media)
theater.RegisterService( "bitchutelive", {
	Name = "BitChute Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
