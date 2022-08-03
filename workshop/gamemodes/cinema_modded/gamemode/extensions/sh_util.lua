-- Common functions that are used in Cinema.

module("util")

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