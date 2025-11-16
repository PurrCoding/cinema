DefaultSitSound = Sound("sunabouzu/chair_sit.wav")
ChairSitSounds = {
	["models/sunabouzu/theater_curve_couch.mdl"] = Sound("sunabouzu/couch_sit.wav"),
}

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER )
end

function CreateSeatAtPos(pos, angle)
	local ent = ents.Create("prop_vehicle_prisoner_pod")
	ent:SetModel("models/nova/airboat_seat.mdl")
	ent:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	ent:SetPos(pos)
	ent:SetAngles(angle)
	ent:SetNotSolid(true)
	ent:SetNoDraw(true)

	ent.HandleAnimation = HandleRollercoasterAnimation

	ent:Spawn()
	ent:Activate()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep() -- Put physics object to sleep immediately
		phys:SetMass(1) -- Minimal mass for better performance
	end

	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	ent.IsCinemaSeat = true

	return ent
end

hook.Add("KeyRelease", "EnterSeat", function(ply, key)
	if key ~= IN_USE or ply:InVehicle() or (ply.ExitTime and CurTime() < ply.ExitTime + 1) then return end

	local eye = ply:EyePos()
	local trace = util.TraceLine({start = eye, endpos = eye + ply:GetAimVector() * 100, filter = ply})

	if not IsValid(trace.Entity) then return end

	local seat = trace.Entity
	local model = seat:GetModel()

	local offsets = ChairOffsets[model]
	if not offsets then return end

	local usetable = seat.UseTable or {}
	local pos = -1

	if #offsets > 1 then
		local localpos = seat:WorldToLocal(trace.HitPos)
		local bestpos, bestdist = -1

		for k,v in pairs(offsets) do
			local dist = localpos:Distance(v.Pos)
			if not usetable[k] and (bestpos == -1 or dist < bestdist) then
				bestpos, bestdist = k, dist
			end
		end

		if bestpos == -1 then return end
		pos = bestpos
	elseif not usetable[1] then
		pos = 1
	else
		return
	end

	usetable[pos] = true
	seat.UseTable = usetable

	local ang = seat:GetAngles()
	if offsets[pos].Ang then
		ang:RotateAroundAxis(seat:GetForward(), offsets[pos].Ang.p)
		ang:RotateAroundAxis(seat:GetUp(), offsets[pos].Ang.y)
		ang:RotateAroundAxis(seat:GetRight(), offsets[pos].Ang.r)
	else
		ang:RotateAroundAxis(seat:GetUp(), -90)
	end

	local s = CreateSeatAtPos(trace.Entity:LocalToWorld(offsets[pos].Pos), ang)
	s:SetParent(trace.Entity)
	s:SetOwner(ply)

	s.SeatData = {
		Ent = seat,
		Pos = pos,
		EntryPoint = ply:GetPos(),
		EntryAngles = ply:GetAngles()
	}

	ply:EnterVehicle(s)

	s:EmitSound( ChairSitSounds[model] or DefaultSitSound, 100, 100 )
end)

hook.Add("CanPlayerEnterVehicle", "EnterSeat", function(ply, vehicle)
	if not vehicle.IsCinemaSeat then return end
	if vehicle:GetClass() ~= "prop_vehicle_prisoner_pod" then return end

	if vehicle.Removing then return false end
	return vehicle:GetOwner() == ply
end)

local airdist = Vector(0,0,48)

function TryPlayerExit(ply, ent)
	local pos = ent:GetPos()
	local trydist = 8
	local yawval = 0
	local yaw = Angle(0, ent:GetAngles().y, 0)

	while trydist <= 64 do
		local telepos = pos + yaw:Forward() * trydist
		local trace = util.TraceEntity({start = telepos, endpos = telepos - airdist}, ply)

		if not trace.StartSolid and trace.Fraction > 0 and trace.Hit then
			ply:SetPos(telepos)
			return
		end

		yaw:RotateAroundAxis(yaw:Up(), 15)
		yawval = yawval + 15
		if yawval > 360 then
			yawval = 0
			trydist = trydist + 8
		end
	end

	print("player", ply, "couldn't get out")
end

local function PlayerLeaveVehicle( vehicle, ply )
	if not vehicle.IsCinemaSeat then return end
	if vehicle:GetClass() ~= "prop_vehicle_prisoner_pod" then return end
	if vehicle.Removing == true then return end

	local seat = vehicle.SeatData

	if not (istable(seat) and IsValid(seat.Ent)) then
		return true
	end

	if seat.Ent and seat.Ent.UseTable then
		seat.Ent.UseTable[seat.Pos] = false
	end

	if IsValid(ply) and ply:InVehicle() and (CurTime() - (ply.ExitTime or 0)) > 0.001 then
		ply.ExitTime = CurTime()
		ply:ExitVehicle()

		ply:SetEyeAngles(seat.EntryAngles)

		local trace = util.TraceEntity({
			start = seat.EntryPoint,
			endpos = seat.EntryPoint
		}, ply)

		if vehicle:GetPos():Distance(seat.EntryPoint) < 128 and not trace.StartSolid and trace.Fraction > 0 then
			ply:SetPos(seat.EntryPoint)
		else
			TryPlayerExit(ply, vehicle)
		end

		ply:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	end

	if not vehicle.bSlots then
		vehicle.Removing = true
		vehicle:Remove()
	end

	return false
end

hook.Add("CanExitVehicle", "Leave", PlayerLeaveVehicle)

function PlayerExitLeft( ply )
	if ply:IsPlayer() then
		local Vehicle = ply:GetVehicle()

		if IsValid( Vehicle ) and Vehicle.IsCinemaSeat then
			PlayerLeaveVehicle( Vehicle, ply )
		end
	end
end

hook.Add("PlayerLeaveVehicle", "VehicleLeft", PlayerExitLeft)
hook.Add("PlayerDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("PlayerSilentDeath", "VehicleKilled", PlayerExitLeft)
hook.Add("EntityRemoved", "VehicleCleanup", PlayerExitLeft)
