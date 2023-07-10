-- Common functions that are used in Cinema.

module("util", package.seeall)

MEDIA_ERR = { -- https://developer.mozilla.org/en-US/docs/Web/API/MediaError
	[1] = "The user canceled the media.", -- MEDIA_ERR_ABORTED
	[2] = "A network error occurred while fetching the media.", -- MEDIA_ERR_NETWORK
	[3] = "An error occurred while decoding the media.", -- MEDIA_ERR_DECODE
	[4] = "The audio is missing or is in a format not supported by your browser.", -- MEDIA_ERR_SRC_NOT_SUPPORTED
	[5] = "An unknown error occurred.", -- MEDIA_ERR_UNKOWN
}

-- Helper function for converting ISO 8601 time strings; this is the formatting
-- http://en.wikipedia.org/wiki/ISO_8601#Durations
function ISO_8601ToSeconds(str)
	local number = tonumber(str)
	if number then return number end

	str = str:lower()

	local h = str:match("(%d+)h") or 0
	local m = str:match("(%d+)m") or 0
	local s = str:match("(%d+)s") or 0
	return h * (60 * 60) + m * 60 + s
end

function SecondsToISO_8601(seconds)
	local t = string.FormattedTime( seconds )

	return (t.h and t.h .. "h" or "") .. (t.m and t.m .. "m" or "") .. (t.s and t.s .. "s" or "")
end

-- Get the value for an attribute from a html element
function ParseElementAttribute( element, attribute )
	if not element then return end
	-- Find the desired attribute
	local output = element:match( attribute .. "%s-=%s-%b\"\"" )
	if not output then return end
	-- Remove the 'attribute=' part
	output = output:gsub( attribute .. "%s-=%s-", "" )
	-- Trim the quotes around the value string
	return output:sub( 2, -2 )
end

-- Get the contents of a html element by removing tags
-- Used as fallback for when title cannot be found
function ParseElementContent( element )
	if not element then return end
	-- Trim start
	local output = element:gsub( "^%s-<%w->%s-", "" )
	-- Trim end
	return output:gsub( "%s-</%w->%s-$", "" )
end