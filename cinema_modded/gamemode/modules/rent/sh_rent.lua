module("rent", package.seeall)

function CanAfford(ply, cost)
	local provider = rent.GetProvider(ply)
	if not provider then
		ErrorNoHalt("[Rent] Warning: No currency provider available!\n")
		return false
	end

	return provider.CanAfford(ply, cost)
end

function TakeMoney(ply, cost)
	local provider = rent.GetProvider(ply)
	if not provider then
		ErrorNoHalt("[Rent] Warning: No currency provider available!\n")
		return false
	end

	provider.Take(ply, cost)
end

function GiveMoney(ply, value)
	local provider = rent.GetProvider(ply)
	if not provider then
		ErrorNoHalt("[Rent] Warning: No currency provider available!\n")
		return false
	end

	provider.Give(ply, value)
end

function RentTheater(ply, length)
	if CLIENT then
		-- Unsigned 16-bit: supports 0..65535 minutes, no negative/overflow wrap.
		length = math.floor(math.Clamp(tonumber(length) or 0, 0, rent.MaximumRentTime()))

		net.Start("RentTheater")
		net.WriteUInt(length, 16)
		net.SendToServer()
	else
		if ply:InTheater() then
			if length >= rent.MinimumRentTime() then
				ply:GetTheater():RequestRent(ply, length)
			else
				theater.SendAnnouncement(ply, { "Rent_MinTime", rent.MinimumRentTime() })
			end
		else
			theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterRent" })
		end
	end
end

function RefundRent(ply)
	if CLIENT then
		net.Start("RefundRent")
		net.SendToServer()
	else
		if ply:InTheater() then
			ply:GetTheater():RefundRent(ply)
		else
			theater.SendAnnouncement(ply, { "Rent_MustBeInTheaterRefund" })
		end
	end
end

local function divideUpSeconds(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	seconds = math.floor(seconds % 60)

	return hours, minutes, seconds
end

function SecondsToTimer(seconds)
	local hours, minutes, secs = divideUpSeconds(seconds)
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end