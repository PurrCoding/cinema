local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("dailymotion", SERVICE)

theater.RegisterService( "dailymotionlive", {
	Name = "Dailymotion Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
