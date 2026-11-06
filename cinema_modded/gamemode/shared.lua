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

--[[---------------------------------------------------------
	Derma includes
-----------------------------------------------------------]]

if CLIENT then
	include( "scoreboard/controls/cl_html.lua" )
end

--[[---------------------------------------------------------
	Name: gamemode:CreateTeams()
	Desc: Create and set up teams
-----------------------------------------------------------]]
function GM:CreateTeams()
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerNoClip( player, bool )
-----------------------------------------------------------]]
function GM:PlayerNoClip( pl, on )
	return false
end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerSuicide( Player ply )
-----------------------------------------------------------]]
function GM:CanPlayerSuicide( ply )
	return false
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerShouldTakeDamage( Player ply, Entity attacker )
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage( ply, attacker )
	return false
end

--[[---------------------------------------------------------
	Name: gamemode:GrabEarAnimation( Player ply )
-----------------------------------------------------------]]
function GM:GrabEarAnimation( ply )
end

--[[---------------------------------------------------------
	Name: gamemode:MouthMoveAnimation( Player ply )
-----------------------------------------------------------]]
function GM:MouthMoveAnimation( ply )
end

--[[---------------------------------------------------------
	Name: gamemode:SetupMove( Player player, CMoveData movedata )
-----------------------------------------------------------]]
function GM:SetupMove( ply, mv, cmd )
	if ( player_manager.RunClass( ply, "SetupMove", mv, cmd ) ) then return true end
end

--[[---------------------------------------------------------
	Name: gamemode:FinishMove( Player player, CMoveData movedata )
-----------------------------------------------------------]]
function GM:FinishMove( ply, mv )
	if ( player_manager.RunClass( ply, "FinishMove", mv ) ) then return true end
end
