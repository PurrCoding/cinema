module("Location", package.seeall)

local IsValid = IsValid
local Vector, CurTime = Vector, CurTime
local ipairs, pairs = ipairs, pairs
local string_lower = string.lower
local string_format = string.format
local string_rep = string.rep
local math_floor = math.floor
local table_insert = table.insert
local table_Count = table.Count
local table_remove = table.remove
local game_GetMap = game.GetMap

Debug = false
Maps = {}

local LocationCache = {}           -- Index -> {name, data}
local LocationNameCache = {}       -- Index -> name string
local PlayersByLocation = {}       -- Index -> {player1, player2, ...}
local SpatialGrid = {}            -- "x,y" -> {locations in cell}
local GridSize = 512              -- Configurable grid size
local CurrentMapLocations = nil

-- Player movement tracking
local PlayerLocationCache = {}

-- Debug statistics tracking
local DebugStats = {
	cacheHits = 0,
	cacheMisses = 0,
	spatialGridHits = 0,
	spatialGridMisses = 0,
	playerMovementChecks = 0,
	playerMovementSkips = 0,
	lastResetTime = CurTime()
}

-- Pre-compute all optimization structures
local function PrecomputeAllCaches()
	if not CurrentMapLocations then return end

	-- Clear existing caches
	LocationCache = {}
	LocationNameCache = {}
	PlayersByLocation = {}
	SpatialGrid = {}

	if Debug then
		MsgN("Location: Pre-computing caches for ", table_Count(CurrentMapLocations), " locations")
	end

	-- Pre-compute location caches
	for name, loc in pairs(CurrentMapLocations) do
		LocationCache[loc.Index] = {name = name, data = loc}
		LocationNameCache[loc.Index] = name
		PlayersByLocation[loc.Index] = {}

		-- Pre-compute spatial grid
		local minX, minY = math_floor(loc.Min.x / GridSize), math_floor(loc.Min.y / GridSize)
		local maxX, maxY = math_floor(loc.Max.x / GridSize), math_floor(loc.Max.y / GridSize)

		for x = minX, maxX do
			for y = minY, maxY do
				local key = x .. "," .. y
				SpatialGrid[key] = SpatialGrid[key] or {}
				table_insert(SpatialGrid[key], {name = name, data = loc})
			end
		end
	end

	if Debug then
		MsgN("Location: Spatial grid created with ", table_Count(SpatialGrid), " cells")
	end
end

-- Add locations with pre-computation
function Add(strName, tblMap)
	-- Build indexes (existing functionality)
	local idx = 1
	for k, v in pairs(tblMap) do
		v.Index = idx
		idx = idx + 1
	end

	local mapTbl = {
		Name = strName,
		Locations = tblMap,
	}

	if Debug then
		MsgN("Adding locations for: ", strName, " # locations: ", idx - 1)
	end

	table_insert(Maps, mapTbl)

	-- Pre-compute all caches for current map
	if strName == string_lower(game_GetMap()) then
		CurrentMapLocations = tblMap
		PrecomputeAllCaches()
	end
end

-- Get locations with caching
function GetLocations(strMap)
	if not strMap then
		strMap = game_GetMap()
	end

	strMap = string_lower(strMap)

	-- Use cached current map locations
	if strMap == string_lower(game_GetMap()) and CurrentMapLocations then
		return CurrentMapLocations
	end

	for _, v in pairs(Maps) do
		if v.Name == strMap then
			if strMap == string_lower(game_GetMap()) then
				CurrentMapLocations = v.Locations
				PrecomputeAllCaches()
			end
			return v.Locations
		end
	end
end

-- Returns the location string of the index
function GetLocationNameByIndex(iIndex)
	return LocationNameCache[iIndex] or "Unknown"
end

-- Find a location by index
-- indexes get networked
function GetLocationByIndex(iIndex, strMap)
	if not strMap and LocationCache[iIndex] then
		return LocationCache[iIndex].data
	end

	-- Fallback for different maps
	local locations = GetLocations(strMap)
	if not locations then return end

	for k, v in pairs(locations) do
		if v.Index == iIndex then return v end
	end
end

-- find a location by name
function GetLocationByName(strName, strMap)
	local locations = GetLocations(strMap)
	if not locations then return end
	return locations[strName]
end

function GetPlayersInLocation(iIndex)
	return PlayersByLocation[iIndex] or {}
end

-- Update player location with cache maintenance
local function UpdatePlayerLocation(ply, steamID, oldLocation, newLocation, pos)
	-- Remove from old location
	if oldLocation ~= 0 and PlayersByLocation[oldLocation] then
		for i, p in ipairs(PlayersByLocation[oldLocation]) do
			if p == ply then
				table_remove(PlayersByLocation[oldLocation], i)
				break
			end
		end
	end

	-- Add to new location
	if newLocation ~= 0 then
		PlayersByLocation[newLocation] = PlayersByLocation[newLocation] or {}
		table_insert(PlayersByLocation[newLocation], ply)
	end

	-- Update player cache with timestamp
	PlayerLocationCache[steamID] = {
		location = newLocation,
		lastPos = Vector(pos.x, pos.y, pos.z),
		lastUpdate = CurTime()
	}
end

-- returns the index of the player's current location
function Find(ply)
	if not IsValid(ply) then return 0 end

	DebugStats.playerMovementChecks = DebugStats.playerMovementChecks + 1

	local pos = ply:GetPos()
	local steamID = ply:SteamID()
	local oldLocation = PlayerLocationCache[steamID] and PlayerLocationCache[steamID].location or 0

	-- Check movement threshold (10 unit threshold)
	local lastPos = PlayerLocationCache[steamID] and PlayerLocationCache[steamID].lastPos
	if lastPos and pos:DistToSqr(lastPos) < 100 then
		DebugStats.cacheHits = DebugStats.cacheHits + 1
		DebugStats.playerMovementSkips = DebugStats.playerMovementSkips + 1
		return oldLocation
	end

	DebugStats.cacheMisses = DebugStats.cacheMisses + 1

	-- Find new location using spatial grid
	local gridX, gridY = math_floor(pos.x / GridSize), math_floor(pos.y / GridSize)
	local gridKey = gridX .. "," .. gridY
	local candidates = SpatialGrid[gridKey]
	local newLocation = 0

	if candidates then
		DebugStats.spatialGridHits = DebugStats.spatialGridHits + 1
		for _, candidate in ipairs(candidates) do
			if pos:InBox(candidate.data.Min, candidate.data.Max) then
				newLocation = candidate.data.Index
				break
			end
		end
	else
		DebugStats.spatialGridMisses = DebugStats.spatialGridMisses + 1
	end

	-- Update player location tracking
	UpdatePlayerLocation(ply, steamID, oldLocation, newLocation, pos)

	return newLocation
end

-- Teleport functions
local function GetTeleportBy(func, nameOrIndex, strMap)
	local tblLoc = func(nameOrIndex, strMap)

	if not tblLoc then
		if SERVER then
			Sql.Log("location", "Tried to get teleport for invalid location \"" .. nameOrIndex .. "\" on map \"" .. strMap .. "\"!")
		end
		return
	end

	if not tblLoc.Teleports then
		if SERVER then
			Sql.Log("location", "Tried to get a teleport for a location \"" .. nameOrIndex .. "\" on map \"" .. strMap .. "\" without any registered teleports!")
		end
		return (tblLoc.Max + tblLoc.Min) / 2
	end

	return table.Random(tblLoc.Teleports)
end

function GetTeleportByName(strName, strMap)
	return GetTeleportBy(GetLocationByName, strName, strMap)
end

function GetTeleportByIndex(iIndex, strMap)
	return GetTeleportBy(GetLocationByIndex, iIndex, strMap)
end

function GetSpatialGrid()
	return SpatialGrid, GridSize
end

-- Server-side cleanup and debug commands
if SERVER then
	-- Clean up when players disconnect
	hook.Add("PlayerDisconnected", "LocationCacheCleanup", function(ply)
		local steamID = ply:SteamID()
		local cachedData = PlayerLocationCache[steamID]

		if cachedData and cachedData.location ~= 0 then
			local locationPlayers = PlayersByLocation[cachedData.location]
			if locationPlayers then
				for i, p in ipairs(locationPlayers) do
					if p == ply then
						table_remove(locationPlayers, i)
						break
					end
				end
			end
		end

		PlayerLocationCache[steamID] = nil
	end)

	-- Debug command for comprehensive system analysis
	concommand.Add("cinema_location_debug", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsSuperAdmin() then
			return
		end

		local function PrintSeparator()
			print("=" .. string_rep("=", 60))
		end

		local function PrintHeader(title)
			PrintSeparator()
			print("  " .. title)
			PrintSeparator()
		end

		-- Performance Statistics
		PrintHeader("LOCATION SYSTEM PERFORMANCE STATS")

		local uptime = CurTime() - DebugStats.lastResetTime
		local totalChecks = DebugStats.playerMovementChecks
		local cacheHitRate = totalChecks > 0 and (DebugStats.cacheHits / totalChecks * 100) or 0
		local spatialHitRate = (DebugStats.spatialGridHits + DebugStats.spatialGridMisses) > 0 and
							  (DebugStats.spatialGridHits / (DebugStats.spatialGridHits + DebugStats.spatialGridMisses) * 100) or 0

		print(string_format("Uptime: %.2f seconds", uptime))
		print(string_format("Total Movement Checks: %d (%.2f/sec)", totalChecks, uptime > 0 and (totalChecks / uptime) or 0))
		print(string_format("Cache Hits: %d (%.1f%%)", DebugStats.cacheHits, cacheHitRate))
		print(string_format("Cache Misses: %d (%.1f%%)", DebugStats.cacheMisses, 100 - cacheHitRate))
		print(string_format("Movement Skips: %d (%.1f%%)", DebugStats.playerMovementSkips,
						   totalChecks > 0 and (DebugStats.playerMovementSkips / totalChecks * 100) or 0))
		print(string_format("Spatial Grid Hits: %d (%.1f%%)", DebugStats.spatialGridHits, spatialHitRate))
		print(string_format("Spatial Grid Misses: %d (%.1f%%)", DebugStats.spatialGridMisses, 100 - spatialHitRate))

		-- Per-Player Statistics
		PrintHeader("PER-PLAYER LOCATION DATA")

		for _, ply in pairs(player.GetAll()) do
			if IsValid(ply) then
				local steamID = ply:SteamID()
				local cachedData = PlayerLocationCache[steamID]
				local currentLoc = ply:GetLocation() and ply:GetLocation() or 0

				local status = "VALID"
				local lastUpdate = "Never"
				local distance = "N/A"

				if cachedData then
					local timeSinceUpdate = CurTime() - (cachedData.lastUpdate or 0)
					lastUpdate = string_format("%.2fs ago", timeSinceUpdate)

					if cachedData.lastPos then
						distance = string_format("%.1f units", ply:GetPos():Distance(cachedData.lastPos))
					end

					-- Check if cache is stale
					if timeSinceUpdate > 5 then
						status = "STALE"
					elseif cachedData.location ~= currentLoc then
						status = "DESYNC"
					end
				else
					status = "NO_CACHE"
				end

				print(string_format("Player: %s [%s]", ply:Name(), steamID))
				print(string_format("  Current Location: %d (%s)", currentLoc,
								   GetLocationNameByIndex(currentLoc)))
				print(string_format("  Cached Location: %d", cachedData and cachedData.location or 0))
				print(string_format("  Cache Status: %s", status))
				print(string_format("  Last Update: %s", lastUpdate))
				print(string_format("  Distance Moved: %s", distance))
				print("")
			end
		end

		-- Per-Location Statistics
		PrintHeader("PER-LOCATION STATISTICS")

		local totalLocations = 0
		local occupiedLocations = 0

		for index, locationData in pairs(LocationCache) do
			totalLocations = totalLocations + 1
			local playersInLocation = PlayersByLocation[index] or {}
			local playerCount = #playersInLocation

			if playerCount > 0 then
				occupiedLocations = occupiedLocations + 1
				print(string_format("Location %d: %s", index, locationData.name))
				print(string_format("  Players: %d", playerCount))

				for i, ply in ipairs(playersInLocation) do
					if IsValid(ply) then
						print(string_format("    - %s", ply:Name()))
					else
						print(string_format("    - [INVALID PLAYER REFERENCE]"))
					end
				end
				print("")
			end
		end

		print(string_format("Total Locations: %d", totalLocations))
		print(string_format("Occupied Locations: %d", occupiedLocations))
		print(string_format("Empty Locations: %d", totalLocations - occupiedLocations))

		-- Cache Validation
		PrintHeader("CACHE VALIDATION")

		local validCaches = 0
		local invalidCaches = 0
		local staleCaches = 0

		for steamID, cachedData in pairs(PlayerLocationCache) do
			local ply = player.GetBySteamID(steamID)

			if IsValid(ply) then
				local actualLocation = 0
				local pos = ply:GetPos()

				-- Manually check actual location
				for _, candidate in pairs(SpatialGrid[math_floor(pos.x / GridSize) .. "," .. math_floor(pos.y / GridSize)] or {}) do
					if pos:InBox(candidate.data.Min, candidate.data.Max) then
						actualLocation = candidate.data.Index
						break
					end
				end

				if cachedData.location == actualLocation then
					validCaches = validCaches + 1
				else
					invalidCaches = invalidCaches + 1
					print(string_format("INVALID: %s - Cached: %d, Actual: %d",
									   ply:Name(), cachedData.location, actualLocation))
				end

				-- Check for stale data
				if cachedData.lastPos and pos:DistToSqr(cachedData.lastPos) > 10000 then -- 100 units
					staleCaches = staleCaches + 1
				end
			else
				invalidCaches = invalidCaches + 1
				print(string_format("ORPHANED: SteamID %s has cached data but no valid player", steamID))
			end
		end

		print(string_format("Valid Caches: %d", validCaches))
		print(string_format("Invalid Caches: %d", invalidCaches))
		print(string_format("Stale Caches: %d", staleCaches))

		-- System Health
		PrintHeader("SYSTEM HEALTH")

		local gridCells = 0
		local emptyGridCells = 0
		for key, candidates in pairs(SpatialGrid) do
			gridCells = gridCells + 1
			if #candidates == 0 then
				emptyGridCells = emptyGridCells + 1
			end
		end

		print(string_format("Spatial Grid Cells: %d", gridCells))
		print(string_format("Empty Grid Cells: %d", emptyGridCells))
		print(string_format("Grid Efficiency: %.1f%%", gridCells > 0 and ((gridCells - emptyGridCells) / gridCells * 100) or 0))
		print(string_format("Memory Usage (approx): %.2f KB",
						   (table_Count(LocationCache) * 100 + table_Count(PlayerLocationCache) * 50 + gridCells * 20) / 1024))

		PrintSeparator()
	end)

	-- Reset statistics command
	concommand.Add("cinema_location_debug_reset", function(ply, cmd, args)
		if not IsValid(ply) or not ply:IsSuperAdmin() then
			return
		end

		DebugStats = {
			cacheHits = 0,
			cacheMisses = 0,
			spatialGridHits = 0,
			spatialGridMisses = 0,
			playerMovementChecks = 0,
			playerMovementSkips = 0,
			lastResetTime = CurTime()
		}

		print("Location system debug statistics reset.")
	end)
end