module("rent", package.seeall)

Rentals = Rentals or {}

local function findPlayerBySteamID(steamID)
	if not steamID or steamID == "" then return nil end
	for _, ply in ipairs(player.GetAll()) do
		if ply:SteamID() == steamID then
			return ply
		end
	end
	return nil
end

function GetOwner(id)
	local entry = Rentals[id]
	if not entry then return nil end

	if IsValid(entry.owner) then
		return entry.owner
	end

	if entry.ownerSteamID then
		local ply = findPlayerBySteamID(entry.ownerSteamID)
		if IsValid(ply) then
			entry.owner = ply
			return ply
		end
	end

	return nil
end

function GetOwnerName(id)
	local owner = GetOwner(id)
	if IsValid(owner) then
		return owner:Nick()
	end

	local entry = Rentals[id]
	if entry and entry.ownerNick and entry.ownerNick ~= "" then
		return entry.ownerNick
	end

	return nil
end

function GetTimeRemaining(id)
	if Rentals[id] then
		-- Clamped: expiry can pass before the server broadcasts the new state.
		return math.max(0, Rentals[id].expirationTime - CurTime())
	else
		return 0
	end
end

function IsRented(id)
	return Rentals[id] ~= nil
end

function SetPlayerFilter(filterData)
	net.Start("SetPlayerFilter")
	net.WriteTable(filterData)
	net.SendToServer()
end

function RequestPlayerFilter()
	net.Start("GetPlayerFilter")
	net.SendToServer()
end

function PopulatePlayerFilter(filterData)
	if not IsValid(PlayerFilterWindow) then return end

	if filterData.whitelistMode ~= nil then
		if filterData.whitelistMode then
			PlayerFilterWindow.whitelistButton:SetText(translations:Format("Rent_WhitelistMode"))
			PlayerFilterWindow.whitelistButton.whitelistMode = true
		else
			PlayerFilterWindow.whitelistButton:SetText(translations:Format("Rent_BlacklistMode"))
			PlayerFilterWindow.whitelistButton.whitelistMode = false
		end

		for _, pnl in pairs(PlayerFilterWindow.playerList:GetItems()) do
			pnl:SetSelected(table.HasValue(filterData.players, pnl:GetPlayer():SteamID()))
		end
	end

	PlayerFilterWindow.loadingText:SetVisible(false)
	PlayerFilterWindow.whitelistButton:SetVisible(true)
	PlayerFilterWindow.playerList:SetVisible(true)
	PlayerFilterWindow.applyButton:SetVisible(true)
end

function ToggleVoteSkipLock()
	net.Start("ToggleVoteSkipLock")
	net.SendToServer()
end

function CancelRent()
	net.Start("CancelRent")
	net.SendToServer()
end

-- Announcement markers

-- Registered on Initialize because the theater module loads after this one.
hook.Add("Initialize", "Rent_RegisterCurrencyMarker", function()
	theater.RegisterMarkerResolver("currency", function(amount)
		return rent.FormatCost(amount, LocalPlayer())
	end)
end)

-- Networking

net.Receive("PromptRental", function()
	rent.CreateRentWindow()
end)

net.Receive("RentInfo", function()
	local id = net.ReadUInt(16)
	local timeRemaining = net.ReadFloat()
	local ownerSteamID = net.ReadString()
	local ownerNick = net.ReadString()

	if timeRemaining <= 0 or ownerSteamID == "" then
		rent.Rentals[id] = nil
	else
		rent.Rentals[id] = {
			expirationTime = CurTime() + timeRemaining,
			ownerSteamID = ownerSteamID,
			ownerNick = ownerNick,
			owner = findPlayerBySteamID(ownerSteamID)
		}
	end
end)

net.Receive("GetPlayerFilter", function()
	rent.PopulatePlayerFilter(net.ReadTable())
end)
