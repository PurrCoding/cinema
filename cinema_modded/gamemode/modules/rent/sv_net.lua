module("rent", package.seeall)

util.AddNetworkString("PromptRental")
util.AddNetworkString("RentTheater")
util.AddNetworkString("RentInfo")
util.AddNetworkString("RefundRent")
util.AddNetworkString("CancelRent")
util.AddNetworkString("GetPlayerFilter")
util.AddNetworkString("SetPlayerFilter")
util.AddNetworkString("ToggleVoteSkipLock")

-- Max distinct SteamIDs a filter may contain. Tune to taste.
local FILTER_MAX_PLAYERS = 128

-- Client sends standard SteamIDs (STEAM_0:0:12345 / STEAM_1:1:12345)
local function isValidSteamID(str)
	return isstring(str) and string.match(str, "^STEAM_[0-5]:[01]:%d+$") ~= nil
end

-- Outgoing

function PromptRental(ply)
	net.Start("PromptRental")
	net.Send(ply)
end

function SendRentInfo(thtr, ply)
	local rentInfo = {
		id = thtr:GetLocation(),
		timeRemaining = thtr:GetRemainingRentTime(),
		owner = thtr:GetOwner()
	}

	net.Start("RentInfo")
	net.WriteTable(rentInfo)
	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

-- Incoming

net.Receive("RentTheater", function(len, ply)
	if not IsValid(ply) then return end
	local rentLength = net.ReadUInt(16)
	rent.RentTheater(ply, rentLength)
end)

net.Receive("RefundRent", function(len, ply)
	if not IsValid(ply) then return end
	rent.RefundRent(ply)
end)

net.Receive("CancelRent", function(len, ply)
	if not IsValid(ply) then return end
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

	local thtr = ply:GetTheater()
	if not thtr then
		theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterSeeFilter" })
	elseif ply ~= thtr:GetOwner() and not ply:IsAdmin() then
		theater.SendAnnouncement(ply, { "Rent_NotOwnerSeeFilter" })
	else
		net.Start("GetPlayerFilter")
		net.WriteTable(thtr:GetPlayerFilter())
		net.Send(ply)
	end
end)

net.Receive("ToggleVoteSkipLock", function(len, ply)
	if not IsValid(ply) then return end

	local thtr = ply:GetTheater()
	if not thtr then
		theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterVoteLock" })
	elseif ply ~= thtr:GetOwner() and not ply:IsAdmin() then
		theater.SendAnnouncement(ply, { "Rent_NotOwnerVoteLock" })
	else
		thtr:SetVoteSkipLocked(not thtr:VoteSkipLocked())
	end
end)