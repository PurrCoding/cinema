CreateConVar( "cinema_queue_mode", 1, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "1 = Upvote only (supported)\n2 = Chronological / request order (supported)\n3 = Up and down voting (not supported)" )
CreateConVar( "cinema_url", "https://gm-cinema.purrcoding.com/", { FCVAR_NOT_CONNECTED, FCVAR_REPLICATED }, "Cinema url to load on theater screens.") -- don't edit, use server config!

if SERVER then

	local fcvar = { FCVAR_ARCHIVE, FCVAR_DONTRECORD }

	-- Settings
	CreateConVar( "cinema_video_duration_max", 3 * 60 * 60, fcvar, "Maximum video duration for requests in public theaters." )
	CreateConVar( "cinema_skip_ratio", 0.66, fcvar, "Ratio between 0-1 determining how many players are required to voteskip a video." )
	-- Permissions
	CreateConVar( "cinema_allow_reset", 0, fcvar, "Reset the theater after all players have left." )
	CreateConVar( "cinema_allow_voice", 0, fcvar, "Allow theater viewers to talk amongst themselves." )
	CreateConVar( "cinema_allow_3dvoice", 1, fcvar, "Use 3D voice chat." )

	concommand.Add("cinema_fullscreen_freeze", function(ply,cmd,args)
		ply:Freeze(tobool(args[1]))
	end)

	concommand.Add("cinema_truncate_history", function(ply,cmd,args)

		if (IsValid(ply) and ply:IsPlayer() and ply:IsSuperAdmin()) then
			theater.Query("DELETE FROM cinema_history")
		end

	end)

	local function TheaterCommand( name, Function )

		if not Function then return end

		concommand.Add( name, function( ply, ... )

			if not IsValid(ply) then return end

			local Theater = ply:GetTheater()
			if Theater then

				local status, err = pcall(Function, Theater, ply, ...)

				if not status then
					Msg("ERROR: There was a problem running the command '" .. name .. "'\n")
					Msg(tostring(err) .. "\n")
				end

			end

		end)

	end

	TheaterCommand( "cinema_video_request", function( Theater, ply, cmd, args )

		local Video = args[1]
		if not Video then return end

		Theater:RequestVideo(ply, Video)

	end)

	TheaterCommand( "cinema_video_remove", function( Theater, ply, cmd, args )

		local id = tonumber(args[1])
		if not id then return end

		Theater:RemoveQueuedVideo(ply, id)

	end)

	TheaterCommand( "cinema_name", function( Theater, ply, cmd, args )

		local name = args[1]
		if not name then return end

		Theater:SetName( name, ply )

	end)

	TheaterCommand( "cinema_voteskip", function( Theater, ply, cmd, args )

		-- Prevent player from spamming command
		if ply.LastVoteSkip and ply.LastVoteSkip + 1 > CurTime() then
			return
		end

		Theater:VoteSkip(ply)

		ply.LastVoteSkip = CurTime()

	end)

	TheaterCommand( "cinema_voteup", function( Theater, ply, cmd, args )

		local QueueId = tonumber(args[1])
		if not QueueId then return end

		Theater:VoteQueuedVideo(ply, QueueId, true)

	end)

	-- Only effective when cinema_queue_mode == 3 (not supported).
	TheaterCommand( "cinema_votedown", function( Theater, ply, cmd, args )

		local QueueId = tonumber(args[1])
		if not QueueId then return end

		Theater:VoteQueuedVideo(ply, QueueId, false)

	end)

	/*
		Admin/Developer Commands
	*/
	local function TheaterPrivilegedCommand( name, Function )

		if not Function then return end

		concommand.Add( name, function( ply, ... )

			if not IsValid(ply) then return end

			local Theater = ply:GetTheater()
			if Theater then

				if ply:IsAdmin() or
					( Theater:IsPrivate() and Theater:GetOwner() == ply ) then

					local status, err = pcall(Function, Theater, ply, ...)

					if not status then
						Msg("ERROR: There was a problem running the command '" .. name .. "'\n")
						Msg(tostring(err) .. "\n")
					end

				end

			end

		end)

	end

	TheaterPrivilegedCommand( "cinema_video_set", function( Theater, ply, cmd, args )

		local VideoUrl = args[1]
		if not VideoUrl then return end

		Theater:RequestVideo(ply, VideoUrl, true)

	end )

	TheaterPrivilegedCommand( "cinema_seek", function( Theater, ply, cmd, args )

		local seconds = args[1]
		if not seconds then return end

		Theater:Seek(seconds)

	end )

	TheaterPrivilegedCommand( "cinema_pause", function( Theater, ply, cmd, args )

		if not theater.IsVideoTimed( Theater:VideoType() ) then return end

		-- Debounce: ignore rapid toggles that would spam TheaterPause net messages
		local now = CurTime()
		if Theater._NextPauseToggle and now < Theater._NextPauseToggle then return end
		Theater._NextPauseToggle = now + 0.5

		Theater:SetPaused( not Theater:IsPaused() )

		Theater:AnnounceToPlayers( {
			Theater:IsPaused() and "Theater_PlayerPaused" or "Theater_PlayerResumed",
			ply:Nick()
		} )

	end )

	TheaterPrivilegedCommand( "cinema_forceskip", function( Theater, ply, cmd, args )

		Theater:AnnounceToPlayers( {
			"Theater_ForceSkipped",
			ply:Nick()
		} )

		Theater:SkipVideo()

	end )

	TheaterPrivilegedCommand( "cinema_lock", function( Theater, ply, cmd, args )

		Theater:ToggleQueueLock( ply )

	end )

	TheaterPrivilegedCommand( "cinema_reset", function( Theater, ply, cmd, args )

		if not ply:IsAdmin() then return end

		Theater:AnnounceToPlayers( {
			"Theater_PlayerReset",
			ply:Nick()
		} )

		Theater:Reset()

	end )

	/*
		Parse URLs in the chat for video requests
	*/
	hook.Add("PlayerSay", "TheaterAutoAdd", function(ply, chat)
		local Theater = ply:GetTheater()

		if Theater then
			if string.find(chat, "/", 1, true) and string.find(chat, ".", 1, true) then
				if theater.ExtractURLData(chat) then
					Theater:RequestVideo(ply, chat)

					return ""
				end
			end
		end
	end)

end
