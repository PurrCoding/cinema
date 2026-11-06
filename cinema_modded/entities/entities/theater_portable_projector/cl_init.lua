--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

--[[
	EXPERIMENTAL - USE AT YOUR OWN RISK

	This theater projector entity is experimental and may not work as expected.
	Use in production environments at your own risk.
]]--

include("sh_init.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

-- Projector settings
local ProjectionDistance = 1024
local ProjectionBrightness = 2
local offset = 0

-- 16:9 aspect ratio FOV calculation
local BaseHorizontalFOV = 90
local AspectRatio = 16 / 9
local VerticalFOV = math.deg(2 * math.atan(math.tan(math.rad(BaseHorizontalFOV / 2)) / AspectRatio))

function ENT:Initialize()
	local mins, maxs = self:GetModelBounds()
	if mins and maxs then
		local center = (mins + maxs) / 2
		self.CenterOffset = Vector(center.x + offset, center.y, center.z)

		-- Calculate model's forward extent to determine safe NearZ
		local modelDepth = math.abs(maxs.x - mins.x)
		self.SafeNearZ = modelDepth * 1.2  -- Start projection 1.2x the model depth
	end
end

function ENT:Think()
	-- Throttle validation checks to every 0.5 seconds for performance
	if not self.NextValidation or self.NextValidation < CurTime() then
		local ply = LocalPlayer()
		local hasTheaterMethod = ply.GetTheater ~= nil

		-- Get all required references upfront
		local playerTheater = hasTheaterMethod and ply:GetTheater() or nil
		local locId = self:GetTheaterLocation()

		-- Check if cached panel is still valid, otherwise get new one
		if not IsValid(self.CachedPanel) then
			self.CachedPanel = theater.ActivePanel()
		end

		local panel = self.CachedPanel
		local video = theater.CurrentVideo()

		-- Combined validation check
		local shouldRemove = not hasTheaterMethod or
							not playerTheater or
							not locId or
							locId == 0 or
							locId ~= playerTheater:GetLocation() or
							not IsValid(panel) or
							not video

		if shouldRemove then
			self:RemoveProjector()
			self.CachedPanel = nil  -- Clear cached panel
			return
		end

		-- Only create projector when all conditions are met
		if not IsValid(self.Projector) then
			self:CreateProjector()
		end

		self.NextValidation = CurTime() + 0.5
	end

	-- Per-frame updates (not throttled)
	if IsValid(self.Projector) and IsValid(self.CachedPanel) then
		-- Safety check for CenterOffset
		if not self.CenterOffset then
			local mins, maxs = self:GetModelBounds()
			if mins and maxs then
				local center = (mins + maxs) / 2
				self.CenterOffset = Vector(center.x + 20, center.y, center.z)
			else
				self.Projector:SetPos(self:GetPos())
				self.Projector:SetAngles(self:GetAngles())
				self.Projector:Update()
				return
			end
		end

		-- Update projector position and angles
		local centerPos = self:LocalToWorld(self.CenterOffset)
		local ang = self:GetAngles()

		self.Projector:SetPos(centerPos)
		self.Projector:SetAngles(ang)

		-- Update texture from cached panel
		local mat = self.CachedPanel:GetHTMLMaterial()
		if mat then
			local texture = mat:GetTexture("$basetexture")
			if texture then
				self.Projector:SetTexture(texture)
			end
		end

		self.Projector:Update()
	end
end

function ENT:CreateProjector()
	self.Projector = ProjectedTexture()
	self.Projector:SetHorizontalFOV(BaseHorizontalFOV)
	self.Projector:SetVerticalFOV(VerticalFOV)
	self.Projector:SetFarZ(ProjectionDistance)

	-- Use calculated safe distance or fallback to 48
	local nearZ = self.SafeNearZ or 48
	self.Projector:SetNearZ(nearZ)

	self.Projector:SetColor(Color(255, 255, 255))
	self.Projector:SetBrightness(ProjectionBrightness)
	self.Projector:SetEnableShadows(false)
end

function ENT:RemoveProjector()
	if IsValid(self.Projector) then
		self.Projector:Remove()
		self.Projector = nil
	end
end

function ENT:Draw()
	-- Set render mode to support transparency
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	-- Set color with alpha channel (0-255, where 0 is fully transparent, 255 is fully opaque)
	self:SetColor(Color(255, 255, 255, 128))

	-- Draw the model
	self:DrawModel()
end

function ENT:OnRemove()
	self:RemoveProjector()
end