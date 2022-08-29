
if SERVER then
    hook.Add("PlayerSpawn", "CinemaSbox_Spawn", function(ply, transition)
        if (GAMEMODE.IsSandboxDerived and IsValid( ply )) then
            timer.Simple(0, function()
                player_manager.SetPlayerClass( ply, "player_sandbox" )
                player_manager.RunClass( ply, "Loadout")
                player_manager.OnPlayerSpawn( ply )
            end)
        end
    end)
end