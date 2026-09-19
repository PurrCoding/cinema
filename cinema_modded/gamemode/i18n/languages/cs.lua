-- Česky
-- Author: MatesakCZ

return {
	-- Basic information (metadata)
	Name = "Česky",
	Author = "MatesakCZ",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Hlasitost",
	Voteskips = "Hlasy o přeskočení",
	Loading = "Načítání...",
	Invalid = "[NEPLATNÝ]",
	NoVideoPlaying = "Nepřehrává se žádné video",
	Cancel = "Zrušit",
	Set = "Nastavit",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Současné video vyžádáno hráčem {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Neplatný video požadavek.",
	Theater_AlreadyQueued = "Požadované video je již ve frontě.",
	Theater_ProcessingRequest = "Zpracovává se {{rgb:158,37,33}}%s{{rgb:200,200,200}} požadavek...",
	Theater_RequestFailed = "Nastal problém při zpracování požadovaného videa.",
	Theater_Voteskipped = "Současné video bylo přeskočeno hlasováním.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} vynutil/a přeskočení současného videa.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} resetoval/a kino.",
	Theater_LostOwnership = "Ztratil/a jsi vlastnictví kina z důvodu jeho opuštění.",
	Theater_NotifyOwnership = "Jsi nyní majitelem tohoto soukromého kina.",
	Theater_OwnerLockedQueue = "Majitel kina uzamkl frontu videí.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} uzamkl/a frontu videí.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} odemkl/a frontu videí.",
	Theater_OwnerUseOnly = "Toto může použít pouze majitel kina.",
	Theater_PublicVideoLength = "Videa vyžádaná ve veřejných kinech jsou omezena na maximální délku %s sekund.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hlasoval/a pro přeskočení {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} bylo přidáno do fronty.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Současná mapa není podporována herním módem Cinema.",
	Warning_Unsupported_Line2 = "Stiskněte F1 pro otevření oficiální mapy ve workshopu.",
	Dependency_Missing_Line1 = "Ups! Něco vám chybí...",
	Dependency_Missing_Line2 = "Stiskněte F4 pro otevření instruktážního videa.",

	-- Queue interface
	Queue_Title = "FRONTA",
	Request_Video = "Vyžádat video",
	Vote_Skip = "Hlasovat o přeskočení",
	Toggle_Fullscreen = "Na celou obrazovku",
	Refresh_Theater = "Obnovit kino",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "MAJITEL",
	Theater_Skip = "Přeskočit",
	Theater_Seek = "Přetočit",
	Theater_Reset = "Resetovat",
	Theater_ChangeName = "Změnit jméno",
	Theater_QueueLock = "Přepnout zámek fronty videí",
	Theater_SeekQuery = "HH:MM:SS nebo počet sekund (např. 1:30:00 nebo 5400)",
	Theater_Pause = "Pozastavit",
	Theater_Resume = "Pokračovat",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} pozastavil/a video.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} obnovil/a video.",

	-- Theater list
	TheaterList_NowShowing = "NYNÍ SE PŘEHRÁVÁ",

	-- Request Panel
	Request_History = "HISTORIE",
	Request_Clear = "Vyčistit",
	Request_DeleteTooltip = "Odstranit toto video z historie",
	Request_PlayCount = "%d vyžádání",
	Request_Url = "Vyžádat URL",
	Request_Url_Tooltip = "Stiskněte pro vyžádání platného URL videa.\nTlačítko zčervená, pokud je URL platné.",
	Request_Filter_AllServices = "Všechny služby",
	Request_Filter_SortBy_LastRequest = "Poslední požadavek",
	Request_Filter_SortBy_Alphabet = "Abecedně",
	Request_Filter_SortBy_Duration = "Délka",
	Request_Filter_SortBy_RequestCount = "Počet požadavků",
	Request_Paginator_ResultCount = "%s výsledků",
	Request_Paginator_PageOf = "Stránka %d z %d",

	-- Scoreboard settings panel
	Settings_Title = "NASTAVENÍ",
	Settings_ClickActivate = "KLIKNĚTE PRO AKTIVACI MYŠI",
	Settings_VolumeLabel = "Hlasitost",
	Settings_VolumeTooltip = "Použijte klávesy \"+\" a \"-\" pro zvýšení/snížení hlasitosti.",
	Settings_HidePlayersLabel = "Skrýt hráče v kinech",
	Settings_HidePlayersTooltip = "Redukuje viditelnost hráčů uvnitř kin.",
	Settings_MuteFocusLabel = "Ztlumit zvuk při alt-tab",
	Settings_MuteFocusTooltip = "Ztlumení zvuku kina, když je Garry's Mod mimo focus (např. při alt-tab).",
	Settings_SmoothVideoLabel = "Plynulé přehrávání videa",
	Settings_SmoothVideoTooltip = "Zefektivní některá videa za cenu FPS.",

	-- Video Services
	Service_EmbedDisabled = "Požadované video má zakázané vkládání.",
	Service_PurchasableContent = "Požadované video je placený obsah a nelze ho přehrát.",
	Service_StreamOffline = "Požadovaný stream je offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Překlady vytvořeny: %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s hodina",
	Unit_Hours   = "%s hodin",
	Unit_Minute  = "%s minuta",
	Unit_Minutes = "%s minut",
	Unit_Second  = "%s sekunda",
	Unit_Seconds = "%s sekund",
	Currency_Points = "%s bodů",
	Currency_DonatorPoints = "%s donátorských bodů",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Toto kino není soukromé a nelze ho pronajmout!",
	Rent_AlreadyRentedBy = "Toto kino je již pronajato hráčem {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Již si pronajímáš {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Musíš si pronajmout alespoň na %s minut(y).",
	Rent_MaxTime = "Nemůžeš si pronajmout na více než %s minut(y).",
	Rent_CantAfford = "Nemůžeš si dovolit tento pronájem (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} si pronajal/a toto kino na %s.",
	Rent_ExtendNotRenting = "Musíš mít toto kino již pronajato, abys mohl/a prodloužit pronájem!",
	Rent_ExtendMinTime = "Musíš prodloužit pronájem alespoň na celkových %s minut(y).",
	Rent_ExtendMaxTime = "Nemůžeš si pronajmout déle než na %s minut(y).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} prodloužil/a pronájem tohoto kina o dalších %s.",
	Rent_RefundNotRenting = "Musíš mít toto kino pronajato, abys mohl/a vrátit pronájem.",
	Rent_RefundNotEnoughTime = "Na pronájmu nezbývá dostatek času pro jeho vrácení.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} vrátil/a pronájem tohoto kina.",
	Rent_Refunded = "Bylo ti vráceno %s za %s minut(y) pronájmu.",
	Rent_NotRented = "Toto kino momentálně není pronajato.",
	Rent_CancelledPublic = "Pronájem tohoto kina hráče {{rgb:158,37,33}}%s{{rgb:200,200,200}} byl zrušen adminem.",
	Rent_CancelledOwner = "Tvůj pronájem byl zrušen a bylo ti vráceno %s za %s minut(y) pronájmu.",
	Rent_CancelledAdmin = "Zrušil/a jsi pronájem hráče {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Zrušil/a jsi pronájem, ale majitel se odpojil dříve, než mohl být refundován.",
	Rent_ExpiredOwner = "Tvůj pronájem v {{rgb:158,37,33}}%s{{rgb:200,200,200}} vypršel.",
	Rent_ExpiredPublic = "Pronájem tohoto kina vypršel!",
	Rent_VoteSkipLocked = "Majitel tohoto kina uzamkl hlasování o přeskočení.",
	Rent_VoteSkipUnlocked = "Majitel tohoto kina odemkl hlasování o přeskočení.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Nemůžeš nastavit filtr hráčů na kino, které není soukromé!",
	Rent_FilterNotRented = "Toto kino musí být pronajato, než na něj můžeš nastavit filtr hráčů!",
	Rent_FilterNotOwner = "Musíš být majitelem tohoto kina, abys mohl/a nastavit filtr hráčů!",
	Rent_FilterUpdated = "Filtr hráčů byl aktualizován.",
	Rent_FilterAdminWarn = "Admin varování: Byl/a jsi vyfiltrován/a z tohoto kina.",
	Rent_FilterSuperWarn = "Admin varování: {{rgb:158,37,33}}%s{{rgb:200,200,200}} byl/a vyfiltrován/a z kina, ve kterém se nachází.",
	Rent_FilteredOut = "Byl/a jsi vyfiltrován/a z kina.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Momentálně si pronajímáš toto kino na dalších %s.",
	Rent_CurrentlyRentedBy = "Toto kino je momentálně pronajato hráčem {{rgb:158,37,33}}%s{{rgb:200,200,200}} na dalších %s.",
	Rent_MustBeRented = "Toto kino musí být pronajato, aby mohlo být použito.",
	Rent_AdminFilteredWarn = "Admin varování: Jsi vyfiltrován/a z tohoto kina.",
	Rent_AdminEnteredFiltered = "Admin varování: {{rgb:158,37,33}}%s{{rgb:200,200,200}} vstoupil/a do kina, ze kterého je vyfiltrován/a.",
	Rent_NotAllowed = "Nemáš povolení vstoupit do tohoto kina.",
	Rent_VoteSkipDisabled = "Omlouváme se, majitel tohoto kina zakázal hlasování o přeskočení.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Musíš být v kině, abys mohl/a zrušit jeho pronájem.",
	Rent_MustBeInTheaterFilter = "Musíš být ve svém kině, abys mohl/a nastavit filtr hráčů.",
	Rent_MustBeInTheaterSeeFilter = "Musíš být v kině, abys mohl/a vidět jeho filtr hráčů.",
	Rent_NotOwnerSeeFilter = "Musíš vlastnit toto kino, abys mohl/a vidět jeho filtr hráčů.",
	Rent_MustBeInTheaterVoteLock = "Musíš být v kině, abys mohl/a uzamknout hlasování o přeskočení.",
	Rent_NotOwnerVoteLock = "Musíš vlastnit toto kino, abys mohl/a upravit hlasování o přeskočení.",
	Rent_MustBeInTheaterRent = "Musíš být v kině, abys si ho mohl/a pronajmout!",
	Rent_MustBeInTheaterRefund = "Musíš být v kině, abys mohl/a vrátit jeho pronájem!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Pronajmout kino",
	Rent_Minutes = "Minuty",
	Rent_Purchase = "Koupit",
	Rent_PurchaseFor = "Koupit za %s",
	Rent_ToggleVoteSkipLock = "Přepnout zámek hlasování o přeskočení",
	Rent_PlayerFilter = "Filtr hráčů",
	Rent_AddRentTime = "Přidat čas pronájmu",
	Rent_RefundButton = "Vrátit pronájem",
	Rent_CancelButton = "Zrušit pronájem",
	Rent_Remaining = "Zbývající pronájem",
	Rent_WhitelistMode = "Režim whitelist",
	Rent_BlacklistMode = "Režim blacklist",
	Rent_Apply = "Použít",
	Rent_Retrieving = "Načítání...",
	Rent_Unknown = "Neznámý",

	-- Theater Rentals: currency / pending refunds
	Rent_NoCurrency = "Na tomto serveru není k dispozici žádný měnový systém.",
	Rent_RefundedPending = "Obdrželi jste čekající vrácení nájmu ve výši %s.",
	Rent_CancelledAdminPending = "Zrušili jste pronájem {{rgb:158,37,33}}%s{{rgb:200,200,200}}. Vrácení %s bude připsáno při opětovném připojení.",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Otevřeno",
	Rent_OwnerDisconnected = "Majitel se odpojil",
	Rent_ThumbRemaining = "Zbývající pronájem: %s",
}
