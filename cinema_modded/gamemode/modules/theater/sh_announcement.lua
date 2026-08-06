module( "theater", package.seeall )

-- Marker builders (shared: server builds them into announcement tables,
-- client resolves them into localized strings before formatting).
function Duration( seconds )
	return { __marker = "duration", value = seconds }
end

function Currency( amount )
	return { __marker = "currency", value = amount }
end

if SERVER then
	-- Localized announcement to a player without a theater context.
	function SendAnnouncement( ply, tbl )
		net.Start( "TheaterAnnouncement" )
		net.WriteTable( tbl )
		net.Send( ply )
	end
end

if SERVER then return end

-- Client-side marker resolvers. Other modules (e.g. rent) may register
-- their own resolvers so the pipeline stays generic.
MarkerResolvers = MarkerResolvers or {}

function RegisterMarkerResolver( id, fn )
	MarkerResolvers[ id ] = fn
end

local function pluralUnit( count, singularKey, pluralKey )
	return translations:Format( count == 1 and singularKey or pluralKey, count )
end

-- Built-in duration resolver (localized + pluralized, composed client-side).
RegisterMarkerResolver( "duration", function( seconds )
	local hours = math.floor( seconds / 3600 )
	local minutes = math.floor( ( seconds % 3600 ) / 60 )
	local secs = math.floor( seconds % 60 )

	local parts = {}
	if hours > 0 then
		table.insert( parts, pluralUnit( hours, "Unit_Hour", "Unit_Hours" ) )
	end
	if minutes > 0 then
		table.insert( parts, pluralUnit( minutes, "Unit_Minute", "Unit_Minutes" ) )
	end
	if secs > 0 or ( hours == 0 and minutes == 0 ) then
		table.insert( parts, pluralUnit( secs, "Unit_Second", "Unit_Seconds" ) )
	end

	return table.concat( parts, " " )
end )

local function resolveArg( arg )
	if istable( arg ) and arg.__marker then
		local resolver = MarkerResolvers[ arg.__marker ]
		if resolver then
			return resolver( arg.value )
		end
		return tostring( arg.value )
	end
	return arg
end

function AddAnnouncement( tbl )
	if not istable(tbl) then return end

	local key = table.remove(tbl, 1)

	for i = 1, #tbl do
		tbl[i] = resolveArg( tbl[i] )
	end

	local values = translations:FormatChat( key, unpack(tbl) )
	chat.AddText( ColDefault, unpack(values) )
end

net.Receive( "TheaterAnnouncement", function()
	AddAnnouncement( net.ReadTable() )
end )