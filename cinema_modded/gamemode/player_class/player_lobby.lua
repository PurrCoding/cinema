AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_weaponcolor", "0.30 1.80 2.10", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )

end

local PLAYER = {}

PLAYER.TauntCam = TauntCamera()

PLAYER.DisplayName			= "Lobby Class"

PLAYER.WalkSpeed 			= 200		-- How fast to move when not running
PLAYER.SlowWalkSpeed		= 100		-- How fast to move when slow-walking (+WALK)
PLAYER.RunSpeed				= 300		-- How fast to move when running
PLAYER.CrouchedWalkSpeed 	= 0.2		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 120		-- How powerful our jump should be
PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide 	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= false		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands


--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()
	BaseClass.SetupDataTables( self )
	self.Player:NetworkVar( "Int", 0, "Location" )
	self.Player:NetworkVar( "Bool", 0, "InTheater" )
end

--
-- Called serverside only when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )

	timer.Simple(0, function()
		if not IsValid(self.Player) then return end

		local col = self.Player:GetInfo( "cl_playercolor" )
		self.Player:SetPlayerColor( Vector( col ) )
		self.Player:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		self.Player:ClearPoseParameters()

		local wepclr = Vector( self.Player:GetInfo( "cl_weaponcolor" ) )
		if ( wepclr:Length() < 0.001 ) then
			wepclr = Vector( 0.001, 0.001, 0.001 )
		end
		self.Player:SetWeaponColor( wepclr )

		local skin = self.Player:GetInfoNum( "cl_playerskin", 0 )
		self.Player:SetSkin( skin )

		local bodygroups = self.Player:GetInfo( "cl_playerbodygroups" )
		if ( bodygroups == nil ) then bodygroups = "" end

		local groups = string.Explode( " ", bodygroups )
		for k = 0, self.Player:GetNumBodyGroups() - 1 do
			self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end
	end)

end

--
-- Called on spawn to give the player their default loadout
--
function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	self.Player:SwitchToDefaultWeapon()

	-- Give popcorn if ConVar is enabled and weapon exists
	if GetConVar("cinema_spawn_popcorn"):GetBool() then
		if weapons.Get("weapon_popcorn") then
			self.Player:Give("weapon_popcorn")
		else
			print("Warning: weapon_popcorn does not exist!")
		end
	end

end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end


player_manager.RegisterClass( "player_lobby", PLAYER, "player_default" )