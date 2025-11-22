--[[
	EXPERIMENTAL - USE AT YOUR OWN RISK

	This theater projector entity is experimental and may not work as expected.
	Use in production environments at your own risk.
]]--

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Theater Projector"
ENT.Author = "Cinema"
ENT.Category = "Cinema"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TheaterLocation")
end