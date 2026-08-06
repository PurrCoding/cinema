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
	Theater_PlayerPaused = true,
	Theater_PlayerResumed = true,

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
	Theater_Pause = true,
	Theater_Resume = true,

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

	-- Theater Rentals: units
	Unit_Hour = true, Unit_Hours = true,
	Unit_Minute = true, Unit_Minutes = true,
	Unit_Second = true, Unit_Seconds = true,
	Currency_Points = true, Currency_DonatorPoints = true,

	-- Theater Rentals: lifecycle
	Rent_NotPrivate = true, Rent_AlreadyRentedBy = true, Rent_AlreadyRentingOther = true,
	Rent_MinTime = true, Rent_MaxTime = true, Rent_CantAfford = true, Rent_HasRented = true,
	Rent_ExtendNotRenting = true, Rent_ExtendMinTime = true, Rent_ExtendMaxTime = true, Rent_HasExtended = true,
	Rent_RefundNotRenting = true, Rent_RefundNotEnoughTime = true, Rent_HasRefunded = true, Rent_Refunded = true,
	Rent_NotRented = true, Rent_CancelledPublic = true, Rent_CancelledOwner = true,
	Rent_CancelledAdmin = true, Rent_CancelledAdminUnknown = true,
	Rent_ExpiredOwner = true, Rent_ExpiredPublic = true,
	Rent_VoteSkipLocked = true, Rent_VoteSkipUnlocked = true,

	-- Theater Rentals: filter
	Rent_FilterNotPrivate = true, Rent_FilterNotRented = true, Rent_FilterNotOwner = true,
	Rent_FilterUpdated = true, Rent_FilterAdminWarn = true, Rent_FilterSuperWarn = true, Rent_FilteredOut = true,

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = true, Rent_CurrentlyRentedBy = true, Rent_MustBeRented = true,
	Rent_AdminFilteredWarn = true, Rent_AdminEnteredFiltered = true, Rent_NotAllowed = true, Rent_VoteSkipDisabled = true,

	-- Theater Rentals: net & shared
	Rent_MustBeInTheaterCancel = true, Rent_MustBeInTheaterFilter = true, Rent_MustBeInTheaterSeeFilter = true,
	Rent_NotOwnerSeeFilter = true, Rent_MustBeInTheaterVoteLock = true, Rent_NotOwnerVoteLock = true,
	Rent_MustBeInTheaterRent = true, Rent_MustBeInTheaterRefund = true,

	-- Theater Rentals: UI
	Rent_RentTheater = true, Rent_Minutes = true, Rent_Purchase = true, Rent_PurchaseFor = true,
	Rent_ToggleVoteSkipLock = true, Rent_PlayerFilter = true, Rent_AddRentTime = true,
	Rent_RefundButton = true, Rent_CancelButton = true, Rent_Remaining = true,
	Rent_WhitelistMode = true, Rent_BlacklistMode = true, Rent_Apply = true, Rent_Retrieving = true, Rent_Unknown = true,

	-- Theater Rentals: thumbnail overlay
	Rent_Open = true, Rent_OwnerDisconnected = true, Rent_ThumbRemaining = true,
}