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

module( "Location", package.seeall )

-- Prevent sending clients a theater video too early
local DelayThinkSeconds = 3

hook.Add( "PlayerThink", "LocationThink", function( ply )
	if not ply:IsConnected() or (ply:TimeConnected() < DelayThinkSeconds) then return end

	local oldloc = ply:GetLocation()
	local loc = Find( ply )
	if oldloc == loc then return end

	ply:SetLocation(loc)

	-- Player, New Location, Old Location
	hook.Call( "PlayerChangeLocation", GAMEMODE, ply, loc, oldloc )
end )

-- Lua refresh theater fix (used in development)
hook.Add("OnReloaded", "ResetPlayerLocations", function()
	timer.Simple( 0.1, function()
		for _, ply in pairs(player.GetAll()) do
			ply:SetInTheater(false)
			hook.Call( "PlayerChangeLocation", GAMEMODE, ply, ply:GetLocation(), 0 )
		end
	end)
end)