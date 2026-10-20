local SERVICES = include "cl_init.lua"
if not SERVICES then return end

theater.RegisterService("url_basic", SERVICES.url_basic)
theater.RegisterService("url_proprietary", SERVICES.url_proprietary)
theater.RegisterService("image_timed", SERVICES.image_timed)
theater.RegisterService("image", SERVICES.image)
