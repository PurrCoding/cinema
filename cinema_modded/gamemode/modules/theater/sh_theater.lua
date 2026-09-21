module( "theater", package.seeall )

THEATER = {}

function THEATER:Init( locId, info )

	local o = {}

	setmetatable( o, self )
	self.__index = self

	o.Id = locId -- Location ID
	o._Name = info.Name or "Theater"
	o._Flags = info.Flags or THEATER_NONE
	o._Pos = info.Pos or Vector(0,0,0)
	o._Ang = info.Ang or Angle(0,0,0)

	o._Width = info.Width or 128
	o._Height = info.Height or math.Round(o._Width * (9 / 16))

	if SERVER then

		-- Keep for resetting the theater
		o._OriginalName = o._Name

		-- Convert from hammer units (x10 for render scale)
		o._Width = o._Width * 10
		o._Height = o._Height * 10

		o.Players = {}
		o.Playlist = {}

		o._Video = nil

		if info.ThumbEnt then
			o:SetupThumbnailEntity( info.ThumbEnt )
		elseif info.ThumbInfo then
			o._ThumbInfo = info.ThumbInfo
			o:SetupThumbnailEntity()
		end

		o._Queue = {}
		o._QueueCount = 0

		o._SkipVotes = {}

		o._Finished = true

		if o:IsPrivate() then
			o._QueueLocked = false
			o._Owner = nil
		end

		o:PlayDefault()

	else

		info.Title = info.Title or "NoVideoPlaying"
		o._Video = VIDEO:Init( info )

	end

	return o

end
