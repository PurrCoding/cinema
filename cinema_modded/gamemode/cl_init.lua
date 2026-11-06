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

-- Chat colors
ColDefault = Color( 200, 200, 200 )
ColHighlight = Color( 158, 37, 33 )

include( "shared.lua" )

--[[
	Unsupported Notifications
]]
hook.Add( "InitPostEntity", "CheckMapSupport", function()

	if Location then

		hook.Run( "CinemaRegisterMap", Location )

		if not Location.GetLocations() then

			warning.Set(
				translations:Format("Warning_Unsupported_Line1"),
				translations:Format("Warning_Unsupported_Line2")
			)

			control.Add( KEY_F1, function( enabled, held )
				if enabled and not held then
					steamworks.ViewFile( 119060917 )
				end
			end )

		end

	else
		warning.Clear()
	end

end )

--[[
	HUD Elements to hide
--]]
GM.HUDToHide = {
	["CHudHealth"] = true,
	["CHudSuitPower"] = true,
	["CHudBattery"] = true,
	["CHudCrosshair"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudZoom"] = true
}

local LocalPlayer = LocalPlayer
local IsValid = IsValid

--[[---------------------------------------------------------
   Name: gamemode:HUDShouldDraw( name )
   Desc: return true if we should draw the named element
-----------------------------------------------------------]]
function GM:HUDShouldDraw( name )

	-- Allow the weapon to override this
	local ply = LocalPlayer()
	if ( IsValid( ply ) ) then

		local wep = ply:GetActiveWeapon()

		if ( IsValid( wep ) and wep.HUDShouldDraw ) then

			return wep:HUDShouldDraw( name )

		end

		-- If Sandbox is loaded, draw HUD outside of the theater.
		if ( self.IsSandboxDerived and not ply:InTheater() ) then

			return true

		end

	end

	return not self.HUDToHide[name]
end

--[[---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
function GM:HUDPaint()

	hook.Run( "HUDDrawTargetID" )
	-- hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )

end

--[[---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
function GM:HUDDrawTargetID()
	return false
end

--[[---------------------------------------------------------
   Name: CalcView
   Allows override of the default view
-----------------------------------------------------------]]
function GM:CalcView( ply, origin, angles, fov, znear, zfar )

	local Vehicle	= ply:GetVehicle()
	local Weapon	= ply:GetActiveWeapon()

	local view = {}
	view.origin 		= origin
	view.angles			= angles
	view.fov 			= fov
	view.znear			= znear
	view.zfar			= zfar
	view.drawviewer		= false

	--
	-- Let the vehicle override the view
	--
	if ( IsValid( Vehicle ) ) then return hook.Run( "CalcVehicleView", Vehicle, ply, view ) end

	--
	-- Let drive possibly alter the view
	--
	if ( drive.CalcView( ply, view ) ) then return view end

	--
	-- Give the player manager a turn at altering the view
	--
	player_manager.RunClass( ply, "CalcView", view )

	-- Give the active weapon a go at changing the viewmodel position

	if ( IsValid( Weapon ) ) then

		local func = Weapon.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( Weapon, origin * 1, angles * 1 ) -- Note: *1 to copy the object so the child function can't edit it.
		end

		local func = Weapon.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( Weapon, ply, origin * 1, angles * 1, fov ) -- Note: *1 to copy the object so the child function can't edit it.
		end

	end

	return view

end

--
-- If return true: 		Will draw the local player
-- If return false: 	Won't draw the local player
-- If return nil:	 	Will carry out default action
--
function GM:ShouldDrawLocalPlayer( ply )
	return player_manager.RunClass( ply, "ShouldDrawLocal" )
end

--[[---------------------------------------------------------
   Name: gamemode:CreateMove( command )
   Desc: Allows the client to change the move commands
			before it's send to the server
-----------------------------------------------------------]]
function GM:CreateMove( cmd )
	if ( player_manager.RunClass( LocalPlayer(), "CreateMove", cmd ) ) then return true end
end
