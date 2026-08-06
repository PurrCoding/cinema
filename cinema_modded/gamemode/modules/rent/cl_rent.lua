module("rent", package.seeall)

Rentals = Rentals or {}

function GetOwner(id)
	return Rentals[id] and Rentals[id].owner or nil
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
	local rentInfo = net.ReadTable()

	if rentInfo.timeRemaining == 0 then
		rent.Rentals[rentInfo.id] = nil
	else
		rent.Rentals[rentInfo.id] = {
			expirationTime = CurTime() + rentInfo.timeRemaining,
			owner = rentInfo.owner
		}
	end
end)

net.Receive("GetPlayerFilter", function()
	rent.PopulatePlayerFilter(net.ReadTable())
end)
