-- Register shared service metadata and methods before server-only behavior.
include("cl_init.lua")

local SERVICE = theater.GetServiceByClass( "bilibili_live" )
if not SERVICE then return end
