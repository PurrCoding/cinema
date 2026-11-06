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

local meta = FindMetaTable("Player")
if not meta then return end

function meta:GetLocation()
	return self:GetDTInt(0) or 0
end

function meta:GetLastLocation()
	return self.LastLocation or -1
end

function meta:GetLocationName()
	return Location.GetLocationNameByIndex( self:GetLocation() )
end

function meta:SetLocation(locationId)
	self.LastLocation = self:GetLocation()
	return self:SetDTInt(0, locationId)
end