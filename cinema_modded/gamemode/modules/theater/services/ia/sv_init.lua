local SERVICE = include "cl_init.lua"
if not SERVICE then return end

-- format support
local VALID_FORMATS = {
	["MPEG4"] = true,
	["h.264"] = true,
	["h.264 IA"] = true,
	["Ogg Video"] = true,
	["WebM"] = true,
	["MP4"] = true,
	["AVI"] = true,
	["MOV"] = true,
	["MKV"] = true,
	["Flac"] = true,
	["VBR MP3"] = true,
}

-- file selection logic
local function FindBestVideoFile(files, requestedFile)
	local candidates = {}

	for _, file in pairs(files) do
		if VALID_FORMATS[file.format] and file.name then
			-- Prioritize requested file
			if requestedFile then
				local normalizedRequested = requestedFile:gsub("+", " ")
				local normalizedFile = file.name:gsub("+", " ")

				if file.original == normalizedRequested
					or file.name == requestedFile
					or normalizedFile == normalizedRequested then
					return file
				end
			end

			table.insert(candidates, file)
		end
	end

	if #candidates == 0 then return nil end

	-- If no file was requested, take the first one from the list
	return candidates[1]
end

-- length parsing
local function ParseLength(value)
	if value == nil then return nil end

	-- Plain seconds string/number, e.g. "213.44"
	local seconds = tonumber(value)
	if isnumber(seconds) then
		return seconds
	end

	-- Colon-separated time string: MM:SS or HH:MM:SS
	if isstring(value) then
		local parts = string.Explode(":", value)
		local total = 0

		for _, part in ipairs(parts) do
			local n = tonumber(part)
			if not isnumber(n) then
				return nil -- unparseable segment
			end
			total = total * 60 + n
		end

		if #parts > 0 then
			return total
		end
	end

	return nil
end

-- title generation
local function GenerateTitle(response, file, identifier)
	if response.metadata and response.metadata.title then
		local title = response.metadata.title
		if istable(title) then
			title = title[1] or identifier
		end

		-- Add file info if it's part of a collection
		if file.name and file.name ~= title then
			local fileName = file.name:gsub("%.%w+$", "") -- Remove extension
			fileName = fileName:gsub("+", " ") -- Replace + with spaces
			return title .. " - " .. fileName
		end

		return title
	end

	-- Fallback to file name
	if file.name then
		local title = file.name:gsub("%.%w+$", ""):gsub("+", " ")
		return title
	end

	return "Internet Archive: " .. identifier
end

-- thumbnail handling
local function GetThumbnail(files, videoFileName)
	local baseName = videoFileName:gsub("%.%w+$", "")

	for _, file in pairs(files) do
		if file.format == "Thumbnail" then
			-- Look for thumbnails matching the video file
			if file.original and file.original:find(baseName, 1, true) then
				return file.name
			end
		end
	end

	-- no thumbnail
	return nil
end

-- API endpoints
local METADATA_URL = "https://archive.org/metadata/%s"

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local parts = string.Explode(",", data:Data())
	local identifier = parts[1]
	local requestedFile = parts[2]

	local function processMetadata(body, length, headers, code)
		if code ~= 200 or not body then
			return onFailure("Failed to fetch metadata from Internet Archive")
		end

		local response = util.JSONToTable(body)
		if not response or not response.files then
			return onFailure("Invalid metadata response")
		end

		local bestMatch = FindBestVideoFile(response.files, requestedFile)
		if not bestMatch then
			return onFailure("No compatible video files found")
		end

		local duration = ParseLength(bestMatch.length)
		if not isnumber(duration) then
			return onFailure("Invalid video length in metadata")
		end

		local info = {
			title = GenerateTitle(response, bestMatch, identifier),
			duration = math.Round(duration),
			thumbnail = GetThumbnail(response.files, bestMatch.name),
		}

		if onSuccess then
			pcall(onSuccess, info)
		end
	end

	local url = METADATA_URL:format(identifier)
	self:Fetch(url, processMetadata, onFailure)
end

theater.RegisterService("ia", SERVICE)
