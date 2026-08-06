-- Deutsch
-- Author: Sapd

return {
	-- Basic information (metadata)
	Name = "Deutsch",
	Author = "Sapd",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Lautstärke",
	Voteskips = "Abwählungen",
	Loading = "Lade...",
	Invalid = "[UNGÜLTIG]",
	NoVideoPlaying = "Kein aktives Video",
	Cancel = "Abbrechen",
	Set = "Anwenden",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Aktuelles Video angefordert von {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Ungültiger Video Wunsch.",
	Theater_AlreadyQueued = "Das angeforderte Video ist bereits in der Warteschlange.",
	Theater_ProcessingRequest = "Verarbeite {{rgb:158,37,33}}%s{{rgb:200,200,200}} Wunsch...",
	Theater_RequestFailed = "Es gab ein Problem bei der Verarbeitung des angeforderten Videos.",
	Theater_Voteskipped = "Das aktuelle Video wurde abgewählt.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat das Überspringen des Videos erzwungen.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat das Theater zurückgesetzt.",
	Theater_LostOwnership = "Da du das Theater verlassen hast, bist du nicht mehr der Besitzer.",
	Theater_NotifyOwnership = "Du bist nun der Besitzer des privaten Theaters.",
	Theater_OwnerLockedQueue = "Der Besitzer des Theaters hat die Warteschlange gesperrt.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat die Warteschlange des Theaters gesperrt.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat die Warteschlange des Theaters freigegeben.",
	Theater_OwnerUseOnly = "Nur der Besitzer des Theaters kann das benutzen.",
	Theater_PublicVideoLength = "Videowünsche in öffentlichen Theatern sind auf %s Sekunden begrenzt.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat dafür gestimmt, das Video zu überspringen {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} wurde zur Warteschlange hinzugefügt.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Die aktuelle Map wird nicht vom Cinema Gamemode unterstützt.",
	Warning_Unsupported_Line2 = "Drücke F1 um die offizielle Map im Workshop zu öffnen.",
	Dependency_Missing_Line1 = "Ups... du hast etwas übersehen!",
	Dependency_Missing_Line2 = "Drücke F4 um die Anleitungsvideo zu öffnen.",

	-- Queue interface
	Queue_Title = "WARTESCHLANGE",
	Request_Video = "Video anfordern",
	Vote_Skip = "Für Überspringen stimmen",
	Toggle_Fullscreen = "Vollbildmodus umschalten",
	Refresh_Theater = "Theater neu laden",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "BESITZER",
	Theater_Skip = "Überspringen",
	Theater_Seek = "Starten bei...",
	Theater_Reset = "Zurücksetzen",
	Theater_ChangeName = "Name ändern",
	Theater_QueueLock = "Warteliste ein/aus",
	Theater_SeekQuery = "HH:MM:SS oder Zeit in Sekunden (z.B. 1:30:00 oder 5400)",
	Theater_Pause = "Pause",
	Theater_Resume = "Fortsetzen",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat das Video pausiert.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat das Video fortgesetzt.",

	-- Theater list
	TheaterList_NowShowing = "AKTUELLE VORFÜHRUNGEN",

	-- Request Panel
	Request_History = "VERLAUF",
	Request_Clear = "Verlauf löschen",
	Request_DeleteTooltip = "Video vom Verlauf entfernen",
	Request_PlayCount = "Bereits %d Mal Angefordert",
	Request_Url = "URL Anfordern",
	Request_Url_Tooltip = "Drücken um einen gültigen Video Link anzufordern.\nDer Button wird rot sobald der Link gültig ist.",
	Request_Filter_AllServices = "Alle Dienste",
	Request_Filter_SortBy_LastRequest = "Letzte Anforderung",
	Request_Filter_SortBy_Alphabet = "Alphabetisch",
	Request_Filter_SortBy_Duration = "Länge",
	Request_Filter_SortBy_RequestCount = "Anzahl der Anforderungen",
	Request_Paginator_ResultCount = "%s Ergebnisse",
	Request_Paginator_PageOf = "Seite %d von %d",

	-- Scoreboard settings panel
	Settings_Title = "EINSTELLUNGEN",
	Settings_ClickActivate = "KLICKEN UM MAUS ZU AKTIVIEREN",
	Settings_VolumeLabel = "Lautstärke",
	Settings_VolumeTooltip = "Benutze die +/- Tasten um die Lautstärke zu erhöhen/senken.",
	Settings_HidePlayersLabel = "Spieler im Theater ausblenden",
	Settings_HidePlayersTooltip = "Reduziert die Sichtbarkeit der Spieler innerhalb der Theater.",
	Settings_MuteFocusLabel = "Im Hintergrund stummschalten",
	Settings_MuteFocusTooltip = "Theater Audio stummschalten während Garrysmod minimiert ist.",
	Settings_SmoothVideoLabel = "Flüssige Videowiedergabe",
	Settings_SmoothVideoTooltip = "Mach einige Videos flüssiger auf Kosten der FPS.",

	-- Video Services
	Service_EmbedDisabled = "Das angeforderte Video hat die Einbettung deaktiviert.",
	Service_PurchasableContent = "Das angeforderte Video ist kaufbar und kann somit nicht abgespielt werden.",
	Service_StreamOffline = "Der angeforderte Stream ist offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Übersetzung von %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s Stunde",
	Unit_Hours   = "%s Stunden",
	Unit_Minute  = "%s Minute",
	Unit_Minutes = "%s Minuten",
	Unit_Second  = "%s Sekunde",
	Unit_Seconds = "%s Sekunden",
	Currency_Points = "%s Punkte",
	Currency_DonatorPoints = "%s Spender-Punkte",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Dieses Theater ist nicht privat und kann nicht gemietet werden!",
	Rent_AlreadyRentedBy = "Dieses Theater wird bereits von {{rgb:158,37,33}}%s{{rgb:200,200,200}} gemietet.",
	Rent_AlreadyRentingOther = "Du mietest bereits {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Du musst für mindestens %s Minute(n) mieten.",
	Rent_MaxTime = "Du kannst nicht für mehr als %s Minute(n) mieten.",
	Rent_CantAfford = "Du kannst dir diese Miete nicht leisten (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat dieses Theater für %s gemietet.",
	Rent_ExtendNotRenting = "Du musst dieses Theater bereits mieten, um deine Miete zu verlängern!",
	Rent_ExtendMinTime = "Du musst die Miete auf insgesamt mindestens %s Minute(n) verlängern.",
	Rent_ExtendMaxTime = "Du kannst nicht über %s Minute(n) hinaus mieten.",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat die Miete dieses Theaters um weitere %s verlängert.",
	Rent_RefundNotRenting = "Du musst dieses Theater mieten, um die Miete zu erstatten.",
	Rent_RefundNotEnoughTime = "Es ist nicht genug Zeit auf der Miete übrig, um sie zu erstatten.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hat die Miete dieses Theaters erstattet.",
	Rent_Refunded = "Dir wurden %s für %s Minute(n) Miete erstattet.",
	Rent_NotRented = "Dieses Theater wird derzeit nicht gemietet.",
	Rent_CancelledPublic = "Die Miete dieses Theaters von {{rgb:158,37,33}}%s{{rgb:200,200,200}} wurde von einem Admin storniert.",
	Rent_CancelledOwner = "Deine Miete wurde storniert und dir wurden %s für %s Minute(n) Miete erstattet.",
	Rent_CancelledAdmin = "Du hast die Miete von {{rgb:158,37,33}}%s{{rgb:200,200,200}} storniert.",
	Rent_CancelledAdminUnknown = "Du hast die Miete storniert, aber der Besitzer hat die Verbindung getrennt, bevor er erstattet werden konnte.",
	Rent_ExpiredOwner = "Deine Miete in {{rgb:158,37,33}}%s{{rgb:200,200,200}} ist abgelaufen.",
	Rent_ExpiredPublic = "Die Miete dieses Theaters ist abgelaufen!",
	Rent_VoteSkipLocked = "Der Besitzer dieses Theaters hat die Abwählungen gesperrt.",
	Rent_VoteSkipUnlocked = "Der Besitzer dieses Theaters hat die Abwählungen freigegeben.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Du kannst keinen Spielerfilter auf ein Theater setzen, das nicht privat ist!",
	Rent_FilterNotRented = "Dieses Theater muss gemietet werden, bevor du einen Spielerfilter darauf setzen kannst!",
	Rent_FilterNotOwner = "Du musst der Besitzer dieses Theaters sein, um einen Spielerfilter darauf zu setzen!",
	Rent_FilterUpdated = "Der Spielerfilter wurde aktualisiert.",
	Rent_FilterAdminWarn = "Admin-Warnung: Du wurdest nun aus diesem Theater gefiltert.",
	Rent_FilterSuperWarn = "Admin-Warnung: {{rgb:158,37,33}}%s{{rgb:200,200,200}} wurde aus einem Theater gefiltert, in dem er sich befindet.",
	Rent_FilteredOut = "Du wurdest aus dem Theater gefiltert.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Du mietest dieses Theater derzeit für die nächsten %s.",
	Rent_CurrentlyRentedBy = "Dieses Theater wird derzeit von {{rgb:158,37,33}}%s{{rgb:200,200,200}} für die nächsten %s gemietet.",
	Rent_MustBeRented = "Dieses Theater muss gemietet werden, um genutzt werden zu können.",
	Rent_AdminFilteredWarn = "Admin-Warnung: Du bist aus diesem Theater gefiltert.",
	Rent_AdminEnteredFiltered = "Admin-Warnung: {{rgb:158,37,33}}%s{{rgb:200,200,200}} hat ein Theater betreten, aus dem er gefiltert ist.",
	Rent_NotAllowed = "Du hast keinen Zutritt zu diesem Theater.",
	Rent_VoteSkipDisabled = "Entschuldigung, der Besitzer dieses Theaters hat die Abwählungen deaktiviert.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Du musst in einem Theater sein, um dessen Miete zu stornieren.",
	Rent_MustBeInTheaterFilter = "Du musst in deinem Theater sein, um dessen Spielerfilter zu setzen.",
	Rent_MustBeInTheaterSeeFilter = "Du musst in einem Theater sein, um dessen Spielerfilter zu sehen.",
	Rent_NotOwnerSeeFilter = "Du musst dieses Theater besitzen, um dessen Spielerfilter zu sehen.",
	Rent_MustBeInTheaterVoteLock = "Du musst in einem Theater sein, um die Abwählung zu sperren.",
	Rent_NotOwnerVoteLock = "Du musst dieses Theater besitzen, um die Abwählung zu ändern.",
	Rent_MustBeInTheaterRent = "Du musst in einem Theater sein, um es zu mieten!",
	Rent_MustBeInTheaterRefund = "Du musst in einem Theater sein, um dessen Miete zu erstatten!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Theater mieten",
	Rent_Minutes = "Minuten",
	Rent_Purchase = "Kaufen",
	Rent_PurchaseFor = "Kaufen für %s",
	Rent_ToggleVoteSkipLock = "Abwählungs-Sperre umschalten",
	Rent_PlayerFilter = "Spielerfilter",
	Rent_AddRentTime = "Mietzeit hinzufügen",
	Rent_RefundButton = "Miete erstatten",
	Rent_CancelButton = "Miete stornieren",
	Rent_Remaining = "Verbleibende Miete",
	Rent_WhitelistMode = "Whitelist-Modus",
	Rent_BlacklistMode = "Blacklist-Modus",
	Rent_Apply = "Anwenden",
	Rent_Retrieving = "Lade...",
	Rent_Unknown = "Unbekannt",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Offen",
	Rent_OwnerDisconnected = "Besitzer getrennt",
	Rent_ThumbRemaining = "Verbleibende Miete: %s",
}