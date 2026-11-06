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

--[[---------------------------------------------------------
   Name: gamemode:SetPlayerSpeed( )
   Desc: Sets the player's run/walk speed
-----------------------------------------------------------]]
function GM:SetPlayerSpeed( ply, walk, run )

	ply:SetWalkSpeed( walk )
	ply:SetRunSpeed( run )

end


--[[---------------------------------------------------------
   Name: gamemode:OnPlayerChat()
		Process the player's chat.. return true for no default
-----------------------------------------------------------]]
function GM:OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )

	--
	-- I've made this all look more complicated than it is. Here's the easy version
	--
	-- chat.AddText( player, Color( 255, 255, 255 ), ": ", strText )
	--

	local tab = {}

	if ( bPlayerIsDead ) then
		table.insert( tab, Color( 255, 30, 40 ) )
		table.insert( tab, "*DEAD* " )
	end

	if ( bTeamOnly and IsValid(player) ) then
		table.insert( tab, Color( 123, 32, 29 ) )
		table.insert( tab, "[" .. player:GetLocationName() .. "] " )
	end

	if ( IsValid( player ) ) then
		table.insert( tab, player )
	else
		table.insert( tab, "Console" )
	end

	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": " .. strText )

	chat.AddText( unpack(tab) )

	return true

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerNoClip( player, bool )
   Desc: Player pressed the noclip key, return true if
		  the player is allowed to noclip, false to block
-----------------------------------------------------------]]
function GM:PlayerNoClip( pl, on )

	-- Allow admin to noclip
	if pl:IsAdmin() then return true end

	if GetConVar( "sv_cheats" ):GetInt() > 0 then return true end

	-- Allow noclip if we're in single player
	if ( game.SinglePlayer() ) then return true end

	-- Don't if it's not.
	return false

end