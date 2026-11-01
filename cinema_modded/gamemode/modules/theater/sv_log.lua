module( "theater", package.seeall )

function Query( command, ... )
	-- Ensure the log table exists.
	if not sql.TableExists( "cinema_history" ) then
		Msg( "Creating 'cinema_history' table...\\n" )

		sql.QueryTyped([[CREATE TABLE IF NOT EXISTS cinema_history (
			id INTEGER PRIMARY KEY,
			type VARCHAR(32),
			title VARCHAR(32),
			data VARCHAR(2048),
			duration NUMERIC NOT NULL DEFAULT 0,
			thumbnail VARCHAR(256),
			count NUMERIC NOT NULL DEFAULT 0,
			lastRequest NUMERIC NOT NULL DEFAULT 0
		)]])
	end

	if command then
		return sql.QueryTyped( command, ... )
	end
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

	if results and #results > 0 then
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
