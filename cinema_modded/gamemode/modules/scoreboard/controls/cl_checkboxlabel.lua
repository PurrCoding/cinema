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

local PANEL = {}

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	self.BaseClass.PerformLayout(self)

	if ( self.Label ) then
		local x, y = self.Label:GetPos()
		y = (self.Button:GetTall() / 2) - (self.Label:GetTall() / 2)
		self.Label:SetPos(x, y)
	end

end


--[[---------------------------------------------------------
	SizeToContents
-----------------------------------------------------------]]
function PANEL:SizeToContents()

	self:InvalidateLayout( true )
	self:SetWide( self.Label.x + self.Label:GetWide() )
	self:SetTall( self.Label.y + self.Label:GetTall() )

end

derma.DefineControl( "TheaterCheckBoxLabel", "", PANEL, "DCheckBoxLabel" )
