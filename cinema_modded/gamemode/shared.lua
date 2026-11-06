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

GM.Name 		= "Cinema"
GM.Author		= "pixelTail Games"
GM.Email 		= "contact@pixeltailgames.com"
GM.Website 		= "www.pixeltailgames.com"
GM.TeamBased 	= false

-- Enable sandbox functionalities
local Cvar_DeriveSbox = GetConVar("cinema_enable_sandbox") -- This command is created by GMod itself (defined in cinema_modded.txt).

if ( !GM.IsSandboxDerived and Cvar_DeriveSbox:GetBool() ) then
	DeriveGamemode( "sandbox" )
end

include( "sh_load.lua" )

include( "player_shd.lua" )
include( "player_class/player_lobby.lua" )
include( "i18n/init.lua" )
include( "credits.lua" )

Loader.Load( "extensions" )
Loader.Load( "modules" )

-- Load Map configuration file
local function loadMap(legacy)
	local strMap = (legacy and "cinema" or GM.FolderName ) .. "/gamemode/maps/" .. game.GetMap() .. ".lua"


	if not legacy then
		local strDT = GM.FolderName .. "/gamemode/maps_ducttape/" .. game.GetMap() .. ".lua"

		-- "Duct Tape" for Maps
		if file.Exists( strDT, "LUA" ) then
			if SERVER then
				AddCSLuaFile( strDT )
			end
			include( strDT )
		end
	end

	-- Maps Location
	if file.Exists( strMap, "LUA" ) then
		if SERVER then
			AddCSLuaFile( strMap )
		end
		include( strMap )
	end
end
loadMap()
loadMap(true) -- Backward compatibility

--[[---------------------------------------------------------
	 Name: gamemode:PlayerShouldTakeDamage
	 Return true if this player should take damage from this attacker
	 Cinema: If Sandbox is loaded, apply Sandbox rules instead.
-----------------------------------------------------------]]
if not Cvar_DeriveSbox:GetBool() then
	function GM:PlayerShouldTakeDamage( ply, attacker )
		return false
	end
end

--[[---------------------------------------------------------
	 Name: Text to show in the server browser
-----------------------------------------------------------]]
function GM:GetGameDescription()
	return self.Name
end

--[[---------------------------------------------------------
	 Name: gamemode:ShouldCollide( Ent1, Ent2 )
	 Desc: This should always return true unless you have
			a good reason for it not to.
-----------------------------------------------------------]]
function GM:ShouldCollide( Ent1, Ent2 )
	return false
end


--[[---------------------------------------------------------
	 Name: gamemode:Move
	 This basically overrides the NOCLIP, PLAYERMOVE movement stuff.
	 It's what actually performs the move.
	 Return true to not perform any default movement actions. (completely override)
-----------------------------------------------------------]]
function GM:Move( ply, mv )
	if ( player_manager.RunClass( ply, "Move", mv ) ) then return true end
end


--[[---------------------------------------------------------
-- Purpose: This is called pre player movement and copies all the data necessary
--          from the player for movement. Copy from the usercmd to move.
-----------------------------------------------------------]]
function GM:SetupMove( ply, mv, cmd )
	if ( player_manager.RunClass( ply, "StartMove", mv, cmd ) ) then return true end
end

--[[---------------------------------------------------------
	 Name: gamemode:FinishMove( player, movedata )
-----------------------------------------------------------]]
function GM:FinishMove( ply, mv )
	if ( player_manager.RunClass( ply, "FinishMove", mv ) ) then return true end
end