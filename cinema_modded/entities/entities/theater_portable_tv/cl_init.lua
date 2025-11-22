--[[
	EXPERIMENTAL - USE AT YOUR OWN RISK

	This theater tv entity is experimental and may not work as expected.
	Use in production environments at your own risk.
]]--

include("sh_init.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

-- Screen dimensions
local ScreenWidth = 570
local ScreenHeight = 327

-- Fixed scale value (proven to work well)
local RenderScale = 0.1

-- Offset variables for easy adjustment
local AngleOffset = Angle(0, 90, 90)
local VectorOffset = Vector(6, 0, 19)  -- Adjust X to move forward/backward

function ENT:Initialize()
	-- Get model bounds for render bounds only
	local mins, maxs = self:GetModelBounds()
	local buffer = (maxs - mins) * 0.3
	self:SetRenderBounds(mins - buffer, maxs + buffer)

	-- Use fixed scale multiplied by model scale
	self.ScreenScale = RenderScale * self:GetModelScale()
end

function ENT:FixOffsets()
	-- Use LocalToWorld for proper rotation handling
	local pos, ang = LocalToWorld(
		Vector(
			VectorOffset.x,
			VectorOffset.y + (self.ScreenScale * ScreenWidth * -0.5),
			VectorOffset.z + (self.ScreenScale * ScreenHeight * 0.5)
		),
		AngleOffset,
		self:GetPos(),
		self:GetAngles()
	)
	self.Attach = {
		Pos = pos,
		Ang = ang,
	}
end

function ENT:Draw()
	self:DrawModel()
	self:FixOffsets()

	if not self.Attach then return end

	-- Get player's current theater
	local ply = LocalPlayer()
	if not ply.GetTheater then return end

	local playerTheater = ply:GetTheater()
	if not playerTheater then return end

	-- Check if TV is linked to player's theater
	local locId = self:GetTheaterLocation()
	if not locId or locId == 0 then return end
	if locId ~= playerTheater:GetLocation() then return end

	-- Get active panel and video
	local panel = theater.ActivePanel()
	if not IsValid(panel) then return end

	local video = theater.CurrentVideo()
	if not video then return end

	-- Render the video content
	cam.Start3D2D(self.Attach.Pos, self.Attach.Ang, self.ScreenScale)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, ScreenWidth, ScreenHeight)
		draw.HTMLTexture(panel, ScreenWidth, ScreenHeight)
	cam.End3D2D()
end