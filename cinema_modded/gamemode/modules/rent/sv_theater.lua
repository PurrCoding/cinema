local function initialize()
	if not theater or not theater.THEATER then return false end
	-- Already applied
	if theater.THEATER.RequestRent then return true end

	-- Shared refund routine used by both owner refunds and admin cancels.
	-- Refund value uses ceil of remaining minutes so partial minutes are not lost.
	local function performRefund(thtr, refundPly)
		local remaining = math.max(0, thtr:GetRemainingRentTime())
		local minutes = math.ceil(remaining / 60)
		if minutes < 1 and remaining > 0 then
			minutes = 1
		end
		local value = minutes * rent.CostPerMinute()

		local ownerSteamID = thtr._OwnerSteamID
		local ownerNick = thtr._OwnerNick

		thtr._rentExpiration = nil
		thtr._rentLength = nil
		thtr._rentalTime = nil
		thtr:ResetOwner()

		if IsValid(refundPly) then
			refundPly._rentedTheater = nil
			rent.GiveMoney(refundPly, value)
			theater.RequestTheaterInfo(refundPly)
		elseif ownerSteamID then
			-- Owner is offline: queue refund for reconnect
			rent.QueuePendingRefund(ownerSteamID, value)
		end

		timer.Remove("RentExpiration_" .. thtr:GetLocation())

		rent.SendRentInfo(thtr)

		return minutes, value, ownerSteamID, ownerNick
	end

	function theater.THEATER:IsRented()
		return self._OwnerSteamID ~= nil and self._rentExpiration ~= nil
	end

	-- Resolve the live player entity when possible; falls back to stored entity ref.
	function theater.THEATER:GetOwner()
		if IsValid(self._Owner) then
			return self._Owner
		end

		if self._OwnerSteamID then
			local ply = player.GetBySteamID(self._OwnerSteamID)
			if IsValid(ply) then
				self._Owner = ply
				return ply
			end
		end

		return self._Owner
	end

	function theater.THEATER:GetOwnerSteamID()
		return self._OwnerSteamID
	end

	function theater.THEATER:GetOwnerNick()
		local owner = self:GetOwner()
		if IsValid(owner) then
			return owner:Nick()
		end
		return self._OwnerNick
	end

	function theater.THEATER:IsOwner(ply)
		if not IsValid(ply) then return false end
		if self._OwnerSteamID then
			return ply:SteamID() == self._OwnerSteamID
		end
		return self._Owner == ply
	end

	function theater.THEATER:GetRemainingRentTime()
		if self:IsRented() then
			return math.max(0, self._rentExpiration - CurTime())
		else
			return 0
		end
	end

	function theater.THEATER:GetRemainingRentTimeTimer()
		return rent.SecondsToTimer(self:GetRemainingRentTime())
	end

	function theater.THEATER:RequestRent(ply, length)
		if not self:IsPrivate() then
			self:AnnounceToPlayer(ply, { "Rent_NotPrivate" })
		elseif self:IsRented() then
			if self:IsOwner(ply) then
				self:ExtendRent(ply, length)
			else
				self:AnnounceToPlayer(ply, { "Rent_AlreadyRentedBy", self:GetOwnerNick() or "?" })
			end
		elseif ply:IsRentingTheater() then
			self:AnnounceToPlayer(ply, { "Rent_AlreadyRentingOther", ply:GetRentedTheater():Name() })
		elseif length < rent.MinimumRentTime() then
			self:AnnounceToPlayer(ply, { "Rent_MinTime", rent.MinimumRentTime() })
		elseif length > rent.MaximumRentTime() then
			self:AnnounceToPlayer(ply, { "Rent_MaxTime", rent.MaximumRentTime() })
		else
			local cost = length * rent.CostPerMinute()
			if not rent.CanAfford(ply, cost) then
				-- CanAfford already announces when no provider is available
				if rent.GetProvider(ply) then
					self:AnnounceToPlayer(ply, { "Rent_CantAfford", theater.Currency(cost) })
				end
			else
				self._rentExpiration = CurTime() + (length * 60)
				self._rentLength = length * 60
				self._rentalTime = CurTime()
				self._Owner = ply
				self._OwnerSteamID = ply:SteamID()
				self._OwnerNick = ply:Nick()

				ply._rentedTheater = self:GetLocation()

				timer.Create("RentExpiration_" .. self:GetLocation(), self._rentLength, 1, function()
					self:OnRentExpired()
				end)

				rent.TakeMoney(ply, cost)

				theater.RequestTheaterInfo(ply)
				rent.SendRentInfo(self)
				self:AnnounceToPlayers({ "Rent_HasRented", ply:Nick(), theater.Duration(length * 60) })
			end
		end
	end

	function theater.THEATER:ExtendRent(ply, length)
		if not self:IsOwner(ply) then
			self:AnnounceToPlayer(ply, { "Rent_ExtendNotRenting" })
		else
			local extendedTime = math.floor(self:GetRemainingRentTime() / 60) + length

			if extendedTime < rent.MinimumRentTime() then
				self:AnnounceToPlayer(ply, { "Rent_ExtendMinTime", rent.MinimumRentTime() })
			elseif extendedTime > rent.MaximumRentTime() then
				self:AnnounceToPlayer(ply, { "Rent_ExtendMaxTime", rent.MaximumRentTime() })
			else
				local cost = length * rent.CostPerMinute()

				if not rent.CanAfford(ply, cost) then
					if rent.GetProvider(ply) then
						self:AnnounceToPlayer(ply, { "Rent_CantAfford", theater.Currency(cost) })
					end
				else
					self._rentExpiration = self._rentExpiration + (length * 60)
					self._rentLength = self._rentLength + (length * 60)
					-- Keep owner identity fresh
					self._Owner = ply
					self._OwnerSteamID = ply:SteamID()
					self._OwnerNick = ply:Nick()

					timer.Remove("RentExpiration_" .. self:GetLocation())
					timer.Create("RentExpiration_" .. self:GetLocation(), self._rentExpiration - CurTime(), 1,
						function()
							self:OnRentExpired()
						end)

					rent.TakeMoney(ply, cost)

					rent.SendRentInfo(self)
					self:AnnounceToPlayers({ "Rent_HasExtended", ply:Nick(), theater.Duration(length * 60) })
				end
			end
		end
	end

	-- Owner-initiated refund (always available to the renter).
	function theater.THEATER:RefundRent(ply)
		if not self:IsOwner(ply) then
			self:AnnounceToPlayer(ply, { "Rent_RefundNotRenting" })
		elseif self:GetRemainingRentTime() < 1 then
			self:AnnounceToPlayer(ply, { "Rent_RefundNotEnoughTime" })
		else
			local minutes, value = performRefund(self, ply)

			self:AnnounceToPlayers({ "Rent_HasRefunded", ply:Nick() })
			self:AnnounceToPlayer(ply, { "Rent_Refunded", theater.Currency(value), minutes })
		end
	end

	-- Admin-initiated cancel of someone else's rent (refunds the owner).
	function theater.THEATER:CancelRent(admin)
		if not self:IsRented() then
			self:AnnounceToPlayer(admin, { "Rent_NotRented" })
		elseif self:GetRemainingRentTime() < 1 then
			self:AnnounceToPlayer(admin, { "Rent_RefundNotEnoughTime" })
		else
			local owner = self:GetOwner()
			local ownerNick = self:GetOwnerNick() or "?"
			local minutes, value, ownerSteamID = performRefund(self, owner)

			if IsValid(owner) then
				self:AnnounceToPlayers({ "Rent_CancelledPublic", ownerNick })
				self:AnnounceToPlayer(owner, { "Rent_CancelledOwner", theater.Currency(value), minutes })
				self:AnnounceToPlayer(admin, { "Rent_CancelledAdmin", ownerNick })
			elseif ownerSteamID then
				self:AnnounceToPlayers({ "Rent_CancelledPublic", ownerNick })
				self:AnnounceToPlayer(admin, { "Rent_CancelledAdminPending", ownerNick, theater.Currency(value) })
			else
				self:AnnounceToPlayer(admin, { "Rent_CancelledAdminUnknown" })
			end
		end
	end

	function theater.THEATER:OnRentExpired()
		local previousOwner = self:GetOwner()
		local previousSteamID = self._OwnerSteamID

		self._rentExpiration = nil
		self._rentLength = nil
		self._rentalTime = nil
		self:ResetOwner()

		if IsValid(previousOwner) then
			previousOwner._rentedTheater = nil

			if (previousOwner:GetTheater() ~= nil) and (previousOwner:GetTheater():GetLocation() == self:GetLocation()) then
				theater.RequestTheaterInfo(previousOwner)
			else
				self:AnnounceToPlayer(previousOwner, { "Rent_ExpiredOwner", self:Name() })
			end
		elseif previousSteamID then
			-- Owner offline: nothing to announce to them until they rejoin
		end

		if self:NumPlayers() < 1 then
			self:Reset()
		end

		rent.SendRentInfo(self)
		self:AnnounceToPlayers({ "Rent_ExpiredPublic" })
	end

	function theater.THEATER:SetPlayerFilter(ply, filterData)
		if not self:IsPrivate() then
			self:AnnounceToPlayer(ply, { "Rent_FilterNotPrivate" })
		elseif not self:IsRented() then
			self:AnnounceToPlayer(ply, { "Rent_FilterNotRented" })
		elseif not self:IsOwner(ply) then
			self:AnnounceToPlayer(ply, { "Rent_FilterNotOwner" })
		else
			self._WhitelistMode = filterData.whitelistMode
			self._PlayerFilter = filterData.players

			self:AnnounceToPlayer(ply, { "Rent_FilterUpdated" })

			-- Iterate a copy: respawning a filtered player mutates self.Players.
			for _, ply2 in ipairs(table.Copy(self.Players)) do
				if not IsValid(ply2) or not self:IsPlayerFiltered(ply2) then continue end

				if ply2:IsAdmin() and rent.AdminsIgnoreFilter() then
					if rent.AdminsAlertFiltered() then
						self:AnnounceToPlayer(ply2, { "Rent_FilterAdminWarn" })
					end

					if rent.SuperAlertAdminFiltered() then
						for _, ply3 in ipairs(player.GetAll()) do
							if ply3:IsSuperAdmin() and ply2 ~= ply3 then
								self:AnnounceToPlayer(ply3, { "Rent_FilterSuperWarn", ply2:Nick() })
							end
						end
					end
				else
					self:AnnounceToPlayer(ply2, { "Rent_FilteredOut" })
					if ply2:InVehicle() then
						ply2:ExitVehicle()
					end
					ply2:Spawn()
				end
			end
		end
	end

	function theater.THEATER:GetPlayerFilter()
		return {
			whitelistMode = self._WhitelistMode,
			players = self._PlayerFilter
		}
	end

	function theater.THEATER:IsPlayerFiltered(ply)
		if self:IsOwner(ply) then
			return false
		elseif self._WhitelistMode == nil or not self._PlayerFilter then
			return false
		else
			if self._WhitelistMode then
				return not table.HasValue(self._PlayerFilter, ply:SteamID())
			else
				return table.HasValue(self._PlayerFilter, ply:SteamID())
			end
		end
	end

	function theater.THEATER:VoteSkipLocked()
		return self.voteSkipLocked
	end

	function theater.THEATER:SetVoteSkipLocked(locked)
		if locked and not self.voteSkipLocked then
			self:AnnounceToPlayers({ "Rent_VoteSkipLocked" })
		elseif not locked and self.voteSkipLocked then
			self:AnnounceToPlayers({ "Rent_VoteSkipUnlocked" })
		end

		self.voteSkipLocked = locked
	end

	-- Overrides required for rent ownership to persist correctly

	function theater.THEATER:RequestOwner(ply)
		-- Disable automatic ownership; ownership only comes from renting
	end

	function theater.THEATER:Reset()
		self._Name = self._OriginalName

		self:ClearQueue()
		self:ClearSkipVotes()
		self:SetupThumbnailEntity()

		self:PlayDefault()
	end

	function theater.THEATER:ResetOwner()
		self._Owner = nil
		self._OwnerSteamID = nil
		self._OwnerNick = nil
		self._QueueLocked = false
		self._WhitelistMode = nil
		self._PlayerFilter = nil
		-- Clear vote-skip lock when ownership ends (refund, cancel, or expiry)
		self.voteSkipLocked = false
	end

	function theater.THEATER:RemovePlayer(ply)
		if not self:HasPlayer(ply) then return end

		table.RemoveByValue(self.Players, ply)

		if self:HasPlayerVotedToSkip(ply) then
			table.RemoveByValue(self._SkipVotes, ply)
		end

		net.Start("PlayerLeaveTheater")
		net.Send(ply)

		-- Do not clear rent ownership when the owner merely leaves the theater;
		-- ownership is tied to the paid rent period, not physical presence.

		if self:NumPlayers() > 0 then
			self:CheckVoteSkip()
		else
			if (self:IsPrivate() and not self:IsRented()) or (not self:IsPrivate() and GetConVar("cinema_allow_reset"):GetBool()) then
				self:Reset()
			end
		end
	end

	return true
end

-- theater module loads after rent alphabetically; retry until methods are attached.
local function tryInitialize()
	if initialize() then
		hook.Remove("Initialize", "Rent_TheaterMethods")
		hook.Remove("InitPostEntity", "Rent_TheaterMethods")
		timer.Remove("Rent_TheaterMethods_Retry")
		return true
	end
	return false
end

hook.Add("Initialize", "Rent_TheaterMethods", tryInitialize)
hook.Add("InitPostEntity", "Rent_TheaterMethods", tryInitialize)
timer.Create("Rent_TheaterMethods_Retry", 0.5, 20, tryInitialize)
