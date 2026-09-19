local function postEnterTheater(ply, thtr)
	if thtr:IsPrivate() then
		if not thtr:IsRented() then
			if rent.PreventUnrentedActivity() then
				rent.PromptRental(ply)
			end
		else
			if thtr:IsOwner(ply) then
				thtr:AnnounceToPlayer(ply, {
					"Rent_CurrentlyRentingSelf",
					theater.Duration(thtr:GetRemainingRentTime())
				})
			else
				thtr:AnnounceToPlayer(ply, {
					"Rent_CurrentlyRentedBy",
					thtr:GetOwnerNick() or "?",
					theater.Duration(thtr:GetRemainingRentTime())
				})
			end
		end
	end
end
hook.Add("PostPlayerEnterTheater", "Rent_PostEnterTheater", postEnterTheater)

local function preVideoQueued(video, thtr)
	if rent.PreventUnrentedActivity() and thtr:IsPrivate() and not thtr:IsRented() then
		thtr:AnnounceToPlayer(video:GetOwner(), { "Rent_MustBeRented" })
		return false
	end
end
hook.Add("PreVideoQueued", "Rent_PreVideoQueued", preVideoQueued)

local function prePlayVideo(video, thtr)
	if rent.PreventUnrentedActivity() and thtr:IsPrivate() and not thtr:IsRented() then
		return false
	end
end
hook.Add("PrePlayVideo", "Rent_PrePlayVideo", prePlayVideo)

local function prePlayerEnterTheater(ply, thtr)
	if thtr:IsPrivate() and thtr:IsRented() then
		if thtr:IsPlayerFiltered(ply) then
			if ply:IsAdmin() and rent.AdminsIgnoreFilter() then
				if rent.AdminsAlertFiltered() then
					thtr:AnnounceToPlayer(ply, { "Rent_AdminFilteredWarn" })
				end

				if rent.SuperAlertAdminFiltered() then
					for _, ply2 in ipairs(player.GetAll()) do
						if ply2:IsSuperAdmin() and ply ~= ply2 then
							thtr:AnnounceToPlayer(ply2, { "Rent_AdminEnteredFiltered", ply:Nick() })
						end
					end
				end
			else
				thtr:AnnounceToPlayer(ply, { "Rent_NotAllowed" })
				ply:Spawn()
				return false
			end
		end
	end
end
hook.Add("PrePlayerEnterTheater", "Rent_PrePlayerEnterTheater", prePlayerEnterTheater)

local function preVoteSkipAccept(ply, thtr)
	if thtr:VoteSkipLocked() then
		thtr:AnnounceToPlayer(ply, { "Rent_VoteSkipDisabled" })
		return false
	end
end
hook.Add("PreVoteSkipAccept", "Rent_PreVoteSkipAccept", preVoteSkipAccept)

-- Flag rentable theater thumbnails so clients can render rent state
local function initThumbnails()
	if not theater then return end

	timer.Simple(1, function()
		for _, thtr in pairs(theater.GetTheaters()) do
			if thtr:IsPrivate() and IsValid(thtr._ThumbEnt) then
				thtr._ThumbEnt:SetNWBool("Rentable", true)
				thtr._ThumbEnt:SetNWInt("Location", thtr:GetLocation())
			end
		end
	end)
end
hook.Add("InitPostEntity", "Rent_InitThumbnails", initThumbnails)

-- Keep owner entity ref cleared on disconnect; rent identity (SteamID) stays.
local function playerDisconnected(ply)
	if not IsValid(ply) then return end

	local location = ply._rentedTheater
	if not location then return end

	local thtr = theater.GetByLocation(location)
	if not thtr or not thtr:IsRented() then return end
	if thtr._OwnerSteamID ~= ply:SteamID() then return end

	-- Drop the live entity reference; SteamID + timer keep the rent alive.
	thtr._Owner = nil
	rent.SendRentInfo(thtr)
end
hook.Add("PlayerDisconnected", "Rent_PlayerDisconnected", playerDisconnected)

-- Rebind owner on reconnect, sync rent state, apply pending refunds
local function playerInitialSpawn(ply)
	timer.Simple(5, function()
		if not IsValid(ply) then return end

		-- Re-attach as owner of any active rent matching this SteamID
		if theater then
			for _, thtr in pairs(theater.GetTheaters()) do
				if thtr:IsRented() and thtr._OwnerSteamID == ply:SteamID() then
					thtr._Owner = ply
					thtr._OwnerNick = ply:Nick()
					ply._rentedTheater = thtr:GetLocation()
					rent.SendRentInfo(thtr)
					theater.RequestTheaterInfo(ply)
				elseif thtr:IsRented() then
					rent.SendRentInfo(thtr, ply)
				end
			end
		end

		-- Apply any refund that was queued while the player was offline
		rent.ApplyPendingRefund(ply)
	end)
end
hook.Add("PlayerInitialSpawn", "Rent_PlayerInitialSpawn", playerInitialSpawn)
