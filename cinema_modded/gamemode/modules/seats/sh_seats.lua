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

ChairOffsets = {
	-- Original seats
	["models/sunabouzu/lobby_chair.mdl"] = {
		{ Pos = Vector(5.2, 0, 34.1), Ang = Angle(0, 0, 0) }
	},
	["models/gmod_tower/theater_seat.mdl"] = {
		{ Pos = Vector(1, -5, 23), Ang = Angle(10, 180, 0) }
	},
	["models/sunabouzu/theater_curve_couch.mdl"] = {
		{ Pos = Vector(-73.6, 17.3, 18.8), Ang = Angle(0, -128, 0) },
		{ Pos = Vector(-65.2, 50.3, 18.8), Ang = Angle(0, -128, 0) },
		{ Pos = Vector(-37.5, 71.7, 18.8), Ang = Angle(0, -153, 0) },
		{ Pos = Vector(0, 80, 18.8), Ang = Angle(0, -180, 0) },
		{ Pos = Vector(37.5, 71.7, 18.8), Ang = Angle(0, 153, 0) },
		{ Pos = Vector(65.2, 50.3, 18.8), Ang = Angle(0, 128, 0) },
		{ Pos = Vector(73.6, 17.3, 18.8), Ang = Angle(0, 128, 0) },
	},
	["models/sunabouzu/theater_sofa01.mdl"] = {
		{ Pos = Vector(-16.8, -0.9, 16.2), Ang = Angle(0, -180, 0) },
		{ Pos = Vector(16.8, -0.9, 16.2), Ang = Angle(0, -180, 0) },
	},
	["models/props_trainstation/traincar_seats001.mdl"] = {
		{ Pos = Vector(4.6150, 41.7277, 18.5313) },
		{ Pos = Vector(4.7320, 14.4948, 18.5313) },
		{ Pos = Vector(4.5561, -13.3913, 18.5313) },
		{ Pos = Vector(5.4507, -40.9903, 18.5313) },
	},
	["models/props_warehouse/office_furniture_couch.mdl"] = {
		{ Pos = Vector(4.6150, 36, -4) },
		{ Pos = Vector(4.7320, 0, -4) },
		{ Pos = Vector(5.4507, -36, -4) },
	},
	["models/props_c17/furniturechair001a.mdl"] = {
		{ Pos = Vector(0.30538135766983, 0.14535087347031, -6.69970703125) },
	},
	["models/props_combine/breenchair.mdl"] = {
		{ Pos = Vector(6.8169813156128, -2.8282260894775, 16.551658630371) },
	},

	-- New Seats
	["models/props_c17/bench01a.mdl"] = {
		{ Pos = Vector(5.5, -22.5, 2.2), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(5.5, 0, 2.2), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(5.5, 22.5, 2.2), Ang = Angle(0, -90, 0) }
	},
	["models/props/cs_office/sofa.mdl"] = {
		{ Pos = Vector(8, 0, 20), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(8, 25, 20), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(8, -25, 20), Ang = Angle(0, -90, 0) }
	},
	["models/props_trainstation/wrecked_train_seat.mdl"] = {
		{ Pos = Vector(5.5, -14, 20), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(5.5, -42, 20), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(5.5, 13, 20), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(5.5, 39, 20), Ang = Angle(0, -90, 0) }
	},
	["models/props/cs_office/sofa_chair.mdl"] = {
		{ Pos = Vector(7, 0, 20.9), Ang = Angle(0, -90, 0) }
	},
	["models/props/de_inferno/furniture_couch02a.mdl"] = {
		{ Pos = Vector(3, 0, -7.1), Ang = Angle(0, -90, 0) }
	},
	["models/props/cs_militia/couch.mdl"] = {
		{ Pos = Vector(30, 5.5, 20), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(0, 5.5, 20), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-30, 5.5, 20), Ang = Angle(0, 0, 0) }
	},
	["models/props/de_inferno/furniture_couch01a.mdl"] = {
		{ Pos = Vector(2, -17, -6), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(2, 17, -6), Ang = Angle(0, -90, 0) }
	},
	["models/props/de_inferno/furniturecouch001a.mdl"] = {
		{ Pos = Vector(0, -13, -0.5), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(0, 13.8, -0.5), Ang = Angle(0, -90, 0) }
	},
	["models/props_c17/furniturecouch002a.mdl"] = {
		{ Pos = Vector(5.5, -8.3, -5), Ang = Angle(0, -90, 0) },
		{ Pos = Vector(5.5, 11, -5), Ang = Angle(0, -90, 0) }
	},
	["models/props_biotec/couch_modern_01.mdl"] = {
		{ Pos = Vector(33.1, 5.5, 24), Ang = Angle(0, 14.9, 0) },
		{ Pos = Vector(11, 5.5, 24), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-12, 5.5, 24), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-35.9, 8.3, 24), Ang = Angle(0, -15, 0) }
	},
	["models/props_biotec/couch_modern_02.mdl"] = {
		{ Pos = Vector(35.9, 8.3, 22.9), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(13.8, 8.3, 22.9), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-13.8, 8.3, 22.9), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-35.9, 8.3, 22.9), Ang = Angle(0, 0, 0) }
	},
}