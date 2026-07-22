include("sh_init.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Mode = 0
ENT.TimeToNext = 0
ENT.Alpha = 1

local THEATER_LOAD_IDLE			= 0
local THEATER_LOAD_FADEDELAY	= 1
local THEATER_LOAD_FADINGOUT 	= 2
local THEATER_LOAD_PAUSE 		= 3
local THEATER_LOAD_FADINGIN 	= 4

local THEATER_LOAD_SWITCH = {
	[THEATER_LOAD_FADEDELAY] = function(ent)
		if CurTime() > ent.TimeToNext then
			ent.Mode = THEATER_LOAD_FADINGOUT
			ent.Alpha = 1 //make sure it's 1
		end

		return ent
	end,
	[THEATER_LOAD_FADINGOUT] = function(ent)
		ent.Alpha = ent.Alpha - ( FrameTime() * 1 ) / ent.FadeTime

		if ent.Alpha <= 0 then
			ent.Alpha = 0
			ent.Mode = THEATER_LOAD_PAUSE
			ent.TimeToNext = CurTime() + ent.WaitTime
		end

		return ent
	end,
	[THEATER_LOAD_PAUSE] = function(ent)
		if CurTime() > ent.TimeToNext then
			ent.Mode = THEATER_LOAD_FADINGIN
			ent.Alpha = 0 //make sure it's 0
		end

		return ent
	end,
	[THEATER_LOAD_FADINGIN] = function(ent)
		ent.Alpha = ent.Alpha + ( FrameTime() * 1 ) / ent.FadeTime

		if ent.Alpha >= 1 then
			ent.Alpha = 1
			ent.Mode = THEATER_LOAD_IDLE

			hook.Remove("RenderScreenspaceEffects", "theater_render_loading")
		end

		return ent
	end
}

local clr = {
	[ "$pp_colour_addr" ] 		= 0,
	[ "$pp_colour_addg" ] 		= 0,
	[ "$pp_colour_addb" ] 		= 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] 	= 1,
	[ "$pp_colour_colour" ] 	= 1,
	[ "$pp_colour_mulr" ] 		= 0,
	[ "$pp_colour_mulg" ] 		= 0,
	[ "$pp_colour_mulb" ] 		= 0
}

function ENT:Draw()
	self:DrawModel()
end

local function loading_renderer()
	if not IsValid( LocalPlayer().LoadingEntity ) or LocalPlayer().LoadingEntity.Mode == THEATER_LOAD_IDLE then return end

	local mode = LocalPlayer().LoadingEntity.Mode
	local ent = THEATER_LOAD_SWITCH[mode](LocalPlayer().LoadingEntity)

	clr["$pp_colour_brightness"] = ent.Alpha - 1
	clr["$$pp_colour_colour"] = ent.Alpha
	DrawColorModify( clr )
end

net.Receive("TheaterDoorLoad", function()
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	ent.TimeToNext = CurTime() + ent.DelayTime //Give a slight pause before fading out
	ent.Mode = THEATER_LOAD_FADEDELAY;
	LocalPlayer().LoadingEntity = ent;

	hook.Add("RenderScreenspaceEffects", "theater_render_loading", loading_renderer)
end)

----------------------------------------------------------------------
-- Teleporter sender/receiver debug overlay (client-only, convar-gated)
----------------------------------------------------------------------
do
	local ents_FindByClass = ents.FindByClass
	local render_DrawBeam = render.DrawBeam
	local render_SetMaterial = render.SetMaterial
	local render_SetColorModulation = render.SetColorModulation
	local render_SetBlend = render.SetBlend
	local math_Round = math.Round
	local string_format = string.format
	local IsValid, pairs, ipairs = IsValid, pairs, ipairs

	local ENABLE = CreateClientConVar("cinema_debug_teleports", "0", false, false)

	local RECEIVER_MODEL = "models/editor/playerstart.mdl"
	util.PrecacheModel(RECEIVER_MODEL) -- editor-only model; may fall back to ERROR if unmounted

	-- Per-receiver color cache. Keyed by rounded destination position so two
	-- senders pointing at the same receiver resolve to the same color.
	local GroupColors = {}

	local function GroupColor(destPos)
		local key = string_format("%d,%d,%d",
			math_Round(destPos.x), math_Round(destPos.y), math_Round(destPos.z))

		local cached = GroupColors[key]
		if cached then return cached end

		-- Deterministic hash of the key -> hue in 0-359.
		local hash = 0
		for i = 1, #key do
			hash = (hash * 31 + key:byte(i)) % 360
		end

		local col = HSVToColor(hash, 0.65, 1)
		GroupColors[key] = col
		return col
	end

	-- Lazy clientside-model cache, keyed by door entity.
	local Ghosts         = {}

	-- Anchor a label above a model's top and pull it toward the viewer so it
	-- always sits on the front-facing side, clear of floors/geometry.
	local function LabelPos(center, height)
		local eye = EyePos()
		local toEye = eye - center
		toEye.z = 0
		if toEye:LengthSqr() < 1 then
			toEye = Vector(0, 0, 0)
		else
			toEye:Normalize()
		end
		return center + Vector(0, 0, height * 0.5 + 12) + toEye * 24
	end

	local function GetGhost(door)
		local cached = Ghosts[door]
		if IsValid(cached) and cached:GetModel() == RECEIVER_MODEL then
			return cached
		end

		if IsValid(cached) then cached:Remove() end

		local csm = ClientsideModel(RECEIVER_MODEL, RENDERGROUP_TRANSLUCENT)
		if not IsValid(csm) then return nil end
		csm:SetNoDraw(true)
		Ghosts[door] = csm
		return csm
	end

	local function ClearGhosts()
		for door, csm in pairs(Ghosts) do
			if IsValid(csm) then csm:Remove() end
			Ghosts[door] = nil
		end
	end

	-- Free clientside models when the overlay is disabled.
	cvars.AddChangeCallback("cinema_debug_teleports", function(_, _, new)
		if tobool(new) == false then ClearGhosts() end
	end, "cinema_debug_teleports_cleanup")

	hook.Add("ShutDown", "CinemaTeleportDebugCleanup", ClearGhosts)

	hook.Add("PostDrawTranslucentRenderables", "CinemaTeleportDebug", function(bDepth, bSkybox)
		if bSkybox then return end
		if not ENABLE:GetBool() then return end

		for _, door in ipairs(ents_FindByClass("theater_door")) do
			if not IsValid(door) then continue end
			if not door:GetNWBool("CinemaTPValid", false) then continue end

			local destPos = door:GetNWVector("CinemaTPDest")
			local destAng = door:GetNWAngle("CinemaTPDestAng")

			local groupColor = GroupColor(destPos)

			-- Sender outline (the door itself)
			local mn, mx = door:GetModelBounds()
			Debug3D.DrawBox(door:LocalToWorld(mn), door:LocalToWorld(mx), groupColor)

			local senderLabelPos = LabelPos(door:LocalToWorld((mn + mx) / 2), mx.z - mn.z)
			Debug3D.DrawText(senderLabelPos, "Sender", "VideoInfoSmall", groupColor, 0.25)

			-- Receiver ghost model
			local ghost = GetGhost(door)
			if IsValid(ghost) then
				ghost:SetPos(destPos)
				ghost:SetAngles(destAng)
				ghost:SetupBones()

				render_SetColorModulation(groupColor.r / 255, groupColor.g / 255, groupColor.b / 255)
				render_SetBlend(0.5)
				ghost:DrawModel()
				render_SetBlend(1)
				render_SetColorModulation(1, 1, 1)

				local gmn, gmx = ghost:GetModelBounds()
				Debug3D.DrawBox(ghost:LocalToWorld(gmn), ghost:LocalToWorld(gmx), groupColor)
			end

			local recvHeight, recvCenter = 72, destPos
			if IsValid(ghost) then
				local gmn, gmx = ghost:GetModelBounds()
				recvHeight = gmx.z - gmn.z
				recvCenter = ghost:LocalToWorld((gmn + gmx) / 2)
			end
			local recvLabelPos = LabelPos(recvCenter, recvHeight)
			Debug3D.DrawText(recvLabelPos, "Receiver", "VideoInfoSmall", groupColor, 0.25)

			-- Connecting beam sender -> receiver
			render_SetMaterial(Debug3D.DebugMat)
			render_DrawBeam(door:GetPos(), destPos, 8, 0, 1, groupColor)
		end
	end)
end