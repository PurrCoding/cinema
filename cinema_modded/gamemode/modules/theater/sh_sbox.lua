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

if SERVER then
    hook.Add("PlayerSpawn", "CinemaSbox_Spawn", function(ply, transition)
        if (GAMEMODE.IsSandboxDerived and IsValid( ply )) then
            timer.Simple(0, function()
                player_manager.SetPlayerClass( ply, "player_sandbox" )
                player_manager.RunClass( ply, "Loadout")
                player_manager.OnPlayerSpawn( ply, false )
            end)
        end
    end)
end