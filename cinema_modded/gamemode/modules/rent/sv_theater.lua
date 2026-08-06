local function initialize()
	if not theater then return end -- Don't break the server if cinema isn't loaded

	-- Shared refund routine used by both owner refunds and admin cancels.
	local function performRefund(thtr, refundPly)
		local minutes = math.floor(thtr:GetRemainingRentTime() / 60)
		local value = minutes * rent.CostPerMinute()

		thtr._rentExpiration = nil
		thtr._rentLength = nil
		thtr._rentalTime = nil
		thtr:ResetOwner()

		if IsValid(refundPly) then
			refundPly._rentedTheater = nil
			rent.GiveMoney(refundPly, value)
			theater.RequestTheaterInfo(refundPly)
		end

		timer.Remove("RentExpiration_" .. thtr:GetLocation())

		rent.SendRentInfo(thtr)

		return minutes, value
	end

	function theater.THEATER:IsRented()
		return IsValid(self._Owner)
	end

	function theater.THEATER:GetRemainingRentTime()
		if self:IsRented() then
			return self._rentExpiration - CurTime()
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
			if self:GetOwner() == ply then
				self:ExtendRent(ply, length)
			else
				self:AnnounceToPlayer(ply, { "Rent_AlreadyRentedBy", self:GetOwner():Nick() })
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
				self:AnnounceToPlayer(ply, { "Rent_CantAfford", theater.Currency(cost) })
			else
				self._rentExpiration = CurTime() + (length * 60)
				self._rentLength = length * 60
				self._rentalTime = CurTime()
				self._Owner = ply

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
		if self:GetOwner() ~= ply then
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
					self:AnnounceToPlayer(ply, { "Rent_CantAfford", theater.Currency(cost) })
				else
					self._rentExpiration = self._rentExpiration + (length * 60)
					self._rentLength = self._rentLength + (length * 60)

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
		if self:GetOwner() ~= ply then
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
			local minutes, value = performRefund(self, owner)

			if IsValid(owner) then
				self:AnnounceToPlayers({ "Rent_CancelledPublic", owner:Nick() })
				self:AnnounceToPlayer(owner, { "Rent_CancelledOwner", theater.Currency(value), minutes })
				self:AnnounceToPlayer(admin, { "Rent_CancelledAdmin", owner:Nick() })
			else
				self:AnnounceToPlayer(admin, { "Rent_CancelledAdminUnknown" })
			end
		end
	end

	function theater.THEATER:OnRentExpired()
		local previousOwner = self._Owner

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
		elseif self:GetOwner() ~= ply then
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
		if ply == self:GetOwner() then
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
		self._Owner = false
		self._QueueLocked = false
		self._WhitelistMode = nil
		self._PlayerFilter = nil
	end

	function theater.THEATER:RemovePlayer(ply)
		if not self:HasPlayer(ply) then return end

		table.RemoveByValue(self.Players, ply)

		if self:HasPlayerVotedToSkip(ply) then
			table.RemoveByValue(self._SkipVotes, ply)
		end

		net.Start("PlayerLeaveTheater")
		net.Send(ply)

		if self:NumPlayers() > 0 then
			self:CheckVoteSkip()
		else
			if (self:IsPrivate() and not self:IsRented()) or (not self:IsPrivate() and GetConVar("cinema_allow_reset"):GetBool()) then
				self:Reset()
			end
		end
	end
end
hook.Add("Initialize", "Rent_TheaterMethods", initialize)