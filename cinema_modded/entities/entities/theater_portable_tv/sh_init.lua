--[[
	EXPERIMENTAL - USE AT YOUR OWN RISK

	This theater tv entity is experimental and may not work as expected.
	Use in production environments at your own risk.
]]--

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Portable TV"
ENT.Author = "Cinema"
ENT.Category = "Cinema"
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TheaterLocation")
end