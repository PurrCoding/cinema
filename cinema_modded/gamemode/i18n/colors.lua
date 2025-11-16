local I18nColors = {}

-- Color definitions from the original system
I18nColors.Highlight = Color(255, 255, 255)
I18nColors.Default = Color(200, 200, 200)

local patterns = {
	format = "{{%s:%s}}",
	tag = "{{.-}}",
	data = "{{(.-):(.-)}}",
	rgb = "(%d+),(%d+),(%d+)"
}

local function parseTag(tag)
	local key, value = tag:match(patterns.data)

	if key == "rgb" then
		local r, g, b = value:match(patterns.rgb)
		return Color(r, g, b)
	elseif key == "highlight" then
		return I18nColors.Highlight
	elseif key == "default" then
		return I18nColors.Default
	end

	return tag
end

function I18nColors:ProcessFormatting(value)
	if not value:find(patterns.tag) then
		return {value}
	end

	local tbl = {}

	while true do
		local start, stop = value:find(patterns.tag)

		if not start then
			if value ~= "" then
				table.insert(tbl, value)
			end
			break
		end

		if start > 0 then
			local str = value:sub(0, start - 1)
			table.insert(tbl, str)
		end

		local tag = value:sub(start, stop)
		table.insert(tbl, parseTag(tag))

		value = value:sub(stop + 1, #value)
	end

	return tbl
end

-- Helper function for creating formatted strings
function I18nColors:Compile(...)
	local str = ""
	for _, v in pairs({...}) do
		if istable(v) and v.r and v.g and v.b then
			local col = ("%d,%d,%d"):format(v.r, v.g, v.b)
			str = str .. patterns.format:format("rgb", col)
		else
			str = str .. tostring(v)
		end
	end
	return str
end

return I18nColors