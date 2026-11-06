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