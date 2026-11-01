module( "theater", package.seeall )

function Query( command, ... )

	-- Ensure the log table exists before running queries against it.
	if not sql.TableExists( "cinema_requests" ) then
		Msg( "Creating 'cinema_requests' table...\\n" )

		sql.QueryTyped([[CREATE TABLE IF NOT EXISTS cinema_requests (
			id INTEGER PRIMARY KEY,
			title VARCHAR(32),
			url VARCHAR(2048),
			type VARCHAR(32),
			data VARCHAR(2048),
			duration NUMERIC NOT NULL DEFAULT 0,
			count NUMERIC NOT NULL DEFAULT 0,
			lastRequest NUMERIC NOT NULL DEFAULT 0
		)]])
	end


	if command then
		return sql.QueryTyped( command, ... )
	end
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
		local results = Query( query, "%" .. filter .. "%" ) or {}
		for _, result in ipairs( results ) do
			result.duration = tonumber( result.duration )
			result.count = tonumber( result.count )
			result.lastRequest = tonumber( result.lastRequest )
		end
		return results
	end

	local results = Query( query ) or {}
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

	if results and #results > 0 then
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
