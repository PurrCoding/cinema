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

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model( "models/sunabouzu/thumbnail_case.mdl" )

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "TheaterName" )
	self:NetworkVar( "String", 1, "Title" )
	self:NetworkVar( "String", 2, "Thumbnail" )

	if SERVER then
		self:SetTitle("NoVideoPlaying")
		self:SetTheaterName("Invalid")
		self:SetThumbnail("")
	end
end

function ENT:OnRemove()

	if CLIENT and IsValid(self.HTML) then
		self.HTML:Remove()
	end

end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end