// PLEASE EDIT THIS FOR YOUR SERVER!
local SuperAdmins = {
	/*"STEAM_0:1:6044247",	// MacDGuy
	"STEAM_0:1:18712009",	// Foohy
	"STEAM_0:1:15862026",	// Sam
	"STEAM_0:0:5129735",	// Mr. Sunabouzu
	"STEAM_0:0:15339565",	// Clopsy
	"STEAM_0:1:4556804",	// Azuisleet*/
}

local Admins = {
	// PLEASE EDIT
}

hook.Add( "PlayerInitialSpawn", "AuthAdmin", function( ply )

	if table.HasValue( SuperAdmins, ply:SteamID() ) then
		ply:SetUserGroup( "superadmin" )
	end

	if table.HasValue( Admins, ply:SteamID() ) then
		ply:SetUserGroup( "admin" )
	end

end )

concommand.Add( "cinema_changelevel", function( ply, cmd, args )

	if ply == NULL or ply:IsSuperAdmin() then

		local map = args[1]

		if map == nil then
			map = game.GetMap()
		elseif !isstring(map) then
			return
		end

		local MapName = string.lower( tostring( map ) )
		local FilePlace = "../maps/" .. string.Trim( MapName ) .. ".bsp"

		ply:PrintMessage( HUD_PRINTCONSOLE, "Starting process to change map to: " .. MapName .. "\n" )

		if file.Exists( FilePlace, "GAME" ) == false then
			ply:PrintMessage( HUD_PRINTCONSOLE, "Map " .. MapName .. " does not exist!\n" )
			return
		end

		for k,v in ipairs( player.GetAll() ) do
			v:ChatPrint( "Changing level to " .. MapName )
		end

		// Finally, change level!
		timer.Simple( 2, function()
			RunConsoleCommand( "changelevel", MapName )
		end )

	end

end )