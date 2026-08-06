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
	Dependency_Missing_Line1 = "Blimey! Ye be missin' somethin'...",
	Dependency_Missing_Line2 = "Press F4 to open the instructions video.",

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
	Theater_Pause = "Drop Anchor",
	Theater_Resume = "Weigh Anchor",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} dropped anchor on the video, arr.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} set the video a-sailin' again.",

	-- Theater list
	TheaterList_NowShowing = "NOW SAILING",

	-- Request Panel
	Request_History = "Ledger",
	Request_Clear = "Erase",
	Request_DeleteTooltip = "Remove ship from Ledger",
	Request_PlayCount = "%d voyage(s)",
	Request_Url = "Request Ship",
	Request_Url_Tooltip = "Press to request a valid video URL.\nThe button'll be red when the URL be valid",
	Request_Filter_AllServices = "All fleets",
	Request_Filter_SortBy_LastRequest = "Last voyage",
	Request_Filter_SortBy_Alphabet = "Alphabetically",
	Request_Filter_SortBy_Duration = "Voyage length",
	Request_Filter_SortBy_RequestCount = "Voyage count",
	Request_Paginator_ResultCount = "%s ships",
	Request_Paginator_PageOf = "Page %d o' %d",

	-- Scoreboard settings panel
	Settings_Title = "SETTINGS",
	Settings_ClickActivate = "CLICK TO COMMAND YER MOUSE",
	Settings_VolumeLabel = "Loudness",
	Settings_VolumeTooltip = "Use the +/- keys to increase/decrease volume.",
	Settings_HidePlayersLabel = "Send crew to thar quarters.",
	Settings_HidePlayersTooltip = "Reduce player visibility inside of theaters.",
	Settings_MuteFocusLabel = "Silence noises while in quarters",
	Settings_MuteFocusTooltip = "Mute theater volume while Garry's Mod be out-of-focus (e.g. you alt-tabbed).",
	Settings_SmoothVideoLabel = "Smooth sailin' playback",
	Settings_SmoothVideoTooltip = "Make some ships sail smoother at the cost of FPS.",

	-- Video Services
	Service_EmbedDisabled = "The requested ship be unfit for the open sea.",
	Service_PurchasableContent = "The requested ship be too expensive to sail.",
	Service_StreamOffline = "The requested ship be a ghost.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Translations by %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s hour",
	Unit_Hours   = "%s hours",
	Unit_Minute  = "%s minute",
	Unit_Minutes = "%s minutes",
	Unit_Second  = "%s second",
	Unit_Seconds = "%s seconds",
	Currency_Points = "%s Doubloons",
	Currency_DonatorPoints = "%s Golden Doubloons",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "This harbour be public, ye cannot charter it!",
	Rent_AlreadyRentedBy = "This harbour be already chartered by {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Ye already hold the charter for {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Ye must charter for at least %s minute(s).",
	Rent_MaxTime = "Ye cannot charter for more than %s minute(s).",
	Rent_CantAfford = "Yer purse be too light for that charter (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} chartered this harbour for %s.",
	Rent_ExtendNotRenting = "Ye must already hold this charter to extend it!",
	Rent_ExtendMinTime = "Yer charter must total at least %s minute(s).",
	Rent_ExtendMaxTime = "Ye cannot charter past %s minute(s).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} extended thar charter of this harbour by another %s.",
	Rent_RefundNotRenting = "Ye must hold this charter to hand it back.",
	Rent_RefundNotEnoughTime = "Thar be not enough time left on the charter to hand it back.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} handed back thar charter of this harbour.",
	Rent_Refunded = "Ye were paid back %s for %s minute(s) of charter.",
	Rent_NotRented = "This harbour be not chartered at present.",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}'s charter of this harbour be scuttled by the harbourmaster.",
	Rent_CancelledOwner = "Yer charter be scuttled and ye were paid back %s for %s minute(s) of charter.",
	Rent_CancelledAdmin = "Ye scuttled the charter of {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Ye scuttled the charter, but its holder sailed off afore thar coin could be handed back.",
	Rent_ExpiredOwner = "Yer charter in {{rgb:158,37,33}}%s{{rgb:200,200,200}} has run dry.",
	Rent_ExpiredPublic = "This harbour's charter has run dry!",
	Rent_VoteSkipLocked = "The captain of this harbour has forbidden mutinies.",
	Rent_VoteSkipUnlocked = "The captain of this harbour has allowed mutinies again.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Ye cannot set a crew list on a public harbour!",
	Rent_FilterNotRented = "This harbour must be chartered afore ye set a crew list!",
	Rent_FilterNotOwner = "Ye must be captain of this harbour to set its crew list!",
	Rent_FilterUpdated = "The crew list has been updated.",
	Rent_FilterAdminWarn = "Harbourmaster Warning: Ye be struck from this harbour's crew list.",
	Rent_FilterSuperWarn = "Harbourmaster Warning: {{rgb:158,37,33}}%s{{rgb:200,200,200}} were struck from a harbour they be standin' in.",
	Rent_FilteredOut = "Ye've been struck from the harbour's crew list.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Ye hold the charter of this harbour for the next %s.",
	Rent_CurrentlyRentedBy = "This harbour be chartered by {{rgb:158,37,33}}%s{{rgb:200,200,200}} for the next %s.",
	Rent_MustBeRented = "This harbour must be chartered afore it can be used.",
	Rent_AdminFilteredWarn = "Harbourmaster Warning: Ye be struck from this harbour's crew list.",
	Rent_AdminEnteredFiltered = "Harbourmaster Warning: {{rgb:158,37,33}}%s{{rgb:200,200,200}} boarded a harbour they be struck from.",
	Rent_NotAllowed = "Ye be not welcome in this harbour.",
	Rent_VoteSkipDisabled = "Sorry matey, the captain of this harbour has forbidden mutinies.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Ye must stand in a harbour to scuttle its charter.",
	Rent_MustBeInTheaterFilter = "Ye must stand in yer harbour to set its crew list.",
	Rent_MustBeInTheaterSeeFilter = "Ye must stand in a harbour to read its crew list.",
	Rent_NotOwnerSeeFilter = "Ye must be captain of this harbour to read its crew list.",
	Rent_MustBeInTheaterVoteLock = "Ye must stand in a harbour to forbid mutinies.",
	Rent_NotOwnerVoteLock = "Ye must be captain of this harbour to meddle with mutinies.",
	Rent_MustBeInTheaterRent = "Ye must stand in a harbour to charter it!",
	Rent_MustBeInTheaterRefund = "Ye must stand in a harbour to hand back its charter!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Charter Harbour",
	Rent_Minutes = "Minutes",
	Rent_Purchase = "Strike a Deal",
	Rent_PurchaseFor = "Strike a Deal for %s",
	Rent_ToggleVoteSkipLock = "Toggle Mutiny Ban",
	Rent_PlayerFilter = "Crew List",
	Rent_AddRentTime = "Extend Charter",
	Rent_RefundButton = "Hand Back Charter",
	Rent_CancelButton = "Scuttle Charter",
	Rent_Remaining = "Charter Remaining",
	Rent_WhitelistMode = "Crew Mode",
	Rent_BlacklistMode = "Castaway Mode",
	Rent_Apply = "Aye, Apply",
	Rent_Retrieving = "Sailing...",
	Rent_Unknown = "Unknown",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Open Harbour",
	Rent_OwnerDisconnected = "Captain Overboard",
	Rent_ThumbRemaining = "Charter Remaining: %s",
}