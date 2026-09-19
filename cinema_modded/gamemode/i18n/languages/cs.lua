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
	Theater_Reset = "Reset",
	Theater_ChangeName = "Změnit jméno",
	Theater_QueueLock = "Přepnout zámek fronty",
	Theater_SeekQuery = "HH:MM:SS nebo počet sekund (např. 1:30:00 nebo 5400)",
	Theater_Pause = "Pozastavit",
	Theater_Resume = "Pokračovat",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} pozastavil(a) video.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} obnovil(a) přehrávání videa.",

	-- Theater list
	TheaterList_NowShowing = "NYNÍ SE PROMÍTÁ",

	-- Request Panel
	Request_History = "HISTORIE",
	Request_Clear = "Vyčistit",
	Request_DeleteTooltip = "Odstranit video z historie",
	Request_PlayCount = "%d vyžádáno",
	Request_Url = "Vyžádat video",
	Request_Url_Tooltip = "Stiskněte pro vyžádání platného videa.\nTlačítko zčervená když je URL platná",
	Request_Filter_AllServices = "Všechny služby",
	Request_Filter_SortBy_LastRequest = "Poslední požadavek",
	Request_Filter_SortBy_Alphabet = "Abecedně",
	Request_Filter_SortBy_Duration = "Délka",
	Request_Filter_SortBy_RequestCount = "Počet požadavků",
	Request_Paginator_ResultCount = "%s výsledků",
	Request_Paginator_PageOf = "Strana %d z %d",

	-- Scoreboard settings panel
	Settings_Title = "NASTAVENÍ",
	Settings_ClickActivate = "KLIKNĚTE PRO AKTIVACI KURZORU MYŠI",
	Settings_VolumeLabel = "Hlasitost",
	Settings_VolumeTooltip = "Stiskněte klávesy +/- pro zvýšení/snížení hlasitosti.",
	Settings_HidePlayersLabel = "Skrýt hráče v kinech",
	Settings_HidePlayersTooltip = "Redukuje viditelnost hráčů uvnitř kin.",
	Settings_MuteFocusLabel = "Ztišit zvuk při alt-tab",
	Settings_MuteFocusTooltip = "Ztiší zvuk v kině když je okno Garry's Mod neaktivní (např. při stisknutí alt-tab).",
	Settings_SmoothVideoLabel = "Plynulé přehrávání videa",
	Settings_SmoothVideoTooltip = "Zajistí plynulejší přehrávání některých videí za cenu nižší FPS.",

	-- Video Services
	Service_EmbedDisabled = "Požadované video má zakázáno vkládání.",
	Service_PurchasableContent = "Požadované video je zakoupitelný obsah a nemůže být přehráno.",
	Service_StreamOffline = "Požadovaný stream je offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Překlad: %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s hodina",
	Unit_Hours   = "%s hodin",
	Unit_Minute  = "%s minuta",
	Unit_Minutes = "%s minut",
	Unit_Second  = "%s sekunda",
	Unit_Seconds = "%s sekund",
	Currency_Points = "%s bodů",
	Currency_DonatorPoints = "%s dárcovských bodů",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Toto kino není soukromé a nelze si jej pronajmout!",
	Rent_AlreadyRentedBy = "Toto kino si již pronajímá {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Již si pronajímáš {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Musíš si pronajmout alespoň na %s minut(y).",
	Rent_MaxTime = "Nemůžeš si pronajmout na více než %s minut(y).",
	Rent_CantAfford = "Na tento pronájem nemáš dostatek prostředků (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} si pronajal(a) toto kino na %s.",
	Rent_ExtendNotRenting = "Abys mohl(a) prodloužit pronájem, musíš si toto kino již pronajímat!",
	Rent_ExtendMinTime = "Pronájem musíš prodloužit na celkem alespoň %s minut(y).",
	Rent_ExtendMaxTime = "Nemůžeš si pronajmout déle než %s minut(y).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} prodloužil(a) svůj pronájem tohoto kina o dalších %s.",
	Rent_RefundNotRenting = "Abys mohl(a) vrátit pronájem, musíš si toto kino pronajímat.",
	Rent_RefundNotEnoughTime = "Na pronájmu nezbývá dost času na jeho vrácení.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} vrátil(a) svůj pronájem tohoto kina.",
	Rent_Refunded = "Bylo ti vráceno %s za %s minut(y) pronájmu.",
	Rent_NotRented = "Toto kino si aktuálně nikdo nepronajímá.",
	Rent_CancelledPublic = "Pronájem tohoto kina hráče {{rgb:158,37,33}}%s{{rgb:200,200,200}} byl zrušen adminem.",
	Rent_CancelledOwner = "Tvůj pronájem byl zrušen a bylo ti vráceno %s za %s minut(y) pronájmu.",
	Rent_CancelledAdmin = "Zrušil(a) jsi pronájem hráče {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Zrušil(a) jsi pronájem, ale jeho majitel se odpojil dříve, než mu mohly být vráceny prostředky.",
	Rent_ExpiredOwner = "Tvůj pronájem v {{rgb:158,37,33}}%s{{rgb:200,200,200}} vypršel.",
	Rent_ExpiredPublic = "Pronájem tohoto kina vypršel!",
	Rent_VoteSkipLocked = "Majitel tohoto kina uzamkl hlasování o přeskočení.",
	Rent_VoteSkipUnlocked = "Majitel tohoto kina odemkl hlasování o přeskočení.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Nemůžeš nastavit filtr hráčů v kině, které není soukromé!",
	Rent_FilterNotRented = "Toto kino si musíš nejprve pronajmout, než na něm nastavíš filtr hráčů!",
	Rent_FilterNotOwner = "Abys mohl(a) nastavit filtr hráčů, musíš být majitelem tohoto kina!",
	Rent_FilterUpdated = "Filtr hráčů byl aktualizován.",
	Rent_FilterAdminWarn = "Varování admina: Nyní jsi vyfiltrován(a) z tohoto kina.",
	Rent_FilterSuperWarn = "Varování admina: {{rgb:158,37,33}}%s{{rgb:200,200,200}} byl(a) vyfiltrován(a) z kina, ve kterém se nachází.",
	Rent_FilteredOut = "Byl(a) jsi vyfiltrován(a) z kina.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Toto kino si aktuálně pronajímáš na dalších %s.",
	Rent_CurrentlyRentedBy = "Toto kino si aktuálně pronajímá {{rgb:158,37,33}}%s{{rgb:200,200,200}} na dalších %s.",
	Rent_MustBeRented = "Aby bylo možné toto kino použít, musí být pronajato.",
	Rent_AdminFilteredWarn = "Varování admina: Jsi vyfiltrován(a) z tohoto kina.",
	Rent_AdminEnteredFiltered = "Varování admina: {{rgb:158,37,33}}%s{{rgb:200,200,200}} vstoupil(a) do kina, ze kterého je vyfiltrován(a).",
	Rent_NotAllowed = "Do tohoto kina nemáš povolen přístup.",
	Rent_VoteSkipDisabled = "Omlouváme se, majitel tohoto kina zakázal hlasování o přeskočení.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Abys zrušil(a) pronájem, musíš být v kině.",
	Rent_MustBeInTheaterFilter = "Abys nastavil(a) filtr hráčů, musíš být ve svém kině.",
	Rent_MustBeInTheaterSeeFilter = "Abys viděl(a) filtr hráčů, musíš být v kině.",
	Rent_NotOwnerSeeFilter = "Abys viděl(a) filtr hráčů, musíš být majitelem tohoto kina.",
	Rent_MustBeInTheaterVoteLock = "Abys uzamkl(a) hlasování o přeskočení, musíš být v kině.",
	Rent_NotOwnerVoteLock = "Abys upravil(a) hlasování o přeskočení, musíš být majitelem tohoto kina.",
	Rent_MustBeInTheaterRent = "Abys si kino pronajal(a), musíš v něm být!",
	Rent_MustBeInTheaterRefund = "Abys vrátil(a) pronájem, musíš být v kině!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Pronajmout kino",
	Rent_Minutes = "Minut",
	Rent_Purchase = "Zakoupit",
	Rent_PurchaseFor = "Zakoupit za %s",
	Rent_ToggleVoteSkipLock = "Přepnout zámek hlasování o přeskočení",
	Rent_PlayerFilter = "Filtr hráčů",
	Rent_AddRentTime = "Přidat čas pronájmu",
	Rent_RefundButton = "Vrátit pronájem",
	Rent_CancelButton = "Zrušit pronájem",
	Rent_Remaining = "Zbývající pronájem",
	Rent_WhitelistMode = "Režim whitelistu",
	Rent_BlacklistMode = "Režim blacklistu",
	Rent_Apply = "Použít",
	Rent_Retrieving = "Načítání...",
	Rent_Unknown = "Neznámé",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Otevřeno",
	Rent_OwnerDisconnected = "Majitel se odpojil",
	Rent_ThumbRemaining = "Zbývající pronájem: %s",
}