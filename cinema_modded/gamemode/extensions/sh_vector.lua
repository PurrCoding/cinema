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

local meta = FindMetaTable("Vector")
if not meta then return end

function meta:InBox( vec1, vec2 )
	return self.x >= vec1.x and self.x <= vec2.x and
		self.y >= vec1.y and self.y <= vec2.y and
		self.z >= vec1.z and self.z <= vec2.z
end