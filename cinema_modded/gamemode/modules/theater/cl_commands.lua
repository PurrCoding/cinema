
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

	-- Client functions are loaded after shared commands; resolve this callback when invoked.
	concommand.Add( "cinema_fullscreen", function( ... )
		if theater.ToggleFullscreen then
			theater.ToggleFullscreen( ... )
		end
	end )

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
	local HasFocus, LastVolume = true, nil
	hook.Add( "Think", "TheaterMuteOnFocusChange", function()

		if not MuteNoFocus:GetBool() then return end

		HasFocus = system.HasFocus()

		if ( LastState and not HasFocus ) or ( not LastState and HasFocus ) then

			if HasFocus == true then
				if LastVolume ~= nil then
					theater.SetVolume( LastVolume )
				end
				LastVolume = nil
			else
				if theater.GetVolume and theater.SetVolume then
					LastVolume = theater.GetVolume()
					theater.SetVolume( 0 )
				end
			end

			LastState = HasFocus

		end

	end )
