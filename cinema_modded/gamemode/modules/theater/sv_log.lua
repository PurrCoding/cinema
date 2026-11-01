module( "theater", package.seeall )

local debug_sql = CreateConVar( "cinema_debug_history", "0", FCVAR_ARCHIVE, "Print Cinema SQL queries and results." )

local function ReportQueryError( command )
	local err = sql.LastError() or "Unknown SQL error"
	ErrorNoHalt( string.format( "[Cinema] Server SQL error: %s\nQuery: %s\n", err, command or "<no query>" ) )
end

function Query( command, ... )
	if not command then return nil end
	if not sql.TableExists( "cinema_history" ) then
		Msg( "Creating 'cinema_history' table...\n" )
		local created = sql.QueryTyped([[CREATE TABLE IF NOT EXISTS cinema_history (
			id INTEGER PRIMARY KEY,
			type VARCHAR(32),
			title VARCHAR(32),
			data VARCHAR(2048),
			duration NUMERIC NOT NULL DEFAULT 0,
			thumbnail VARCHAR(256),
			count NUMERIC NOT NULL DEFAULT 0,
			lastRequest NUMERIC NOT NULL DEFAULT 0
		)]])
		if created == false then
			ReportQueryError( "CREATE TABLE cinema_history" )
			return false
		end
	end

	local results = sql.QueryTyped( command, ... )
	if results == false then
		ReportQueryError( command )
		return false
	end

	if debug_sql:GetBool() then
		MsgN( "[Cinema] Server video history SQL: " .. command )
		if istable( results ) and #results > 0 then
			PrintTable( results )
		else
			MsgN( "[Cinema] Query completed; no rows returned." )
		end
	end

	return results
end

function GetVideoLog( data, type )
	return Query(
		"SELECT * FROM cinema_history WHERE type = ? AND data = ?",
		type, data
	)
end

function RemoveVideoLog( data, type )
	return Query(
		"DELETE FROM cinema_history WHERE type = ? AND data = ?",
		type, data
	)
end

function LogVideo( Video, Theater )
	local Type = Video:Type()

	-- Streams can be offline, so caching results isn't a good idea.
	if not IsVideoTimed( Type ) then return end

	-- Some services prefer to not be cached.
	if not IsVideoCacheable( Type ) then return end

	local title = Video:Title()
	local data = Video:Data()
	local duration = Video:Duration()
	local thumbnail = Video:Thumbnail()

	local results = Query(
		"SELECT count FROM cinema_history WHERE type = ? AND data = ?",
		Type, data
	)

	if results == false then return false end

	if #results > 0 then
		local count = ( tonumber( results[1].count ) or 0 ) + 1

		return Query(
			"UPDATE cinema_history SET lastRequest = ?, count = ? WHERE type = ? AND data = ?",
			os.time(), count, Type, data
		)
	end

	return Query(
		"INSERT INTO cinema_history (type, title, data, duration, thumbnail, count, lastRequest) VALUES (?, ?, ?, ?, ?, ?, ?)",
		Type, title, data, duration, thumbnail, 0, os.time()
	)
end

hook.Add( "PostVideoQueued", "LogQueuedVideo", theater.LogVideo )

