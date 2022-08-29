
if SERVER then
    hook.Add("PlayerLoadout", "CinemaSbox_Loadout", function(ply)
        if (GAMEMODE.IsSandboxDerived and IsValid(ply)) then
            ply:Give("gmod_tool")
        end
    end)

    hook.Add("PlayerSpawn", "CinemaSbox_Spawn", function(ply, transition)
        if (GAMEMODE.IsSandboxDerived and IsValid(ply)) then
            timer.Simple(0, function()
                player_manager.SetPlayerClass( ply, "player_sandbox" )
                player_manager.OnPlayerSpawn( ply )
            end)
        end
    end)
end