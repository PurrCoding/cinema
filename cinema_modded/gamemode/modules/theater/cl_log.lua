module( "theater", package.seeall )

local debug_sql = CreateClientConVar( "cinema_debug_requests", "0", true, false, "Print Cinema SQL queries and results." )

local function ReportQueryError( command )
	local err = sql.LastError() or "Unknown SQL error"
	ErrorNoHalt( string.format( "[Cinema] Client SQL error: %s\nQuery: %s\n", err, command or "<no query>" ) )
end

function Query( command, ... )
	if not command then return nil end
	if not sql.TableExists( "cinema_requests" ) then
		Msg( "Creating 'cinema_requests' table...\n" )
		local created = sql.QueryTyped([[CREATE TABLE IF NOT EXISTS cinema_requests (
			id INTEGER PRIMARY KEY,
			title VARCHAR(32),
			url VARCHAR(2048),
			type VARCHAR(32),
			data VARCHAR(2048),
			duration NUMERIC NOT NULL DEFAULT 0,
			count NUMERIC NOT NULL DEFAULT 0,
			lastRequest NUMERIC NOT NULL DEFAULT 0
		)]])
		if created == false then
			ReportQueryError( "CREATE TABLE cinema_requests" )
			return false
		end
	end

	local results = sql.QueryTyped( command, ... )
	if results == false then
		ReportQueryError( command )
		return false
	end

	if debug_sql:GetBool() then
		MsgN( "[Cinema] Client request log SQL: " .. command )
		if istable( results ) and #results > 0 then
			PrintTable( results )
		else
			MsgN( "[Cinema] Query completed; no rows returned." )
		end
	end

	return results
end

function ClearRequestHistory()
	return Query( "DROP TABLE cinema_requests" )
end

function RemoveRequestById( id )
	id = tonumber( id )
	if not id then return end

	return Query( "DELETE FROM cinema_requests WHERE id = ?", id )
end

function GetRequestHistory( filter )
	local query = "SELECT * FROM cinema_requests"

	if filter and filter ~= "" then
		query = query .. " WHERE title LIKE ?"
		local results = Query( query, "%" .. filter .. "%" )
		if results == false then return false end
		results = results or {}
		for _, result in ipairs( results ) do
			result.duration = tonumber( result.duration )
			result.count = tonumber( result.count )
			result.lastRequest = tonumber( result.lastRequest )
		end
		return results
	end

	local results = Query( query )
	if results == false then return false end
	results = results or {}
	for _, result in ipairs( results ) do
		result.duration = tonumber( result.duration )
		result.count = tonumber( result.count )
		result.lastRequest = tonumber( result.lastRequest )
	end

	return results
end


function LogRequest()
	local url = net.ReadString()
	local title = net.ReadString()
	local duration = net.ReadInt( 32 )
	local vtype = net.ReadString()
	local data = net.ReadString()

	-- Use the parent class of the service.
	if Services[vtype] and Services[vtype].ParentClass then
		vtype = Services[vtype].ParentClass
	end

	AddAnnouncement( {
		"Theater_VideoAddedToQueue",
		title
	} )

	local results = Query(
		"SELECT count FROM cinema_requests WHERE type = ? AND data = ?",
		vtype, data
	)

	if results == false then return false end

	if #results > 0 then
		local count = ( tonumber( results[1].count ) or 0 ) + 1

		return Query(
			"UPDATE cinema_requests SET lastRequest = ?, title = ?, url = ?, duration = ?, count = ? WHERE type = ? AND data = ?",
			os.time(), title, url, duration, count, vtype, data
		)
	end

	return Query(
		"INSERT INTO cinema_requests (title, url, duration, type, data, count, lastRequest) VALUES (?, ?, ?, ?, ?, ?, ?)",
		title, url, duration, vtype, data, 1, os.time()
	)
end
net.Receive( "PlayerVideoQueued", theater.LogRequest )

