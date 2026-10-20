local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("vk", SERVICE)

theater.RegisterService( "vklive", {
	Name = "VK Video (Live)",
	IsTimed = false,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
