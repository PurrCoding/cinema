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
	Theater_Pause = "Pause",
	Theater_Resume = "Resume",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has paused the video.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has resumed the video.",

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

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s hour",
	Unit_Hours   = "%s hours",
	Unit_Minute  = "%s minute",
	Unit_Minutes = "%s minutes",
	Unit_Second  = "%s second",
	Unit_Seconds = "%s seconds",
	Currency_Points = "%s Points",
	Currency_DonatorPoints = "%s Donator Points",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "This theater isn't private and cannot be rented!",
	Rent_AlreadyRentedBy = "This theater is already being rented by {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "You are already renting {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "You must rent for at least %s minute(s).",
	Rent_MaxTime = "You cannot rent for more than %s minute(s).",
	Rent_CantAfford = "You can't afford that rent (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has rented this theater for %s.",
	Rent_ExtendNotRenting = "You must already be renting this theater to extend your rent!",
	Rent_ExtendMinTime = "You must extend the rent to total at least %s minute(s).",
	Rent_ExtendMaxTime = "You cannot rent past %s minute(s).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has extended their rent of this theater for another %s.",
	Rent_RefundNotRenting = "You must be renting this theater to refund its rent.",
	Rent_RefundNotEnoughTime = "There isn't enough time left on the rent to refund it.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} has refunded their rent of this theater.",
	Rent_Refunded = "You were refunded %s for %s minute(s) of rent.",
	Rent_NotRented = "This theater isn't currently being rented.",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}'s rent of this theater was cancelled by an admin.",
	Rent_CancelledOwner = "Your rent was cancelled and you were refunded %s for %s minute(s) of rent.",
	Rent_CancelledAdmin = "You cancelled the rent of {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "You cancelled the rent, but its owner disconnected before they could be refunded.",
	Rent_ExpiredOwner = "Your rent in {{rgb:158,37,33}}%s{{rgb:200,200,200}} has run out.",
	Rent_ExpiredPublic = "This theater's rent has run out!",
	Rent_VoteSkipLocked = "The owner of this theater has locked vote skips.",
	Rent_VoteSkipUnlocked = "The owner of this theater has unlocked vote skips.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "You cannot set a player filter on a theater that isn't private!",
	Rent_FilterNotRented = "This theater must be rented before you can set a player filter on it!",
	Rent_FilterNotOwner = "You must be the owner of this theater to set a player filter on it!",
	Rent_FilterUpdated = "The player filter has been updated.",
	Rent_FilterAdminWarn = "Admin Warning: You are now filtered from this theater.",
	Rent_FilterSuperWarn = "Admin Warning: {{rgb:158,37,33}}%s{{rgb:200,200,200}} was filtered from a theater they're in.",
	Rent_FilteredOut = "You have been filtered from the theater.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "You are currently renting this theater for the next %s.",
	Rent_CurrentlyRentedBy = "This theater is currently being rented by {{rgb:158,37,33}}%s{{rgb:200,200,200}} for the next %s.",
	Rent_MustBeRented = "This theater must be rented in order to be used.",
	Rent_AdminFilteredWarn = "Admin Warning: You are filtered from this theater.",
	Rent_AdminEnteredFiltered = "Admin Warning: {{rgb:158,37,33}}%s{{rgb:200,200,200}} entered a theater they're filtered from.",
	Rent_NotAllowed = "You are not allowed in this theater.",
	Rent_VoteSkipDisabled = "Sorry, the owner of this theater has disabled vote skips.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "You must be in a theater to cancel its rent.",
	Rent_MustBeInTheaterFilter = "You must be in your theater to set its player filter.",
	Rent_MustBeInTheaterSeeFilter = "You must be in a theater to see its player filter.",
	Rent_NotOwnerSeeFilter = "You must own this theater to see its player filter.",
	Rent_MustBeInTheaterVoteLock = "You must be in a theater to lock vote skip.",
	Rent_NotOwnerVoteLock = "You must own this theater to modify vote skip.",
	Rent_MustBeInTheaterRent = "You must be in a theater to rent it!",
	Rent_MustBeInTheaterRefund = "You must be in a theater to refund its rent!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Rent Theater",
	Rent_Minutes = "Minutes",
	Rent_Purchase = "Purchase",
	Rent_PurchaseFor = "Purchase for %s",
	Rent_ToggleVoteSkipLock = "Toggle Vote Skip Lock",
	Rent_PlayerFilter = "Player Filter",
	Rent_AddRentTime = "Add Rent Time",
	Rent_RefundButton = "Refund Rent",
	Rent_CancelButton = "Cancel Rent",
	Rent_Remaining = "Rent Remaining",
	Rent_WhitelistMode = "Whitelist Mode",
	Rent_BlacklistMode = "Blacklist Mode",
	Rent_Apply = "Apply",
	Rent_Retrieving = "Retrieving...",
	Rent_Unknown = "Unknown",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Open",
	Rent_OwnerDisconnected = "Owner Disconnected",
	Rent_ThumbRemaining = "Rent Remaining: %s",
}
