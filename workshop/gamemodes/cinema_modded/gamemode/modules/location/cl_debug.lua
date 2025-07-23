--[[

	Original debug system from the old 
	GMod Tower code, credits go to Void.

	Now with Spatial grid visualization!

]]

module( "Location", package.seeall )

local math_Round = math.Round
local math_floor = math.floor
local string_format = string.format
local pairs = pairs
local ipairs = ipairs
local LocalPlayer = LocalPlayer
local Color = Color

DebugEnabled = CreateClientConVar( "cinema_debug_locations", "0", false, false )
DebugGridEnabled = CreateClientConVar( "cinema_debug_grid", "0", false, false )

DebugLocStart = nil
DebugLocEnd = nil

-- we use this so that the bottom of a box will be lower than the player's position
FootOffset = Vector( 0, 0, -5 )

--[[
	Location editing utilities

	These two concommands are designed to simplify location creation.
	Simply run cinema_loc_start, move to create a desired box, then run cinema_loc_end and grab the lua printed to the console.
	This requires you to be an admin!
]]

concommand.Add( "cinema_loc_start", function( ply, cmd, args )
	if not ply:IsAdmin() then return end

	DebugLocStart = LocalPlayer():GetPos() + FootOffset

	hook.Add( "PostDrawTranslucentRenderables", "CinemaDebugLocation", function()
		Debug3D.DrawBox( DebugLocStart, LocalPlayer():GetPos() )
	end	)

end )

concommand.Add( "cinema_loc_end", function ( ply, cmd, args )
	if not ply:IsAdmin() then return end

	DebugLocEnd = LocalPlayer():GetPos() + FootOffset
	hook.Remove( "PostDrawTranslucentRenderables", "CinemaDebugLocation" )

	local min = DebugLocStart
	local max = DebugLocEnd

	if ( min:Length() > max:Length() ) then
		local temp = min
		min = max
		max = temp
	end

	OrderVectors( min, max )

	local locstr = "[ \"Name\" ] =\n"
	locstr = locstr .. "{\n"
	locstr = locstr .. "\tMin = Vector( " .. min.x .. ", " .. min.y .. ", " .. min.z .. " ),\n"
	locstr = locstr .. "\tMax = Vector( " .. max.x .. ", " .. max.y .. ", " .. max.z .. " ),\n"
	locstr = locstr .. "},\n"

	SetClipboardText( locstr )
	MsgN( locstr )
	MsgN( "The above location has been copied to your clipboard." )

end )

concommand.Add( "cinema_loc_vector", function ( ply, cmd, args )
	if not ply:IsAdmin() then return end
	local pos = LocalPlayer():GetPos()
	local posstr = "Vector( " .. math_Round(pos.x) .. ", " .. math_Round(pos.y) .. ", " .. math_Round(pos.z) .. " ),"
	SetClipboardText( posstr )
	MsgN( posstr )
	MsgN( "The above position has been copied to your clipboard." )
end )

-- Spatial grid visualization function
local function DrawSpatialGrid()
	if not DebugGridEnabled:GetBool() then return end

	local spatialGrid, gridSize = GetSpatialGrid()
	if not spatialGrid or not gridSize then return end

	local playerPos = LocalPlayer():GetPos()
	local playerGridX = math_floor(playerPos.x / gridSize)
	local playerGridY = math_floor(playerPos.y / gridSize)

	-- Draw grid cells around player
	local renderDistance = 3 -- Show 3x3 grid around player

	for x = playerGridX - renderDistance, playerGridX + renderDistance do
		for y = playerGridY - renderDistance, playerGridY + renderDistance do
			local key = x .. "," .. y
			local candidates = spatialGrid[key]

			if candidates and #candidates > 0 then
				-- Calculate grid cell bounds
				local minX, minY = x * gridSize, y * gridSize
				local maxX, maxY = (x + 1) * gridSize, (y + 1) * gridSize

				-- Use different colors based on location count in cell
				local cellColor = Color(0, 255, 0, 50) -- Green for populated cells
				if #candidates > 3 then
					cellColor = Color(255, 255, 0, 50) -- Yellow for busy cells
				elseif #candidates > 6 then
					cellColor = Color(255, 0, 0, 50) -- Red for very busy cells
				end

				-- Draw grid cell outline
				local cellMin = Vector(minX, minY, playerPos.z - 100)
				local cellMax = Vector(maxX, maxY, playerPos.z + 100)

				Debug3D.DrawBox(cellMin, cellMax, cellColor)

				-- Draw cell info
				local cellCenter = Vector((minX + maxX) / 2, (minY + maxY) / 2, playerPos.z + 50)
				local cellText = string_format("Grid [%d,%d]\n%d locations", x, y, #candidates)
				Debug3D.DrawText(cellCenter, cellText, "VideoInfoSmall", Color(255, 255, 255, 255), 0.5)

				-- Draw location names in cell
				for i, candidate in ipairs(candidates) do
					if i <= 3 then -- Limit to first 3 to avoid clutter
						local textPos = Vector(cellCenter.x, cellCenter.y, cellCenter.z - (i * 20))
						Debug3D.DrawText(textPos, candidate.name, "VideoInfoSmall", Color(200, 200, 255, 255), 0.3)
					end
				end
			else
				-- Draw empty grid cells with different color
				local minX, minY = x * gridSize, y * gridSize
				local maxX, maxY = (x + 1) * gridSize, (y + 1) * gridSize

				local cellMin = Vector(minX, minY, playerPos.z - 50)
				local cellMax = Vector(maxX, maxY, playerPos.z + 50)

				Debug3D.DrawBox(cellMin, cellMax, Color(100, 100, 100, 20)) -- Gray for empty cells
			end
		end
	end

	-- Draw player's current grid cell highlight
	local playerKey = playerGridX .. "," .. playerGridY
	local playerMinX, playerMinY = playerGridX * gridSize, playerGridY * gridSize
	local playerMaxX, playerMaxY = (playerGridX + 1) * gridSize, (playerGridY + 1) * gridSize

	local playerCellMin = Vector(playerMinX, playerMinY, playerPos.z - 150)
	local playerCellMax = Vector(playerMaxX, playerMaxY, playerPos.z + 150)

	Debug3D.DrawBox(playerCellMin, playerCellMax, Color(255, 255, 255, 100)) -- White highlight for player cell
end

-- location visualizer for debugging
hook.Add( "PostDrawTranslucentRenderables", "CinemaDebugLocations", function ()

	if ( not DebugEnabled:GetBool() ) then
		-- Still check for grid rendering even if locations are disabled
		DrawSpatialGrid()
		return
	end

	-- Draw spatial grid if enabled
	DrawSpatialGrid()

	for k, v in pairs( GetLocations() or {} ) do

		local center = ( v.Min + v.Max ) / 2

		Debug3D.DrawBox( v.Min, v.Max )
		Debug3D.DrawText( center, k, "VideoInfoSmall" )

		if ( not v.Teleports ) then continue end

		for _, tele in ipairs( v.Teleports ) do

			local min = tele + Vector( -20, -20, 0 )
			local max = tele + Vector( 20, 20, 80 )
			local center = ( min + max ) / 2

			local text = k .. "\nTeleport"

			Debug3D.DrawBox( min, max, Color( 0, 255, 0, 255 ) )
			Debug3D.DrawText( center, text, "VideoInfoSmall", Color( 50, 255, 50, 255 ), 0.25 )

		end
	end

end )