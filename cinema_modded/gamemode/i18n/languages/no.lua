-- Norwegian language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: DoleDuck

return {
	-- Basic information (metadata)
	Name = "Norwegian",
	Author = "DoleDuck",

	-- Common UI elements
	Cinema = "KINO",
	Volume = "Volum",
	Voteskips = "Har stemt for å hoppe over",
	Loading = "Lader...",
	Invalid = "[UGYLDIG]",
	NoVideoPlaying = "Ingen Video Spiller",
	Cancel = "Avbryt",
	Set = "Sett",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Denne video er forespurt av {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Ugyldig video forespørsel.",
	Theater_AlreadyQueued = "Den forespurte videoen er allerede i køen.",
	Theater_ProcessingRequest = "Behandler {{rgb:158,37,33}}%s{{rgb:200,200,200}} forespørsel...",
	Theater_RequestFailed = "Det var et problem med å behandle den forespurte videoen.",
	Theater_Voteskipped = "Den gjeldende videoen har blitt stemt bort.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har hoppet over denne videoen.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har tilbakestillt kinoen.",
	Theater_LostOwnership = "Du har mistet eierskapet fordi du har forlatt kinoen.",
	Theater_NotifyOwnership = "Du er nå eieren av denne kinoen.",
	Theater_OwnerLockedQueue = "Eieren av kinoen har stengt køen.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har stengt køen.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har åpnet køen.",
	Theater_OwnerUseOnly = "Bare eieren av kinoen kan gjøre det.",
	Theater_PublicVideoLength = "Forespørsler i offentlige kinoer har en frist på %s sekund(er).",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har stemt for å hoppe over {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har blitt lagt til i køen.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Den gjeldene banen er ikke støtter av Cinema gamemode",
	Warning_Unsupported_Line2 = "Trykk F1 for å åpne den offisielle banen i workshop",
	Dependency_Missing_Line1 = "Oops! Du mangler noe...",
	Dependency_Missing_Line2 = "Trykk F4 for å åpne instruksjonsvideoen.",

	-- Queue interface
	Queue_Title = "KØ",
	Request_Video = "Spør om en video",
	Vote_Skip = "Stem for å hoppe over",
	Toggle_Fullscreen = "Veksle mellom fullskjerm",
	Refresh_Theater = "Oppdater Kino",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "EIER",
	Theater_Skip = "Hopp over",
	Theater_Seek = "Søk",
	Theater_Reset = "Tilbakestill",
	Theater_ChangeName = "Bytt navn",
	Theater_QueueLock = "Lås/åpne køen",
	Theater_SeekQuery = "HH:MM:SS eller antall sekunder (f.eks. 1:30:00 eller 5400)",
	Theater_Pause = "Pause",
	Theater_Resume = "Fortsett",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} satte videoen på pause.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} fortsatte videoen.",

	-- Theater list
	TheaterList_NowShowing = "VISER NÅ",

	-- Request Panel
	Request_History = "HISTORIE",
	Request_Clear = "Slett",
	Request_DeleteTooltip = "Fjern video fra histore",
	Request_PlayCount = "%d forespørsel(er)",
	Request_Url = "Be om en URL",
	Request_Url_Tooltip = "Klikk for å be om en gyldig video URL.\nKnappen vil bli rød når URL'en er ugyldig",
	Request_Filter_AllServices = "Alle tjenester",
	Request_Filter_SortBy_LastRequest = "Siste forespørsel",
	Request_Filter_SortBy_Alphabet = "Alfabetisk",
	Request_Filter_SortBy_Duration = "Varighet",
	Request_Filter_SortBy_RequestCount = "Antall forespørsler",
	Request_Paginator_ResultCount = "%s resultater",
	Request_Paginator_PageOf = "Side %d av %d",

	-- Scoreboard settings panel
	Settings_Title = "INNSTILLINGER",
	Settings_ClickActivate = "KLIKK FOR Å AKTIVERE MUSEN",
	Settings_VolumeLabel = "Volum",
	Settings_VolumeTooltip = "Bruk +/- tastene for å øke/redusere volumet.",
	Settings_HidePlayersLabel = "Skjul Spillere I Kino",
	Settings_HidePlayersTooltip = "Reduser spiller synlighet inne i kinoene.",
	Settings_MuteFocusLabel = "Skru av lyd mens du er alt-tabbet",
	Settings_MuteFocusTooltip = "Skru av kino lyden mens Garry's Mod er ute av fokus (f.eks. i alt-tab).",
	Settings_SmoothVideoLabel = "Jevn videoavspilling",
	Settings_SmoothVideoTooltip = "Gjør noen videoer jevnere på bekostning av FPS.",

	-- Video Services
	Service_EmbedDisabled = "Innholdet til den følgende videoen er slått av.",
	Service_PurchasableContent = "Den forespurte videoen er kjøpt innhold og kan ikke bli spilt av.",
	Service_StreamOffline = "Den forespurte stream er offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Oversettelse av %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s time",
	Unit_Hours   = "%s timer",
	Unit_Minute  = "%s minutt",
	Unit_Minutes = "%s minutter",
	Unit_Second  = "%s sekund",
	Unit_Seconds = "%s sekunder",
	Currency_Points = "%s Poeng",
	Currency_DonatorPoints = "%s Donatorpoeng",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Denne kinoen er ikke privat og kan ikke leies!",
	Rent_AlreadyRentedBy = "Denne kinoen leies allerede av {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Du leier allerede {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Du må leie i minst %s minutt(er).",
	Rent_MaxTime = "Du kan ikke leie i mer enn %s minutt(er).",
	Rent_CantAfford = "Du har ikke råd til den leien (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har leid denne kinoen i %s.",
	Rent_ExtendNotRenting = "Du må allerede leie denne kinoen for å forlenge leien din!",
	Rent_ExtendMinTime = "Du må forlenge leien til totalt minst %s minutt(er).",
	Rent_ExtendMaxTime = "Du kan ikke leie forbi %s minutt(er).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har forlenget leien av denne kinoen med ytterligere %s.",
	Rent_RefundNotRenting = "Du må leie denne kinoen for å refundere leien.",
	Rent_RefundNotEnoughTime = "Det er ikke nok tid igjen på leien til å refundere den.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} har refundert leien av denne kinoen.",
	Rent_Refunded = "Du ble refundert %s for %s minutt(er) med leie.",
	Rent_NotRented = "Denne kinoen leies for øyeblikket ikke.",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} sin leie av denne kinoen ble avbrutt av en admin.",
	Rent_CancelledOwner = "Leien din ble avbrutt og du ble refundert %s for %s minutt(er) med leie.",
	Rent_CancelledAdmin = "Du avbrøt leien til {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Du avbrøt leien, men eieren koblet fra før de kunne bli refundert.",
	Rent_ExpiredOwner = "Leien din i {{rgb:158,37,33}}%s{{rgb:200,200,200}} har gått ut.",
	Rent_ExpiredPublic = "Leien av denne kinoen har gått ut!",
	Rent_VoteSkipLocked = "Eieren av denne kinoen har låst stemmehopp.",
	Rent_VoteSkipUnlocked = "Eieren av denne kinoen har låst opp stemmehopp.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Du kan ikke sette et spillerfilter på en kino som ikke er privat!",
	Rent_FilterNotRented = "Denne kinoen må leies før du kan sette et spillerfilter på den!",
	Rent_FilterNotOwner = "Du må være eieren av denne kinoen for å sette et spillerfilter på den!",
	Rent_FilterUpdated = "Spillerfilteret har blitt oppdatert.",
	Rent_FilterAdminWarn = "Admin-advarsel: Du er nå filtrert ut fra denne kinoen.",
	Rent_FilterSuperWarn = "Admin-advarsel: {{rgb:158,37,33}}%s{{rgb:200,200,200}} ble filtrert ut fra en kino de er i.",
	Rent_FilteredOut = "Du har blitt filtrert ut fra kinoen.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Du leier for øyeblikket denne kinoen for de neste %s.",
	Rent_CurrentlyRentedBy = "Denne kinoen leies for øyeblikket av {{rgb:158,37,33}}%s{{rgb:200,200,200}} for de neste %s.",
	Rent_MustBeRented = "Denne kinoen må leies for å kunne brukes.",
	Rent_AdminFilteredWarn = "Admin-advarsel: Du er filtrert ut fra denne kinoen.",
	Rent_AdminEnteredFiltered = "Admin-advarsel: {{rgb:158,37,33}}%s{{rgb:200,200,200}} gikk inn i en kino de er filtrert ut fra.",
	Rent_NotAllowed = "Du har ikke tilgang til denne kinoen.",
	Rent_VoteSkipDisabled = "Beklager, eieren av denne kinoen har deaktivert stemmehopp.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Du må være i en kino for å avbryte leien.",
	Rent_MustBeInTheaterFilter = "Du må være i kinoen din for å sette spillerfilteret.",
	Rent_MustBeInTheaterSeeFilter = "Du må være i en kino for å se spillerfilteret.",
	Rent_NotOwnerSeeFilter = "Du må eie denne kinoen for å se spillerfilteret.",
	Rent_MustBeInTheaterVoteLock = "Du må være i en kino for å låse stemmehopp.",
	Rent_NotOwnerVoteLock = "Du må eie denne kinoen for å endre stemmehopp.",
	Rent_MustBeInTheaterRent = "Du må være i en kino for å leie den!",
	Rent_MustBeInTheaterRefund = "Du må være i en kino for å refundere leien!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Lei Kino",
	Rent_Minutes = "Minutter",
	Rent_Purchase = "Kjøp",
	Rent_PurchaseFor = "Kjøp for %s",
	Rent_ToggleVoteSkipLock = "Veksle Stemmehopp-lås",
	Rent_PlayerFilter = "Spillerfilter",
	Rent_AddRentTime = "Legg Til Leietid",
	Rent_RefundButton = "Refunder Leie",
	Rent_CancelButton = "Avbryt Leie",
	Rent_Remaining = "Gjenstående Leie",
	Rent_WhitelistMode = "Hvitliste-modus",
	Rent_BlacklistMode = "Svarteliste-modus",
	Rent_Apply = "Bruk",
	Rent_Retrieving = "Henter...",
	Rent_Unknown = "Ukjent",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Åpen",
	Rent_OwnerDisconnected = "Eier Frakoblet",
	Rent_ThumbRemaining = "Gjenstående Leie: %s",
}