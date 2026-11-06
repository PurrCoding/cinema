--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

module( "theater", package.seeall )

Services = {}

function RegisterService( class, object, base )

	if istable(class) and object == nil then
		object = class
		class = object.ClassName
	end

	if not class or not object then return end
	if not base then base = "base" end

	Services[ class ] = object
	Services[ class ].ClassName = class

	if not Services[ base ] then
		ErrorNoHalt( "theater.RegisterService: Base class '" .. tostring(base) .. "' not found!" )
	else
		if class == "base" then return end
		setmetatable( Services[ class ], { __index = Services[ base ] } )
	end

end

function GetServiceClasses()

	return table.GetKeys( Services )

end

function GetServiceByClass( class )

	return Services [ class ]

end

-- Load the base service before anything else
if SERVER then
	AddCSLuaFile("services/sh_base.lua")
end
include("services/sh_base.lua")

Loader.Load( "modules/theater/services" )