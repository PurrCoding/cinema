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

local commands = {
	agree = "agree",
	bow = "bow",
	beckon = "becon",
	cheer = "cheer",
	dance = "dance",
	disagree = "disagree",
	forward = "forward",
	group = "group",
	halt = "halt",
	flail = "zombie",
	laugh = "laugh",
	muscle = "muscle",
	-- point = "point",
	robot = "robot",
	-- salute = "salute",
	sexy = "muscle",
	wave = "wave",
	zombie = "zombie",
}

hook.Add( "PlayerSay", "TheaterActCommands", function( ply, chat )

	if string.StartWith( chat, '/' ) then

		if ply:IsPlayingTaunt() then
			return ""
		end

		local command = string.match( chat, "/(.*)" )

		if commands[command] then

			ply:SendLua( "RunConsoleCommand('act', '" .. commands[command] .. "')" )

			net.Start( "TheaterAnnouncement" )
				net.WriteTable({
					"ActCommand",
					ply:Nick(),
					command
				})
			net.Send( Location.GetPlayersInLocation( ply:GetLocation() ) )

			return ""

		end

	end

end )