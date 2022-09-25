AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_init.lua" )
include( "sh_init.lua" )

ENT.DoorOpen = Sound("doors/door1_move.wav") --just defaults
ENT.DoorClose = Sound("doors/door_wood_close1.wav") --just defaults

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow( false )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMaterial("gmod_silent")
	end

	self:PostInitialize()
end

function ENT:PostInitialize()
	self.LinkedDoor = self:GetLinkedDoor()
	self.TeleportEntity = self:GetTeleportEntity()
end

function ENT:Use(activator, caller)
	self:TriggerOutput("OnUse", activator)

	if IsValid(activator) and not activator.Teleporting then
		self:StartLoading( activator )

		local sequence = self:LookupSequence("open")

		if (self:GetSequence() ~= sequence ) then
			self:ResetSequence(sequence)
			self:SetPlaybackRate(1.0)

			local door = self.LinkedDoor
			if IsValid( door ) then
				door:ResetSequence( sequence )
				door:SetPlaybackRate( 1.0 )
			end

			self:EmitSound( self.DoorOpen )
		end
	end
end

function ENT:GetLinkedDoor()
	if IsValid( self.TeleportEnt ) then
		local near = ents.FindInSphere( self.TeleportEnt:GetPos(), 50 )
		for _, v in pairs( near ) do
			if IsValid( v ) and v:GetClass() == self:GetClass() then
				return v
			end
		end
	end

	return nil
end

function ENT:GetTeleportEntity()

	-- Attempt to find entity
	if not IsValid(self.TeleportEnt) then
		if self.TeleportName then
			local entities = ents.FindByName(self.TeleportName)
			if IsValid(entities[1]) then
				self.TeleportEnt = entities[1]
			end
		else
			print("ERROR: Invalid door teleport configuration.")
			print(self)
		end
	end

	return self.TeleportEnt

end

function ENT:StartLoading( ply )
	net.Start("TheaterDoorLoad", true)
		net.WriteEntity( self )
	net.Send(ply)

	ply.Teleporting = true
	ply:Freeze( true )

	timer.Simple( self.FadeTime + self.DelayTime, function()

		if IsValid( ply ) then
			--Teleport the player
			ply.Teleporting = false
			ply:Freeze( false )

			ply:EmitSound(self.DoorClose)

			local ent = self.TeleportEntity
			if IsValid(ent) then
				ply:SetPos( ent:GetPos() )
				ply:SetEyeAngles( ent:GetAngles() )
			end
		end

	end )
	self.TeleportAt = CurTime() + self.FadeTime + self.DelayTime
	self.ShouldTeleport = true
end

function ENT:Think()
	if self.ShouldTeleport and CurTime() > self.TeleportAt then
		--shut the frickity front door
		local sequence = self:LookupSequence("idle")
		self:SetSequence(sequence)

		local door = self.LinkedDoor
		if IsValid( door ) then
			door:SetSequence( sequence )
		end

		self:EmitSound( self.DoorClose )

		self.ShouldTeleport = false
		self.TeleportPly = nil
	end

	self:NextThink(CurTime())
	return true
end

function ENT:KeyValue(key, value)
	local isEmpty = not value or string.len(value) <= 0

	if key == "OnTeleport" or key == "OnUnlock" or key == "OnUse" then
		self:StoreOutput(key, value)
	end

	if not isEmpty then

		if key == "teleportentity" then
			self.TeleportName = value
		elseif key == "opendoorsound" then
			self.DoorOpen = Sound( value )
		elseif key == "closedoorsound" then
			self.DoorClose = Sound( value )
		elseif key == "model" then
			self:SetModel(Model(value))
		end
	end
end