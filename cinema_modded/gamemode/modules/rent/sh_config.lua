module("rent", package.seeall)

-- Client-readable (replicated) ConVars ---------------------------------------

-- Points cost per minute of rent.
CreateConVar("cinema_rent_cost_per_minute", "10",
	{ FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Points cost per minute of rent.")

-- Maximum minutes a player may rent a theater.
CreateConVar("cinema_rent_max_time", "300",
	{ FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Maximum minutes a player may rent a theater.")

-- Minimum minutes a player may rent a theater.
CreateConVar("cinema_rent_min_time", "1",
	{ FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Minimum minutes a player may rent a theater.")

-- Use PointShop 2 premium points for rent instead of standard points.
CreateConVar("cinema_rent_ps2_premium", "0",
	{ FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Use PointShop 2 premium points for rent instead of standard points.")

-- Force a specific currency provider by id (e.g. "pointshop1", "pointshop2").
-- Leave empty to auto-detect the first available provider.
CreateConVar("cinema_rent_currency", "",
	{ FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Force a currency provider by id. Empty = auto-detect.")

-- Server-only ConVars --------------------------------------------------------

if SERVER then
	-- Rentable theaters cannot be used while unrented.
	CreateConVar("cinema_rent_prevent_unrented", "0",
		{ FCVAR_ARCHIVE }, "Rentable theaters cannot be used while unrented.")

	-- Admins may enter theaters they are filtered from.
	CreateConVar("cinema_rent_admins_ignore_filter", "1",
		{ FCVAR_ARCHIVE }, "Admins may enter theaters they are filtered from.")

	-- Alert admins when they enter a theater they are filtered from.
	CreateConVar("cinema_rent_admins_alert_filtered", "1",
		{ FCVAR_ARCHIVE }, "Alert admins when they enter a theater they are filtered from.")

	-- Alert superadmins when an admin enters a theater they are filtered from.
	CreateConVar("cinema_rent_super_alert_admin_filtered", "1",
		{ FCVAR_ARCHIVE }, "Alert superadmins when an admin enters a filtered theater.")
end

-- Accessors ------------------------------------------------------------------

function CostPerMinute()
	return GetConVar("cinema_rent_cost_per_minute"):GetInt()
end

function MaximumRentTime()
	return GetConVar("cinema_rent_max_time"):GetInt()
end

function MinimumRentTime()
	return GetConVar("cinema_rent_min_time"):GetInt()
end

function PS2UsePremiumPoints()
	return GetConVar("cinema_rent_ps2_premium"):GetBool()
end

-- Returns the forced provider id, or nil when unset (auto-detect).
function Currency()
	local value = GetConVar("cinema_rent_currency"):GetString()
	value = value:Trim()
	if value == "" then return nil end
	return value
end

function PreventUnrentedActivity()
	local cvar = GetConVar("cinema_rent_prevent_unrented")
	return cvar and cvar:GetBool() or false
end

function AdminsIgnoreFilter()
	local cvar = GetConVar("cinema_rent_admins_ignore_filter")
	return cvar and cvar:GetBool() or false
end

function AdminsAlertFiltered()
	local cvar = GetConVar("cinema_rent_admins_alert_filtered")
	return cvar and cvar:GetBool() or false
end

function SuperAlertAdminFiltered()
	local cvar = GetConVar("cinema_rent_super_alert_admin_filtered")
	return cvar and cvar:GetBool() or false
end