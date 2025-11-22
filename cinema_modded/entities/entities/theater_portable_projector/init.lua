--[[
	EXPERIMENTAL - USE AT YOUR OWN RISK

	This theater projector entity is experimental and may not work as expected.
	Use in production environments at your own risk.
]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

function ENT:Initialize()
	self:SetModel("models/editor/cone_helper.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	local theater = activator:GetTheater()
	if theater then
		self:SetTheaterLocation(theater:GetLocation())
	end
end