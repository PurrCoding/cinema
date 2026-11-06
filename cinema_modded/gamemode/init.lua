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

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "player_shd.lua" )
AddCSLuaFile( "sh_load.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "i18n/init.lua" )
AddCSLuaFile( "credits.lua" )

include( "shared.lua" )
include( "player.lua" )

resource.AddWorkshop( "2419005587" ) -- cinema gamemode

timer.Create( "TheaterPlayerThink", 1, 0, function()
	for _, v in pairs( player.GetAll() ) do
		if ( not IsValid( v ) ) then continue end

		hook.Call( "PlayerThink", GAMEMODE, v )
	end
end )

-- Indicates that the server is running with the Fixed Edition
CreateConVar("has_cinema_fixed", "1", {FCVAR_NOTIFY, FCVAR_REPLICATED})

--[[---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Carries out actions when the player dies
-----------------------------------------------------------]]
function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()

	ply:AddDeaths( 1 )

	if ( attacker:IsValid() and attacker:IsPlayer() ) then

		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end

	end

end


-- Set the ServerName every 30 seconds in case it changes..
-- This is for backwards compatibility only - client can now use GetHostName()
local function HostnameThink()

	SetGlobalString( "ServerName", GetHostName() )

end

timer.Create( "HostnameThink", 30, 0, HostnameThink )

--[[---------------------------------------------------------
   Name: gamemode:PlayerCanHearPlayersVoice( )
   Desc: Decides whether the
-----------------------------------------------------------]]
function GM:PlayerCanHearPlayersVoice( listener, talker )

	-- Check for theater module first
	if not theater then
		return true
	end

	local Voice3D = GetConVar("cinema_allow_3dvoice"):GetBool()
	local ListenerInTheater = listener:InTheater()
	local TalkerInTheater = talker:InTheater()

	-- Both players in theater
	if ListenerInTheater and TalkerInTheater then
		return listener:GetLocation() == talker:GetLocation() and
			GetConVar("cinema_allow_voice"):GetBool(), Voice3D

	-- One player in theater
	elseif (ListenerInTheater and not TalkerInTheater) or
		(not ListenerInTheater and TalkerInTheater) then
		return false, Voice3D

	-- Both players in non-theater areas (Lobby)
	else

		return true, Voice3D

	end

end

function GM:PlayerSwitchFlashlight( ply, enable )

	-- Admins are immune to flashlight restrictions
	if ply:IsAdmin() then
		return true
	end

	-- Only allow disabling the flashlight in theaters
	if ply.InTheater and ply:InTheater() then
		return not enable
	end

	if ply.NextFlashlightSwitch and ply.NextFlashlightSwitch > CurTime() then
		return false
	else
		ply.NextFlashlightSwitch = CurTime() + 1
	end

	return true

end