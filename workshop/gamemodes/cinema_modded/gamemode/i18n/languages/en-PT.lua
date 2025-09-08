-- Pirate Speak language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: HawkBlock

return {
	-- Basic information (metadata)
	Name = "Pirate Speak",
	Author = "HawkBlock",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Loudness",
	Voteskips = "Mutinies",
	Loading = "Sailing...",
	Invalid = "[INVALID]",
	NoVideoPlaying = "No ships sailing",
	Cancel = "Abandon ship",
	Set = "Set",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Commander of this ship be {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Invalid ship request.",
	Theater_AlreadyQueued = "The requested ship already be in harbour.",
	Theater_ProcessingRequest = "Processing {{rgb:158,37,33}}%s{{rgb:200,200,200}} request...",
	Theater_RequestFailed = "The requested ship sank.",
	Theater_Voteskipped = "The ship's been taken over by rebellious crew!",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} sank the vessel.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} swabbed the poopdeck!",
	Theater_LostOwnership = "Ye've lost command of the harbour!",
	Theater_NotifyOwnership = "Yer the captain now!",
	Theater_OwnerLockedQueue = "The captain closed the harbour.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} closed the harbour.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} opened the harbour.",
	Theater_OwnerUseOnly = "Only the captain can do that.",
	Theater_PublicVideoLength = "New ship requests may only be %s second(s) in length.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} sunk the {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}!",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} sailed into harbour.",

	-- Warning messages
	Warning_Unsupported_Line1 = "The current map be unsupported by the Cinema gamemode",
	Warning_Unsupported_Line2 = "Press F1 to open the official map on workshop",

	-- Queue interface
	Queue_Title = "Harbour (Queue)",
	Request_Video = "Add Ship (Request Video)",
	Vote_Skip = "Join Mutiny (Voteskip)",
	Toggle_Fullscreen = "Toggle Fullscreen",
	Refresh_Theater = "Swab the Poopdeck (Reset Theater)",

	-- Theater controls
	Theater_Admin = "HARBOURMASTER",
	Theater_Owner = "CAPTAIN",
	Theater_Skip = "Sink",
	Theater_Seek = "Seek",
	Theater_Reset = "Swab the Poopdeck (Reset)",
	Theater_ChangeName = "Rename Vessel",
	Theater_QueueLock = "Close the Harbour",
	Theater_SeekQuery = "HH:MM:SS or number of seconds (e.g. 1:30:00 or 5400)",

	-- Theater list
	TheaterList_NowShowing = "NOW SAILING",

	-- Request Panel
	Request_History = "Ledger",
	Request_Clear = "Erase",
	Request_DeleteTooltip = "Remove ship from Ledger",
	Request_PlayCount = "%d voyage(s)",
	Request_Url = "Request Ship",
	Request_Url_Tooltip = "Press to request a valid video URL.\nThe button'll be red when the URL be valid",

	-- Scoreboard settings panel
	Settings_Title = "SETTINGS",
	Settings_ClickActivate = "CLICK TO COMMAND YER MOUSE",
	Settings_VolumeLabel = "Loudness",
	Settings_VolumeTooltip = "Use the +/- keys to increase/decrease volume.",
	Settings_HidePlayersLabel = "Send crew to thar quarters.",
	Settings_HidePlayersTooltip = "Reduce player visibility inside of theaters.",
	Settings_MuteFocusLabel = "Silence noises while in quarters",
	Settings_MuteFocusTooltip = "Mute theater volume while Garry's Mod be out-of-focus (e.g. you alt-tabbed).",

	-- Video Services
	Service_EmbedDisabled = "The requested ship be unfit for the open sea.",
	Service_PurchasableContent = "The requested ship be too expensive to sail.",
	Service_StreamOffline = "The requested ship be a ghost.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Translations by %s",

}
