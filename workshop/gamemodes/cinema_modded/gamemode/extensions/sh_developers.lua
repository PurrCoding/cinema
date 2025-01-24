local PlayerMeta = FindMetaTable("Player")
if not PlayerMeta then return end

local Developers = {
	["STEAM_0:0:0"] = true,			-- Lua refresh error

	-- PixelTail Games
	["STEAM_0:1:6044247"] = true,	-- MacDGuy
	["STEAM_0:1:18712009"] = true,	-- Foohy
	["STEAM_0:1:15862026"] = true,	-- Sam
	["STEAM_0:0:5129735"] = true,	-- Mr. Sunabouzu
	["STEAM_0:0:15339565"] = true,	-- Clopsy
	["STEAM_0:1:4556804"] = true,	-- Azuisleet

	-- Active Maintainer
	["STEAM_0:1:75888605"] = true,	-- Shadowsun
}

function PlayerMeta:IsGamemodeDev()
	if not IsValid(self) then return false end
	return Developers[self:SteamID()] or false
end