CreateConVar( "cinema_queue_mode", 1, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "1 = Videos may be voted up or down\n2 = Videos are played in the order they're requested" )
CreateConVar( "cinema_force_extension_bypass", 0, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "Bypass file extension check when using direct file streaming" )

if CLIENT then

	CreateClientConVar( "cinema_drawnames", 1, true, false )
	CreateClientConVar( "cinema_volume", 50, true, false )
	CreateClientConVar( "cinema_resolution", 1080, true, false )
	local MuteNoFocus = CreateClientConVar( "cinema_mute_nofocus", 1, true, false )
	local HidePlayers = CreateClientConVar( "cinema_hideplayers", 0, true, false )
	local HideAmount = CreateClientConVar( "cinema_hide_amount", 0.11, true, false )

	cvars.AddChangeCallback( "cinema_resolution", function(cmd, old, new)
		new = tonumber(new)

		if not new then
			return
		elseif new < 2 then
			RunConsoleCommand( "cinema_resolution", 2 )
		elseif new > 1080 then
			RunConsoleCommand( "cinema_resolution", 1080 )
		else
			theater.ResizePanel()
		end
	end)

	cvars.AddChangeCallback( "cinema_volume", function(cmd, old, new)
		new = tonumber(new)

		if not new then
			return
		elseif new < 0 then
			RunConsoleCommand( "cinema_volume", 0 )
		elseif new > 100 then
			RunConsoleCommand( "cinema_volume", 100 )
		else
			theater.SetVolume(new)
		end
	end)

	concommand.Add( "cinema_refresh", function()
		theater.RefreshPanel(true)
	end )

	concommand.Add( "cinema_fullscreen", theater.ToggleFullscreen )

	-- Hide Players
	local amount = 0
	local undomodelblend = false
	local matWhite = Material("models/debug/debugwhite")
	hook.Add( "PrePlayerDraw", "TheaterHidePlayers", function( ply )

		-- Local player in a theater and hide players enabled
		if LocalPlayer():InTheater() then
			if theater.Fullscreen then
				return true
			end

			if HidePlayers:GetBool() then
				amount = HideAmount:GetFloat()

				-- Hide model
				render.SetBlend( amount )
				render.ModelMaterialOverride(matWhite)
				render.SetColorModulation(0.2, 0.2, 0.2)

				undomodelblend = true
			end
		end

	end )

	hook.Add( "PostPlayerDraw", "TheaterHidePlayers", function( ply )
		if undomodelblend then
			render.SetBlend(1.0) -- always show model
			render.ModelMaterialOverride()
			render.SetColorModulation(1, 1, 1)
			undomodelblend = nil
		end
	end )

	-- Mute theater on losing focus to Garry's Mod window
	local HasFocus, LastVolume = true, theater.GetVolume()
	hook.Add( "Think", "TheaterMuteOnFocusChange", function()

		if not MuteNoFocus:GetBool() then return end

		HasFocus = system.HasFocus()

		if ( LastState and not HasFocus ) or ( not LastState and HasFocus ) then

			if HasFocus == true then
				theater.SetVolume( LastVolume )
				LastVolume = nil
			else
				LastVolume = theater.GetVolume()
				theater.SetVolume( 0 )
			end

			LastState = HasFocus

		end

	end )

else

	local fcvar = { FCVAR_ARCHIVE, FCVAR_DONTRECORD }

	-- Settings
	CreateConVar( "cinema_video_duration_max", 3 * 60 * 60, fcvar, "Maximum video duration for requests in public theaters." )
	CreateConVar( "cinema_skip_ratio", 0.66, fcvar, "Ratio between 0-1 determining how many players are required to voteskip a video." )
	-- Permissions
	CreateConVar( "cinema_allow_reset", 0, fcvar, "Reset the theater after all players have left." )
	CreateConVar( "cinema_allow_voice", 0, fcvar, "Allow theater viewers to talk amongst themselves." )
	CreateConVar( "cinema_allow_3dvoice", 1, fcvar, "Use 3D voice chat." )

	local function SetSyncedCvarString(name, value, helptext )
		local cvar = CreateConVar( name, value, fcvar, helptext )

		-- Check if String is empty
		if #cvar:GetString() == 0 then
			cvar:SetString(value)
		end

		SetGlobal2String( name, cvar:GetString() )
		cvars.AddChangeCallback( name, function(cmd, old, new)
			SetGlobal2String( name, new )
		end)
	end

	-- Synced Server ConVars
	SetSyncedCvarString("cinema_url", "https://purrcoding.github.io/cinema/", "Cinema url to load on theater screens.") -- don't edit, use console!
	SetSyncedCvarString("cinema_url_search", "https://purrcoding.github.io/cinema/search/", "Search url for the request menu.") -- don't edit, use console!

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
