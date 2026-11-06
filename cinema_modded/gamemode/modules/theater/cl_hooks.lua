--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

/*---------------------------------------------------------------------------
	Name: PreVideoLoad
	Desc: Called prior to a video loading. Return true in a hook
		to prevent the default behavior for loading videos. This is
		useful if you want to implement custom player actions for
		a new video type.
---------------------------------------------------------------------------*/
function GM:PreVideoLoad( Video )

end


/*---------------------------------------------------------------------------
	Name: PostVideoLoad
	Desc: Called after a video has loaded.
---------------------------------------------------------------------------*/
function GM:PostVideoLoad( Video )

	-- Print nothing if nothing is played
	if tostring(Video:Title()) ~= "NoVideoPlaying" then

		local startTime = CurTime() - Video:StartTime()

		-- Output debug information
		Msg("Loaded Video\n")
		Msg("\tTitle:\t\t" .. tostring(Video:Title()) .. "\n")
		Msg("\tType:\t\t" .. tostring(Video:Type()) .. "\n")
		Msg("\tData:\t\t" .. tostring(Video:Data()) .. "\n")
		Msg("\tTime:\t\t" .. tostring(startTime) .. "\n")
		Msg("\tDuration:\t" .. tostring(Video:Duration()) .. "\n")
		Msg( string.format("\tRequested by %s (%s)", Video:GetOwnerName(),
			Video:GetOwnerSteamID() ) .. "\n" )
	end

	-- Keep previous video for refreshing the theater
	theater.LastVideo = Video

end

/*---------------------------------------------------------------------------
	Name: OnTheaterLeft
	Desc: Called after the theater is left.
---------------------------------------------------------------------------*/
function GM:OnTheaterLeft()

end