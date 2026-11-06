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

module( "theater", package.seeall )

function AddAnnouncement( tbl )
	if not istable(tbl) then return end

	local key = table.remove(tbl, 1)
	local values = translations:FormatChat( key, unpack(tbl) )
	chat.AddText( ColDefault, unpack(values) )
end

net.Receive( "TheaterAnnouncement", function()
	AddAnnouncement( net.ReadTable() )
end )