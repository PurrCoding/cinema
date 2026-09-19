---@diagnostic disable: undefined-field

module("rent", package.seeall)

Currencies = Currencies or {}

-- Register a currency provider.
--   id       : unique string identifier
--   provider : table implementing:
--                IsAvailable(ply) -> bool   (optional; whether this provider can be used)
--                CanAfford(ply, cost) -> bool
--                Take(ply, cost)
--                Give(ply, value)
--                Format(amount, ply) -> string   (e.g. "10 Points")
function RegisterCurrency(id, provider)
	provider.id = id
	Currencies[id] = provider
end

-- Resolve the active currency provider for a player.
-- Set cinema_rent_currency to force a provider by id,
-- otherwise the first available provider is auto-detected.
function GetProvider(ply)
	local forced = rent.Currency()
	if forced and Currencies[forced] then
		return Currencies[forced]
	end

	for _, provider in pairs(Currencies) do
		if not provider.IsAvailable or provider.IsAvailable(ply) then
			return provider
		end
	end

	return nil
end

-- Format an amount using the active provider (falls back to plain "Points").
function FormatCost(amount, ply)
	local provider = GetProvider(ply)
	if provider and provider.Format then
		return provider.Format(amount, ply)
	end

	return translations:Format("Currency_Points", amount)
end

-- Built-in provider: PointShop 2
RegisterCurrency("pointshop2", {
	IsAvailable = function(ply)
		if SERVER then
			return ply.PS2_Wallet ~= nil
		else
			return Pointshop2 ~= nil
		end
	end,
	CanAfford = function(ply, cost)
		if rent.PS2UsePremiumPoints() then
			return ply.PS2_Wallet.premiumPoints >= cost
		else
			return ply.PS2_Wallet.points >= cost
		end
	end,
	Take = function(ply, cost)
		if rent.PS2UsePremiumPoints() then
			ply:PS2_AddPremiumPoints(-cost)
		else
			ply:PS2_AddStandardPoints(-cost, "Private theater rent")
		end
	end,
	Give = function(ply, value)
		if rent.PS2UsePremiumPoints() then
			ply:PS2_AddPremiumPoints(value)
		else
			ply:PS2_AddStandardPoints(value, "Private theater refund")
		end
	end,
	Format = function(amount, ply)
		if rent.PS2UsePremiumPoints() then
			return translations:Format("Currency_DonatorPoints", amount)
		else
			return translations:Format("Currency_Points", amount)
		end
	end
})

-- Built-in provider: PointShop 1
RegisterCurrency("pointshop1", {
	IsAvailable = function(ply)
		if SERVER then
			return ply.PS_HasPoints ~= nil
		else
			return PS ~= nil
		end
	end,
	CanAfford = function(ply, cost)
		return ply:PS_HasPoints(cost)
	end,
	Take = function(ply, cost)
		ply:PS_TakePoints(cost)
	end,
	Give = function(ply, value)
		ply:PS_GivePoints(value)
	end,
	Format = function(amount, ply)
		return translations:Format("Currency_Points", amount)
	end
})