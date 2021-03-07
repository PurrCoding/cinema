local math_pow = math.pow
local math_ceil = math.ceil
local math_log = math.log


-- Ceil the given number to the largest power of two
function math.power2(n)
	return math_pow(2, math_ceil(math_log(n) / math_log(2)))
end