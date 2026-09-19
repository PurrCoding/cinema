-- Hungarian
-- Author: David Tamas

return {
	-- Basic information (metadata)
	Name = "Hungarian",
	Author = "David Tamas",

	-- Common UI elements
	Cinema = "MOZI",
	Volume = "Hangerő",
	Voteskips = "Leszavazások",
	Loading = "Betöltés...",
	Invalid = "[ÉRVÉNYTELEN]",
	NoVideoPlaying = "Nincs videó lejátszás alatt",
	Cancel = "Mégse",
	Set = "Beállít",

	-- Theater Announcements
	Theater_VideoRequestedBy = "A jelenlegi videót kérte: {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Érvénytelen videókérés.",
	Theater_AlreadyQueued = "A kért videó már a sorban van.",
	Theater_ProcessingRequest = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}kérésének feldolgozása...",
	Theater_RequestFailed = "Hiba törén a kért videó feldolgozása közben.",
	Theater_Voteskipped = "A jelenlegi videót leszavazták.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} kényszerítette a következő videó lejátszását.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a mozitermet alaphelyzetbe állította.",
	Theater_LostOwnership = "Elvesztetted a terem feletti tulajdonjogot, mert kiléptél belőle.",
	Theater_NotifyOwnership = "Te vagy a tulajdonosa a privát teremnek.",
	Theater_OwnerLockedQueue = "A terem tulajdonosa lezárta a sort.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} lezárta a terem várakozósorát.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} feloldotta a terem várakozósorát.",
	Theater_OwnerUseOnly = "Csak a teremtulajdonos képes ezt megcsinálni.",
	Theater_PublicVideoLength = "A nyilvános termek kérései korlátozva vannak %s másodperc hosszúságra.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} szavazott, hogy továbblépjen a következő videóra.{{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} hozzáadva a sorhoz.",

	-- Warning messages
	Warning_Unsupported_Line1 = "A jelenlegi térképet nem támogatja a Mozi játékmód.",
	Warning_Unsupported_Line2 = "Nyomd meg az F1 gombot és megnyílik a Műhely a hivatalos pályával.",
	Dependency_Missing_Line1 = "Hoppá! Hiányzik valamid...",
	Dependency_Missing_Line2 = "Nyomd meg az F4 gombot az útmutató videó megnyitásához.",

	-- Queue interface
	Queue_Title = "LEJÁTSZÁSI SOR",
	Request_Video = "Videó kérése",
	Vote_Skip = "Szavazás továbblépésről",
	Toggle_Fullscreen = "Váltás teljes képernyőre",
	Refresh_Theater = "Terem alaphelyzetbe",

	-- Theater controls
	Theater_Admin = "ADMINISZTRÁTOR",
	Theater_Owner = "TULAJDONOS",
	Theater_Skip = "Átugrás",
	Theater_Seek = "Beletekerés",
	Theater_Reset = "Alaphelyzet",
	Theater_ChangeName = "Név megváltoztatása",
	Theater_QueueLock = "Várakozási sor zárása be/ki",
	Theater_SeekQuery = "ÓÓ:PP:MM vagy a másodpercek száma (1:30:00 vagy 5400)",
	Theater_Pause = "Szünet",
	Theater_Resume = "Folytatás",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} szüneteltette a videót.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} folytatta a videót.",

	-- Theater list
	TheaterList_NowShowing = "JELENLEG FUT",

	-- Request Panel
	Request_History = "ELŐZMÉNYEK",
	Request_Clear = "Kitakarítás",
	Request_DeleteTooltip = "Videó törlése az előzményekből",
	Request_PlayCount = "%d kérés",
	Request_Url = "Eme URL kérése",
	Request_Url_Tooltip = "Nyomd meg, hogy kérj egy érvényes videót.\nA gomb csak akkor lesz piros, ha az URL érvényes.",
	Request_Filter_AllServices = "Minden szolgáltatás",
	Request_Filter_SortBy_LastRequest = "Utolsó kérés",
	Request_Filter_SortBy_Alphabet = "Ábécésorrendben",
	Request_Filter_SortBy_Duration = "Időtartam",
	Request_Filter_SortBy_RequestCount = "Kérések száma",
	Request_Paginator_ResultCount = "%s találat",
	Request_Paginator_PageOf = "%d. oldal / %d",

	-- Scoreboard settings panel
	Settings_Title = "BEÁLLÍTÁSOK",
	Settings_ClickActivate = "KATTINTS AZ EGÉR AKTIVÁLÁSÁHOZ",
	Settings_VolumeLabel = "Hangerő",
	Settings_VolumeTooltip = "Használd a +/- gombokat a hangerő növeléséhez/csökkentéséhez..",
	Settings_HidePlayersLabel = "Lejátszó elrejtése a moziban",
	Settings_HidePlayersTooltip = "A lejátszó láthatósága csökkentve van.",
	Settings_MuteFocusLabel = "Alt-Tab esetén némítás",
	Settings_MuteFocusTooltip = "A mozi hangja némítva lesz, ha a Garry's Mod ablaka nem aktív (pl. Alt-Tab esetén).",
	Settings_SmoothVideoLabel = "Folyamatos videólejátszás",
	Settings_SmoothVideoTooltip = "Egyes videókat folyamatosabbá tesz az FPS rovására.",

	-- Video Services
	Service_EmbedDisabled = "A kért videó beágyazása nem megengedett.",
	Service_PurchasableContent = "A kért videó egy megvásárolandó elem és nem lejátszható.",
	Service_StreamOffline = "A kért stream jelenleg offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "A fordítást készítette: %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s óra",
	Unit_Hours   = "%s óra",
	Unit_Minute  = "%s perc",
	Unit_Minutes = "%s perc",
	Unit_Second  = "%s másodperc",
	Unit_Seconds = "%s másodperc",
	Currency_Points = "%s pont",
	Currency_DonatorPoints = "%s támogatói pont",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Ez a terem nem privát, így nem bérelhető!",
	Rent_AlreadyRentedBy = "Ezt a termet már bérli {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Már bérelsz egy termet: {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Legalább %s percre kell bérelned.",
	Rent_MaxTime = "Nem bérelhetsz többre, mint %s perc.",
	Rent_CantAfford = "Nem engedheted meg magadnak ezt a bérlést (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} kibérelte ezt a termet %s időre.",
	Rent_ExtendNotRenting = "Már bérelned kell ezt a termet ahhoz, hogy meghosszabbítsd a bérlésed!",
	Rent_ExtendMinTime = "A bérlést összesen legalább %s percre kell meghosszabbítanod.",
	Rent_ExtendMaxTime = "Nem bérelhetsz %s percen túl.",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} meghosszabbította ennek a teremnek a bérlését további %s időre.",
	Rent_RefundNotRenting = "Bérelned kell ezt a termet ahhoz, hogy visszatérítsd a bérlését.",
	Rent_RefundNotEnoughTime = "Nincs elég idő hátra a bérlésből ahhoz, hogy visszatérítsd.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} visszatéríttette ennek a teremnek a bérlését.",
	Rent_Refunded = "Visszatérítettünk %s összeget %s perc bérlésért.",
	Rent_NotRented = "Ezt a termet jelenleg nem bérli senki.",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} bérlését erre a teremre egy adminisztrátor törölte.",
	Rent_CancelledOwner = "A bérlésed törölve lett, és visszatérítettünk %s összeget %s perc bérlésért.",
	Rent_CancelledAdmin = "Törölted {{rgb:158,37,33}}%s{{rgb:200,200,200}} bérlését.",
	Rent_CancelledAdminUnknown = "Törölted a bérlést, de a tulajdonosa lecsatlakozott, mielőtt visszatéríthettük volna.",
	Rent_ExpiredOwner = "A bérlésed a következő teremben lejárt: {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_ExpiredPublic = "Ennek a teremnek a bérlése lejárt!",
	Rent_VoteSkipLocked = "Ennek a teremnek a tulajdonosa lezárta a leszavazásokat.",
	Rent_VoteSkipUnlocked = "Ennek a teremnek a tulajdonosa feloldotta a leszavazásokat.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Nem állíthatsz be játékosszűrőt olyan teremre, amely nem privát!",
	Rent_FilterNotRented = "Ezt a termet ki kell bérelned, mielőtt játékosszűrőt állíthatnál be rá!",
	Rent_FilterNotOwner = "Ennek a teremnek a tulajdonosának kell lenned ahhoz, hogy játékosszűrőt állíts be rá!",
	Rent_FilterUpdated = "A játékosszűrő frissítve lett.",
	Rent_FilterAdminWarn = "Admin figyelmeztetés: Mostantól ki vagy szűrve ebből a teremből.",
	Rent_FilterSuperWarn = "Admin figyelmeztetés: {{rgb:158,37,33}}%s{{rgb:200,200,200}} ki lett szűrve egy teremből, amelyben tartózkodik.",
	Rent_FilteredOut = "Ki lettél szűrve a teremből.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Jelenleg bérled ezt a termet a következő %s időre.",
	Rent_CurrentlyRentedBy = "Ezt a termet jelenleg {{rgb:158,37,33}}%s{{rgb:200,200,200}} bérli a következő %s időre.",
	Rent_MustBeRented = "Ezt a termet ki kell bérelni ahhoz, hogy használható legyen.",
	Rent_AdminFilteredWarn = "Admin figyelmeztetés: Ki vagy szűrve ebből a teremből.",
	Rent_AdminEnteredFiltered = "Admin figyelmeztetés: {{rgb:158,37,33}}%s{{rgb:200,200,200}} belépett egy terembe, amelyből ki van szűrve.",
	Rent_NotAllowed = "Nincs engedélyed erre a terembe.",
	Rent_VoteSkipDisabled = "Sajnáljuk, ennek a teremnek a tulajdonosa letiltotta a leszavazásokat.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Egy teremben kell lenned ahhoz, hogy töröld a bérlését.",
	Rent_MustBeInTheaterFilter = "A teremben kell lenned ahhoz, hogy beállítsd a játékosszűrőjét.",
	Rent_MustBeInTheaterSeeFilter = "Egy teremben kell lenned ahhoz, hogy lásd a játékosszűrőjét.",
	Rent_NotOwnerSeeFilter = "Ennek a teremnek a tulajdonosának kell lenned ahhoz, hogy lásd a játékosszűrőjét.",
	Rent_MustBeInTheaterVoteLock = "Egy teremben kell lenned ahhoz, hogy lezárd a leszavazást.",
	Rent_NotOwnerVoteLock = "Ennek a teremnek a tulajdonosának kell lenned ahhoz, hogy módosítsd a leszavazást.",
	Rent_MustBeInTheaterRent = "Egy teremben kell lenned ahhoz, hogy kibéreld!",
	Rent_MustBeInTheaterRefund = "Egy teremben kell lenned ahhoz, hogy visszatérítsd a bérlését!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Terem bérlése",
	Rent_Minutes = "Perc",
	Rent_Purchase = "Vásárlás",
	Rent_PurchaseFor = "Vásárlás ennyiért: %s",
	Rent_ToggleVoteSkipLock = "Leszavazás zárolásának be/ki kapcsolása",
	Rent_PlayerFilter = "Játékosszűrő",
	Rent_AddRentTime = "Bérlési idő hozzáadása",
	Rent_RefundButton = "Bérlés visszatérítése",
	Rent_CancelButton = "Bérlés törlése",
	Rent_Remaining = "Hátralévő bérlés",
	Rent_WhitelistMode = "Fehérlista mód",
	Rent_BlacklistMode = "Feketelista mód",
	Rent_Apply = "Alkalmaz",
	Rent_Retrieving = "Betöltés...",
	Rent_Unknown = "Ismeretlen",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Nyitva",
	Rent_OwnerDisconnected = "Tulajdonos lecsatlakozott",
	Rent_ThumbRemaining = "Hátralévő bérlés: %s",
}