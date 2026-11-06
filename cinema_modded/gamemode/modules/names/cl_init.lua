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

surface.CreateFont( "3D2DName", { font = "Bebas Neue", size = 135, weight = 600 } )

local function DrawName( ply, opacityScale )

	if not IsValid(ply) or not ply:Alive() then return end

	local pos = ply:GetPos()
	local ang = LocalPlayer():EyeAngles()

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	if ply:InVehicle() then
		pos = pos + Vector( 0, 0, 30 )
	else
		pos = pos + Vector( 0, 0, 60 )
	end

	local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )
	if ( dist >= 800 ) then return end --no need to draw anything if the player is far away

	local opacity = math.Clamp( 310.526 - ( 0.394737 * dist ), 0, 150 ) --woot mathematica

	opacityScale = opacityScale and opacityScale or 1
	opacity = opacity * opacityScale

	local name = "  " .. string.upper( ply:GetName() )

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.15 )

		-- render.OverrideDepthEnable(false, true)

		draw.TheaterText( name, "3D2DName", 50, 0, Color( 255, 255, 255, opacity ) )

		-- render.OverrideDepthEnable(false, false)

	cam.End3D2D()

end

local HUDTargets = {}
local fadeTime = 2
hook.Add( "PostDrawTranslucentRenderables", "DrawPlayerNames", function()

	-- Don't render names while we're sitting down
	if GetConVar("cinema_drawnames") and not GetConVar("cinema_drawnames"):GetBool() then return end
	if not LocalPlayer().InTheater then return end
	if theater.Fullscreen then return end
	if IsValid( LocalPlayer():GetVehicle() ) then return end

	-- Draw lower opacity and recently targetted players in theater
	if LocalPlayer():InTheater() then

		for ply, time in pairs(HUDTargets) do

			if time < RealTime() then
				HUDTargets[ply] = nil
				continue
			end

			-- Fade over time
			DrawName( ply, 0.11 * ((time - RealTime()) / fadeTime) )

		end

		local tr = util.GetPlayerTrace( LocalPlayer() )
		local trace = util.TraceLine( tr )
		if (not trace.Hit) then return end
		if (not trace.HitNonWorld) then return end

		-- Keep track of recently targetted players
		if trace.Entity:IsPlayer() then
			HUDTargets[trace.Entity] = RealTime() + fadeTime
		elseif trace.Entity:IsVehicle() and
			IsValid(trace.Entity:GetOwner()) and
			trace.Entity:GetOwner():IsPlayer() then
			HUDTargets[trace.Entity:GetOwner()] = RealTime() + fadeTime
		end

	else -- draw all players names

		for _, ply in pairs( player.GetAll() ) do

			-- Don't draw name if either player is not in theater and the other is, etc.
			if (LocalPlayer():InTheater() and not ply:InTheater()) or
				(not LocalPlayer():InTheater() and ply:InTheater()) then
				continue
			end

			if ply ~= LocalPlayer() then
				DrawName( ply )
			end
		end

	end

end )