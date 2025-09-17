if SERVER then
	AddCSLuaFile("schema.lua")
	AddCSLuaFile("colors.lua")
end

local Languages = {}
local DEBUG = false

-- Auto-load all language files
local languageFiles = file.Find("gamemodes/" .. GM.FolderName .. "/gamemode/i18n/languages/*.lua", "GAME")
for _, langFile in ipairs(languageFiles) do
	if SERVER then
		AddCSLuaFile("languages/" .. langFile)
	end

	if CLIENT then
		local langId = string.StripExtension(langFile)
		Languages[langId] = include("languages/" .. langFile)
		Languages[langId].Id = langId
	end
end

if SERVER then return end

local DefaultId = "en"
local CurrentId = GetConVar("gmod_language"):GetString()

local I18nColors = include("colors.lua")
local TranslationSchema = include("schema.lua")


-- Validation system
local function ValidateLanguage(langId, langData)
	local missing = {}
	for key in pairs(TranslationSchema) do
		if not langData[key] then
			table.insert(missing, key)
		end
	end

	if #missing > 0 and DEBUG then
		print("[I18n] Warning: Language '" .. langId .. "' missing keys: " .. table.concat(missing, ", "))
	end
end

-- Validate all loaded languages
for id, lang in pairs(Languages) do
	ValidateLanguage(id, lang)
end

-- Enhanced translation API
translations = {}

function translations:GetLanguage()
	return CurrentId
end

function translations:GetLanguages()
	return Languages
end

function translations:LanguageSupported()
	return Languages[self:GetLanguage()] and true or false
end

--[[
	Get a translation string with optional formatting

	USAGE EXAMPLES:

	-- Basic translation without parameters
	local title = translations:Get("Queue_Title")  -- Returns "QUEUE"

	-- Translation with string formatting parameters
	local playerMsg = translations:Get("Theater_VideoRequestedBy", "PlayerName")
	-- Returns: "{{highlight}}PlayerName{{default}} requested the current video."

	-- Multiple parameters
	local voteMsg = translations:Get("Theater_PlayerVoteSkipped", "PlayerName", "2", "5")
	-- Returns: "{{highlight}}PlayerName{{default}} has voted to skip {{highlight}}(2/5){{default}}."

	-- Fallback behavior - if key doesn't exist, returns the key itself
	local missing = translations:Get("NonExistent_Key")  -- Returns "NonExistent_Key"

	-- Used throughout the UI system like in scoreboard components:
	-- self.Title:SetText(translations:Get("Settings_Title"))  -- "SETTINGS"
	-- button:SetText(translations:Get("Request_Video"))       -- "Request video"
]]
function translations:Get(key, ...)
	if not key then return "" end
	local lang = self:GetLanguage()
	local value = Languages[lang] and Languages[lang][key] or Languages[DefaultId][key]
	if not value then
		if DEBUG then
			print("[I18n] Missing translation key: " .. key)
		end
		return key  -- Always return key as fallback
	end

	-- Handle formatting with placeholders
	if select("#", ...) > 0 then
		return string.format(value, ...)
	end
	return value
end

--[[
	Get a formatted translation with color processing for chat/UI display

	USAGE EXAMPLES:

	-- Basic formatted text for chat announcements
	local chatMsg = translations:GetFormatted("Theater_VideoRequestedBy", "PlayerName")
	-- Returns: {Color(255,255,255), "PlayerName", Color(200,200,200), " requested the current video."}

	-- Used in theater announcements (similar to current FormatChat usage):
	local announcement = translations:GetFormatted("Theater_ForceSkipped", ply:Nick())
	chat.AddText(unpack(announcement))

	-- For UI elements that need colored text:
	local voteText = translations:GetFormatted("Theater_PlayerVoteSkipped", ply:Nick(), "3", "5")
	-- Can be used with draw.SimpleText or other rendering functions

	-- Backward compatibility with existing FormatChat calls:
	-- OLD: translations:FormatChat("Theater_VideoRequestedBy", playerName)
	-- NEW: translations:GetFormatted("Theater_VideoRequestedBy", playerName)
]]
function translations:GetFormatted(key, ...)
	local value = self:Get(key, ...)
	return I18nColors:ProcessFormatting(value)
end

--[[
	BACKWARD COMPATIBILITY METHODS
	These maintain compatibility with existing Cinema gamemode code
]]

--[[
	Legacy Format method - maintains compatibility with existing code

	USAGE EXAMPLES:

	-- Existing code continues to work unchanged:
	local text = translations:Format("Theater_VideoRequestedBy", playerName)
	-- Returns raw string: "{{highlight}}PlayerName{{default}} requested the current video."

	-- Used in UI components like scoreboard settings:
	-- label:SetText(translations:Format("Settings_VolumeLabel"))
	-- tooltip:SetText(translations:Format("Settings_VolumeTooltip"))
]]
function translations:Format(key, ...)
	return self:Get(key, ...)
end

--[[
	Legacy FormatChat method - maintains compatibility with existing code

	USAGE EXAMPLES:

	-- Existing theater announcement code continues to work:
	local chatText = translations:FormatChat("Theater_Voteskipped")
	chat.AddText(unpack(chatText))

	-- Player action announcements:
	local resetMsg = translations:FormatChat("Theater_PlayerReset", ply:Nick())
	chat.AddText(unpack(resetMsg))

	-- This is equivalent to the new GetFormatted method
]]
function translations:FormatChat(key, ...)
	return self:GetFormatted(key, ...)
end

-- Language change callback
cvars.AddChangeCallback("gmod_language", function(_, value_old, value_new)
	if not CLIENT then return end
	CurrentId = Languages[value_new] and value_new or DefaultId
	RunConsoleCommand("cinema_langupdate")
end)