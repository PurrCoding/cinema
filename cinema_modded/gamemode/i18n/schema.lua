-- Define all required translation keys for Cinema gamemode i18n system
-- This schema ensures consistency across all language files

return {
	-- Basic information (metadata)
	Name = true,
	Author = true,

	-- Common UI elements
	Cinema = true,
	Volume = true,
	Voteskips = true,
	Loading = true,
	Invalid = true,
	NoVideoPlaying = true,
	Cancel = true,
	Set = true,

	-- Theater Announcements
	Theater_VideoRequestedBy = true,
	Theater_InvalidRequest = true,
	Theater_AlreadyQueued = true,
	Theater_ProcessingRequest = true,
	Theater_RequestFailed = true,
	Theater_Voteskipped = true,
	Theater_ForceSkipped = true,
	Theater_PlayerReset = true,
	Theater_LostOwnership = true,
	Theater_NotifyOwnership = true,
	Theater_OwnerLockedQueue = true,
	Theater_LockedQueue = true,
	Theater_UnlockedQueue = true,
	Theater_OwnerUseOnly = true,
	Theater_PublicVideoLength = true,
	Theater_PlayerVoteSkipped = true,
	Theater_VideoAddedToQueue = true,

	-- Warning messages
	Warning_Unsupported_Line1 = true,
	Warning_Unsupported_Line2 = true,
	Dependency_Missing_Line1 = true,
	Dependency_Missing_Line2 = true,

	-- Queue interface
	Queue_Title = true,
	Request_Video = true,
	Vote_Skip = true,
	Toggle_Fullscreen = true,
	Refresh_Theater = true,

	-- Theater controls
	Theater_Admin = true,
	Theater_Owner = true,
	Theater_Skip = true,
	Theater_Seek = true,
	Theater_Reset = true,
	Theater_ChangeName = true,
	Theater_QueueLock = true,
	Theater_SeekQuery = true,

	-- Theater list
	TheaterList_NowShowing = true,

	-- Request Panel
	Request_History = true,
	Request_Clear = true,
	Request_DeleteTooltip = true,
	Request_PlayCount = true,
	Request_Url = true,
	Request_Url_Tooltip = true,
	Request_Filter_AllServices = true,
	Request_Filter_SortBy_LastRequest = true,
	Request_Filter_SortBy_Alphabet = true,
	Request_Filter_SortBy_Duration = true,
	Request_Filter_SortBy_RequestCount = true,
	Request_Paginator_ResultCount = true,
	Request_Paginator_PageOf = true,

	-- Scoreboard settings panel
	Settings_Title = true,
	Settings_ClickActivate = true,
	Settings_VolumeLabel = true,
	Settings_VolumeTooltip = true,
	Settings_HidePlayersLabel = true,
	Settings_HidePlayersTooltip = true,
	Settings_MuteFocusLabel = true,
	Settings_MuteFocusTooltip = true,
	Settings_SmoothVideoLabel = true,
	Settings_SmoothVideoTooltip = true,

	-- Video Services
	Service_EmbedDisabled = true,
	Service_PurchasableContent = true,
	Service_StreamOffline = true,

	-- Act command (special case)
	ActCommand = true,

	-- Credits
	TranslationsCredit = true,
}