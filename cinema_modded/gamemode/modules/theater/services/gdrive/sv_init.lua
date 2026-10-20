local SERVICE = include "cl_init.lua"
if not SERVICE then return end

theater.RegisterService("gdrive", SERVICE)
