module( "control", package.seeall )

HoldTime = 0.3

LastPress = nil
LastKey = nil
KeyControls = {}

function Check()

	if gui.IsGameUIVisible() or gui.IsConsoleVisible() then return end

	for key, tbl in pairs( KeyControls ) do

		if tbl.Enabled then

			-- Key hold (repeat press)
			if tbl.LastPress and tbl.LastPress + HoldTime < RealTime() then
				tbl.Toggle( true, true )
				tbl.LastPress = RealTime()
			end

			-- Key release
			if not input.IsKeyDown( key ) then
				tbl.Toggle( false )
				tbl.Enabled = false
			end

		else

			-- Key press
			if input.IsKeyDown( key ) then
				tbl.Toggle( true )
				tbl.Enabled = true
				tbl.LastPress = RealTime()
			end

		end

	end

end
hook.Add( "Think", "TheaterControlsThink", control.Check )

function Add( key, onToggle )

	if not key or not onToggle then return end

	KeyControls[ key ] = {
		Enabled = false,
		LastPress = 0,
		Toggle = function(...)
			local msg, err = pcall( onToggle, ... )
			if err then
				print( "ERROR: " .. msg )
			end
		end
	}

end

function Remove( key )

	if not key then return end

	KeyControls[ key ] = nil

end