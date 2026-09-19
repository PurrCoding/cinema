module("rent", package.seeall)

util.AddNetworkString("PromptRental")
util.AddNetworkString("RentTheater")
util.AddNetworkString("RentInfo")
util.AddNetworkString("RefundRent")
util.AddNetworkString("CancelRent")
util.AddNetworkString("GetPlayerFilter")
util.AddNetworkString("SetPlayerFilter")
util.AddNetworkString("ToggleVoteSkipLock")

-- Max distinct SteamIDs a filter may contain.
local FILTER_MAX_PLAYERS = 128

-- Per-player net rate limits (seconds between accepted messages).
local RATE_LIMITS = {
	RentTheater = 1.0,
	RefundRent = 1.0,
	CancelRent = 1.0,
	SetPlayerFilter = 2.0,
	GetPlayerFilter = 1.0,
	ToggleVoteSkipLock = 1.0,
}

local netCooldown = {} -- [steamID][action] = CurTime() when allowed again

local function isRateLimited(ply, action)
	if not IsValid(ply) then return true end

	local sid = ply:SteamID()
	local cooldown = RATE_LIMITS[action] or 1.0
	local now = CurTime()

	netCooldown[sid] = netCooldown[sid] or {}
	local allowedAt = netCooldown[sid][action] or 0

	if now < allowedAt then
		return true
	end

	netCooldown[sid][action] = now + cooldown
	return false
end

hook.Add("PlayerDisconnected", "Rent_ClearNetCooldown", function(ply)
	if not IsValid(ply) then return end
	netCooldown[ply:SteamID()] = nil
end)

-- Client sends standard SteamIDs (STEAM_0:0:12345 / STEAM_1:1:12345)
local function isValidSteamID(str)
	return isstring(str) and string.match(str, "^STEAM_[0-5]:[01]:%d+$") ~= nil
end

-- Outgoing

function PromptRental(ply)
	net.Start("PromptRental")
	net.Send(ply)
end

-- Structured RentInfo payload (no WriteTable):
--   UInt16 location id
--   Float  time remaining (0 = not rented)
--   String owner SteamID (empty if none)
--   String owner nick (empty if none)
function SendRentInfo(thtr, ply)
	local timeRemaining = 0
	local ownerSteamID = ""
	local ownerNick = ""

	if thtr:IsRented() then
		timeRemaining = thtr:GetRemainingRentTime()
		ownerSteamID = thtr:GetOwnerSteamID() or ""
		ownerNick = thtr:GetOwnerNick() or ""
	end

	net.Start("RentInfo")
	net.WriteUInt(thtr:GetLocation(), 16)
	net.WriteFloat(timeRemaining)
	net.WriteString(ownerSteamID)
	net.WriteString(ownerNick)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

-- Incoming

net.Receive("RentTheater", function(len, ply)
	if not IsValid(ply) then return end
	if isRateLimited(ply, "RentTheater") then return end

	local rentLength = net.ReadUInt(16)
	rent.RentTheater(ply, rentLength)
end)

net.Receive("RefundRent", function(len, ply)
	if not IsValid(ply) then return end
	if isRateLimited(ply, "RefundRent") then return end

	rent.RefundRent(ply)
end)

net.Receive("CancelRent", function(len, ply)
	if not IsValid(ply) then return end
	if isRateLimited(ply, "CancelRent") then return end
	if not ply:IsAdmin() then return end

	local thtr = ply:GetTheater()
	if not thtr then
		theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterCancel" })
	else
		thtr:CancelRent(ply)
	end
end)

net.Receive("SetPlayerFilter", function(len, ply)
	if not IsValid(ply) then return end
	if isRateLimited(ply, "SetPlayerFilter") then return end

	local raw = net.ReadTable()
	local thtr = ply:GetTheater()
	if not thtr then
		theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterFilter" })
		return
	end

	if not istable(raw) then return end

	-- Rebuild a clean payload; never trust the incoming table structure.
	local cleaned = {
		whitelistMode = raw.whitelistMode == true,
		players = {}
	}

	if istable(raw.players) then
		local seen = {}
		for _, sid in ipairs(raw.players) do
			if #cleaned.players >= FILTER_MAX_PLAYERS then break end
			if isValidSteamID(sid) and not seen[sid] then
				seen[sid] = true
				table.insert(cleaned.players, sid)
			end
		end
	end

	thtr:SetPlayerFilter(ply, cleaned)
end)

net.Receive("GetPlayerFilter", function(len, ply)
	if not IsValid(ply) then return end
	if isRateLimited(ply, "GetPlayerFilter") then return end

	local thtr = ply:GetTheater()
	if not thtr then
		theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterSeeFilter" })
	elseif not thtr:IsOwner(ply) and not ply:IsAdmin() then
		theater.SendAnnouncement(ply, { "Rent_NotOwnerSeeFilter" })
	else
		net.Start("GetPlayerFilter")
		net.WriteTable(thtr:GetPlayerFilter())
		net.Send(ply)
	end
end)

net.Receive("ToggleVoteSkipLock", function(len, ply)
	if not IsValid(ply) then return end
	if isRateLimited(ply, "ToggleVoteSkipLock") then return end

	local thtr = ply:GetTheater()
	if not thtr then
		theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterVoteLock" })
	elseif not thtr:IsOwner(ply) and not ply:IsAdmin() then
		theater.SendAnnouncement(ply, { "Rent_NotOwnerVoteLock" })
	else
		thtr:SetVoteSkipLocked(not thtr:VoteSkipLocked())
	end
end)
