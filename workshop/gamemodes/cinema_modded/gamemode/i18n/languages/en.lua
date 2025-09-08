-- English language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: PixelTail Games

return {
	-- Basic information (metadata)
	Name = "English",
	Author = "PixelTail Games",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Volume",
	Voteskips = "Voteskips",
	Loading = "Loading...",
	Invalid = "[INVALID]",
	NoVideoPlaying = "No video playing",
	Cancel = "Cancel",
	Set = "Set",

	-- Theater Announcements
	Theater_VideoRequestedBy = "The current video was requested by {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Invalid video request.",
	Theater_AlreadyQueued = "The requested video is already in the queue.",
	Theater_ProcessingRequest = "Processing {{rgb:158,37,33}}%s{{rgb:200,200,200}} request...",
	Theater_RequestFailed = "There was a problem processing the requested video.",
	Theater_Voteskipped = "The current video has been voteskipped.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has forced the current video to be skipped.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has reset the theater.",
	Theater_LostOwnership = "You have lost theater ownership due to leaving the theater.",
	Theater_NotifyOwnership = "You are now the owner of the private theater.",
	Theater_OwnerLockedQueue = "The owner of the theater has locked the queue.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has locked the theater queue.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has unlocked the theater queue.",
	Theater_OwnerUseOnly = "Only the theater owner can use that.",
	Theater_PublicVideoLength = "Public theater requests are limited to %s seconds in length.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has voted to skip {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has been added to the queue.",

	-- Warning messages
	Warning_Unsupported_Line1 = "The current map is unsupported by the Cinema gamemode.",
	Warning_Unsupported_Line2 = "Press F1 to open the official map on the Steam Workshop.",
	Dependency_Missing_Line1 = "Oops! You are missing something...",
	Dependency_Missing_Line2 = "Press F4 to open the instructions video.",

	-- Queue interface
	Queue_Title = "QUEUE",
	Request_Video = "Request video",
	Vote_Skip = "Vote to skip",
	Toggle_Fullscreen = "Toggle fullscreen",
	Refresh_Theater = "Refresh theater",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "OWNER",
	Theater_Skip = "Skip",
	Theater_Seek = "Seek",
	Theater_Reset = "Reset",
	Theater_ChangeName = "Change name",
	Theater_QueueLock = "Toggle queue lock",
	Theater_SeekQuery = "HH:MM:SS or number of seconds (e.g. 1:30:00 or 5400)",

	-- Theater list
	TheaterList_NowShowing = "NOW PLAYING",

	-- Request Panel
	Request_History = "HISTORY",
	Request_Clear = "Clear",
	Request_DeleteTooltip = "Remove this video from history",
	Request_PlayCount = "%d request(s)",
	Request_Url = "Request URL",
	Request_Url_Tooltip = "Press to request a video from a valid URL.\nThe button will turn red when the URL is valid.",
	Request_Filter_AllServices = "All services",
	Request_Filter_SortBy_LastRequest = "Last request",
	Request_Filter_SortBy_Alphabet = "Alphabetically",
	Request_Filter_SortBy_Duration = "Duration",
	Request_Filter_SortBy_RequestCount = "Request count",
	Request_Paginator_ResultCount = "%s results",
	Request_Paginator_PageOf = "Page %d of %d",

	-- Scoreboard settings panel
	Settings_Title = "SETTINGS",
	Settings_ClickActivate = "CLICK TO ACTIVATE YOUR MOUSE",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Use the \"+\" and \"-\" keys to increase or decrease the volume.",
	Settings_HidePlayersLabel = "Hide players in theaters",
	Settings_HidePlayersTooltip = "Reduces player visibility inside of theaters.",
	Settings_MuteFocusLabel = "Mute audio while alt-tabbed",
	Settings_MuteFocusTooltip = "Mutes theater volume while Garry's Mod is out-of-focus (e.g. while alt-tabbed).",
	Settings_SmoothVideoLabel = "Smooth video playback",
	Settings_SmoothVideoTooltip = "Make some videos smoother at the cost of FPS.",

	-- Video Services
	Service_EmbedDisabled = "The requested video has disabled embed support.",
	Service_PurchasableContent = "The requested video is a paid content and cannot be played.",
	Service_StreamOffline = "The requested stream is offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Translations made by %s",

}
