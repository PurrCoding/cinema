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