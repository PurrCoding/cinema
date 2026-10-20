-- Register shared service metadata and client/server-independent methods first.
include("cl_init.lua")

local SERVICE = theater.GetServiceByClass( "bilibili" )
if not SERVICE then return end
