GM.Name 		= "Cinema"
GM.Author		= "pixelTail Games"
GM.Email 		= "contact@pixeltailgames.com"
GM.Website 		= "www.pixeltailgames.com"
GM.TeamBased 	= false

-- Enable sandbox functionalities
local Cvar_DeriveSbox = CreateConVar("cinema_enable_sandbox", "0", {FCVAR_NOTIFY, FCVAR_REPLICATED,
FCVAR_REPLICATED, FCVAR_LUA_SERVER, FCVAR_ARCHIVE}, "NEEDS SERVER RESTART!")

if not GM.IsSandboxDerived and Cvar_DeriveSbox:GetBool() then
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
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage( ply, attacker )
	return false
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