local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("url_protocol", SERVICE)

-- Register live streaming variant
theater.RegisterService( "url_protocol_live", {
	Name = "URL (Protocol, Live)",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )
