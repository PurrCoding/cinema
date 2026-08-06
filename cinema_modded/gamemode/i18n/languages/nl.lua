-- Nederlands language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Ubister

return {
	-- Basic information (metadata)
	Name = "Nederlands",
	Author = "Ubister",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Volume",
	Voteskips = "Stemmen om over te slaan",
	Loading = "Laden...",
	Invalid = "[ONGELDIG]",
	NoVideoPlaying = "Geen afspelende video",
	Cancel = "Annuleer",
	Set = "Stel",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Deze video is verzocht door {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Ongeldig videoverzoek.",
	Theater_AlreadyQueued = "De verzochte video is al in de rij.",
	Theater_ProcessingRequest = "Verzoek {{rgb:158,37,33}}%s{{rgb:200,200,200}} verwerken...",
	Theater_RequestFailed = "Er trad een probleem op bij het verwerken van de verzochte video.",
	Theater_Voteskipped = "Deze video is weggestemd.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft deze video overgeslagen.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de bioscoop gereset.",
	Theater_LostOwnership = "Je hebt het eigenaarschap over deze bioscoop verloren omdat je het hebt verlaten.",
	Theater_NotifyOwnership = "Je bent nu de eigenaar van deze privébioscoop.",
	Theater_OwnerLockedQueue = "De bioscoopeigenaar heeft de rij gesloten.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de rij gesloten.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de rij geopend.",
	Theater_OwnerUseOnly = "Alleen de bioscoopeigenaar kan dit doen.",
	Theater_PublicVideoLength = "Verzoeken in openbare bioscopen hebben een tijdslimiet van %s seconde(n).",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft gestemd om over te slaan {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} is aan de rij toegevoegd.",

	-- Warning messages
	Warning_Unsupported_Line1 = "De huidige map wordt niet ondersteund door de Cinema gamemode.",
	Warning_Unsupported_Line2 = "Druk op F1 om de officiële map te openen in workshop.",
	Dependency_Missing_Line1 = "Oeps! Je mist iets...",
	Dependency_Missing_Line2 = "Druk op F4 om de instructievideo te openen.",

	-- Queue interface
	Queue_Title = "RIJ",
	Request_Video = "Verzoek Video",
	Vote_Skip = "Wegstemmen",
	Toggle_Fullscreen = "Schakel Vol Scherm In",
	Refresh_Theater = "Bioscoop Verversen",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "EIGENAAR",
	Theater_Skip = "Overslaan",
	Theater_Seek = "Zoek",
	Theater_Reset = "Reset",
	Theater_ChangeName = "Wijzig Naam",
	Theater_QueueLock = "Sluit Rij",
	Theater_SeekQuery = "HH:MM:SS of het aantal seconden (bv. 1:30:00 of 5400)",
	Theater_Pause = "Pauzeren",
	Theater_Resume = "Hervatten",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de video gepauzeerd.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de video hervat.",

	-- Theater list
	TheaterList_NowShowing = "NU OP",

	-- Request Panel
	Request_History = "GESCHIEDENIS",
	Request_Clear = "Wis",
	Request_DeleteTooltip = "Wis video uit geschiedenis",
	Request_PlayCount = "%d verzoek(en)",
	Request_Url = "Verzoek URL",
	Request_Url_Tooltip = "Druk om een geldige video URL te verzoeken.\nDe knop is rood als de URL geldig is.",
	Request_Filter_AllServices = "Alle diensten",
	Request_Filter_SortBy_LastRequest = "Laatste verzoek",
	Request_Filter_SortBy_Alphabet = "Alfabetisch",
	Request_Filter_SortBy_Duration = "Duur",
	Request_Filter_SortBy_RequestCount = "Aantal verzoeken",
	Request_Paginator_ResultCount = "%s resultaten",
	Request_Paginator_PageOf = "Pagina %d van %d",

	-- Scoreboard settings panel
	Settings_Title = "INSTELLINGEN",
	Settings_ClickActivate = "KLIK OM JE MUIS TE ACTIVEREN",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Gebruik de +/- knoppen om je volume harder/zachter te zetten.",
	Settings_HidePlayersLabel = "Verberg Spelers In Bioscoop",
	Settings_HidePlayersTooltip = "Verminder spelerzichtbaarheid binnen bioscopen.",
	Settings_MuteFocusLabel = "Demp audio wanneer gealt-tabd",
	Settings_MuteFocusTooltip = "Demp bioscoopvolume wanneer Garry's Mod niet geselecteerd is (bv. in alt-tab.)",
	Settings_SmoothVideoLabel = "Vloeiende videoweergave",
	Settings_SmoothVideoTooltip = "Maak sommige video's vloeiender ten koste van FPS.",

	-- Video Services
	Service_EmbedDisabled = "Bij de verzochte video zijn insluitingen uitgeschakeld.",
	Service_PurchasableContent = "De verzochte video is koopbaar materiaal en kan niet afgespeeld worden.",
	Service_StreamOffline = "De verzochte stream is offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Vertalingen gemaakt door %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s uur",
	Unit_Hours   = "%s uur",
	Unit_Minute  = "%s minuut",
	Unit_Minutes = "%s minuten",
	Unit_Second  = "%s seconde",
	Unit_Seconds = "%s seconden",
	Currency_Points = "%s Punten",
	Currency_DonatorPoints = "%s Donateurpunten",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Deze bioscoop is niet privé en kan niet gehuurd worden!",
	Rent_AlreadyRentedBy = "Deze bioscoop wordt al gehuurd door {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Je huurt al {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Je moet voor minstens %s minu(u)t(en) huren.",
	Rent_MaxTime = "Je kunt niet voor meer dan %s minu(u)t(en) huren.",
	Rent_CantAfford = "Je kunt die huur niet betalen (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft deze bioscoop gehuurd voor %s.",
	Rent_ExtendNotRenting = "Je moet deze bioscoop al huren om je huur te verlengen!",
	Rent_ExtendMinTime = "Je moet de huur verlengen tot in totaal minstens %s minu(u)t(en).",
	Rent_ExtendMaxTime = "Je kunt niet langer dan %s minu(u)t(en) huren.",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de huur van deze bioscoop met nog eens %s verlengd.",
	Rent_RefundNotRenting = "Je moet deze bioscoop huren om de huur terug te betalen.",
	Rent_RefundNotEnoughTime = "Er is niet genoeg tijd over op de huur om deze terug te betalen.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de huur van deze bioscoop terugbetaald gekregen.",
	Rent_Refunded = "Je hebt %s terugbetaald gekregen voor %s minu(u)t(en) huur.",
	Rent_NotRented = "Deze bioscoop wordt momenteel niet gehuurd.",
	Rent_CancelledPublic = "De huur van deze bioscoop door {{rgb:158,37,33}}%s{{rgb:200,200,200}} is geannuleerd door een admin.",
	Rent_CancelledOwner = "Je huur is geannuleerd en je hebt %s terugbetaald gekregen voor %s minu(u)t(en) huur.",
	Rent_CancelledAdmin = "Je hebt de huur van {{rgb:158,37,33}}%s{{rgb:200,200,200}} geannuleerd.",
	Rent_CancelledAdminUnknown = "Je hebt de huur geannuleerd, maar de eigenaar verbrak de verbinding voordat hij terugbetaald kon worden.",
	Rent_ExpiredOwner = "Je huur in {{rgb:158,37,33}}%s{{rgb:200,200,200}} is verlopen.",
	Rent_ExpiredPublic = "De huur van deze bioscoop is verlopen!",
	Rent_VoteSkipLocked = "De eigenaar van deze bioscoop heeft de wegstemmen vergrendeld.",
	Rent_VoteSkipUnlocked = "De eigenaar van deze bioscoop heeft de wegstemmen ontgrendeld.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Je kunt geen spelerfilter instellen op een bioscoop die niet privé is!",
	Rent_FilterNotRented = "Deze bioscoop moet gehuurd worden voordat je er een spelerfilter op kunt instellen!",
	Rent_FilterNotOwner = "Je moet de eigenaar van deze bioscoop zijn om er een spelerfilter op in te stellen!",
	Rent_FilterUpdated = "De spelerfilter is bijgewerkt.",
	Rent_FilterAdminWarn = "Adminwaarschuwing: Je bent nu uit deze bioscoop gefilterd.",
	Rent_FilterSuperWarn = "Adminwaarschuwing: {{rgb:158,37,33}}%s{{rgb:200,200,200}} is gefilterd uit een bioscoop waarin hij zich bevindt.",
	Rent_FilteredOut = "Je bent uit de bioscoop gefilterd.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Je huurt deze bioscoop momenteel voor de komende %s.",
	Rent_CurrentlyRentedBy = "Deze bioscoop wordt momenteel gehuurd door {{rgb:158,37,33}}%s{{rgb:200,200,200}} voor de komende %s.",
	Rent_MustBeRented = "Deze bioscoop moet gehuurd worden om gebruikt te kunnen worden.",
	Rent_AdminFilteredWarn = "Adminwaarschuwing: Je bent uit deze bioscoop gefilterd.",
	Rent_AdminEnteredFiltered = "Adminwaarschuwing: {{rgb:158,37,33}}%s{{rgb:200,200,200}} betrad een bioscoop waaruit hij gefilterd is.",
	Rent_NotAllowed = "Je bent niet toegestaan in deze bioscoop.",
	Rent_VoteSkipDisabled = "Sorry, de eigenaar van deze bioscoop heeft de wegstemmen uitgeschakeld.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Je moet in een bioscoop zijn om de huur ervan te annuleren.",
	Rent_MustBeInTheaterFilter = "Je moet in je bioscoop zijn om de spelerfilter ervan in te stellen.",
	Rent_MustBeInTheaterSeeFilter = "Je moet in een bioscoop zijn om de spelerfilter ervan te zien.",
	Rent_NotOwnerSeeFilter = "Je moet deze bioscoop bezitten om de spelerfilter ervan te zien.",
	Rent_MustBeInTheaterVoteLock = "Je moet in een bioscoop zijn om het wegstemmen te vergrendelen.",
	Rent_NotOwnerVoteLock = "Je moet deze bioscoop bezitten om het wegstemmen te wijzigen.",
	Rent_MustBeInTheaterRent = "Je moet in een bioscoop zijn om deze te huren!",
	Rent_MustBeInTheaterRefund = "Je moet in een bioscoop zijn om de huur ervan terug te betalen!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Bioscoop Huren",
	Rent_Minutes = "Minuten",
	Rent_Purchase = "Kopen",
	Rent_PurchaseFor = "Kopen voor %s",
	Rent_ToggleVoteSkipLock = "Wegstemvergrendeling In-/Uitschakelen",
	Rent_PlayerFilter = "Spelerfilter",
	Rent_AddRentTime = "Huurtijd Toevoegen",
	Rent_RefundButton = "Huur Terugbetalen",
	Rent_CancelButton = "Huur Annuleren",
	Rent_Remaining = "Resterende Huur",
	Rent_WhitelistMode = "Whitelist-modus",
	Rent_BlacklistMode = "Blacklist-modus",
	Rent_Apply = "Toepassen",
	Rent_Retrieving = "Ophalen...",
	Rent_Unknown = "Onbekend",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Open",
	Rent_OwnerDisconnected = "Eigenaar Verbinding Verbroken",
	Rent_ThumbRemaining = "Resterende Huur: %s",
}