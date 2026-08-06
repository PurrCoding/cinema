-- Polski language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Halamix2

return {
	-- Basic information (metadata)
	Name = "Polski",
	Author = "Halamix2",

	-- Common UI elements
	Cinema = "KINO",
	Volume = "Głośność",
	Voteskips = "Voteskips",
	Loading = "Ładowanie...",
	Invalid = "[NIEPRAWIDŁOWE]",
	NoVideoPlaying = "Brak odtwarzanego filmu",
	Cancel = "Anuluj",
	Set = "Ustaw",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Obecny film został zażądany przez {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Nieprawidłowe żądanie filmu.",
	Theater_AlreadyQueued = "Żądany film jest już w kolejce.",
	Theater_ProcessingRequest = "Przetwarzanie żądania {{rgb:158,37,33}}%s{{rgb:200,200,200}}...",
	Theater_RequestFailed = "Wystąpił problem podczas przetwarzania żądanego filmu.",
	Theater_Voteskipped = "Zostało przegłosowane pominięcie obecnego filmu.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} wymusił pominięcie obecnego filmu.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} zresetował salę kinową.",
	Theater_LostOwnership = "Straciłeś posiadanie sali kinowej z powodu opuszczenia jej.",
	Theater_NotifyOwnership = "Jesteś teraz właścicielem prywatnej sali kinowej.",
	Theater_OwnerLockedQueue = "Właściciel sali kinowej zablokował kolejkę.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} zablokował kolejkę sali kinowej.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} odblokował kolejkę sali kinowej.",
	Theater_OwnerUseOnly = "Tylko właściciel sali kinowej może tego używać.",
	Theater_PublicVideoLength = "Żądania w publicznych salach kinowych są ograniczone do długości %s sekund.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} zagłosował na pominięcie {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} zostało dodane do kolejki.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Obecna mapa jest niewspierana przez tryb gry Cinema",
	Warning_Unsupported_Line2 = "Naciśnij F1 aby otworzyć oficjalną mapę w workshopie",
	Dependency_Missing_Line1 = "Ups! Czegoś ci brakuje...",
	Dependency_Missing_Line2 = "Naciśnij F4 aby otworzyć film instruktażowy.",

	-- Queue interface
	Queue_Title = "KOLEJKA",
	Request_Video = "Zażądaj wideo",
	Vote_Skip = "Głosuj pominięcie",
	Toggle_Fullscreen = "Przełącz pełny ekran",
	Refresh_Theater = "Odśwież ekran kinowy",

	-- Theater controls
	Theater_Admin = "ADMINISTRATOR",
	Theater_Owner = "WŁAŚCICIEL",
	Theater_Skip = "Pomiń",
	Theater_Seek = "Szukaj",
	Theater_Reset = "Resetuj",
	Theater_ChangeName = "Zmień nazwę",
	Theater_QueueLock = "Przełącz blokadę kolejki",
	Theater_SeekQuery = "HH:MM:SS lub liczba w sekundach (np. 1:30:00 lub 5400)",
	Theater_Pause = "Wstrzymaj",
	Theater_Resume = "Wznów",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} wstrzymał(a) wideo.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} wznowił(a) wideo.",

	-- Theater list
	TheaterList_NowShowing = "OBECNIE GRAMY",

	-- Request Panel
	Request_History = "HISTORIA",
	Request_Clear = "Wyczyść",
	Request_DeleteTooltip = "Usuwa filmy z historii",
	Request_PlayCount = "%d żądań",
	Request_Url = "Zażądaj URL",
	Request_Url_Tooltip = "Naciśnij aby zażądać prawidłowego URL wideo.\nPrzycisk będzie czerwony gdy link jest prawidłowy",
	Request_Filter_AllServices = "Wszystkie serwisy",
	Request_Filter_SortBy_LastRequest = "Ostatnie żądanie",
	Request_Filter_SortBy_Alphabet = "Alfabetycznie",
	Request_Filter_SortBy_Duration = "Czas trwania",
	Request_Filter_SortBy_RequestCount = "Liczba żądań",
	Request_Paginator_ResultCount = "%s wyników",
	Request_Paginator_PageOf = "Strona %d z %d",

	-- Scoreboard settings panel
	Settings_Title = "USTAWIENIA",
	Settings_ClickActivate = "KLIKNIJ ABY AKTYWOWAĆ MYSZ",
	Settings_VolumeLabel = "Głośność",
	Settings_VolumeTooltip = "Użyj klawiszy +/- aby zwiększyć/zmniejszyć głośność.",
	Settings_HidePlayersLabel = "Ukryj graczy w sali kinowej",
	Settings_HidePlayersTooltip = "Zmniejsza widoczność graczy w środku sal kinowych.",
	Settings_MuteFocusLabel = "Wycisz audio podczas alt-tabowania",
	Settings_MuteFocusTooltip = "Wycisza salę kinową podczas gdy Garry's Mod jest nieaktywne (np. alt-tabowałeś).",
	Settings_SmoothVideoLabel = "Płynne odtwarzanie wideo",
	Settings_SmoothVideoTooltip = "Sprawia, że niektóre filmy są płynniejsze kosztem FPS.",

	-- Video Services
	Service_EmbedDisabled = "Żądany film ma wyłączone osadzanie.",
	Service_PurchasableContent = "Żądany film jest zawartością do kupienia i nie może zostać odtworzony.",
	Service_StreamOffline = "Żądany stream jest offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Tłumaczenie przez %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s godzina",
	Unit_Hours   = "%s godzin",
	Unit_Minute  = "%s minuta",
	Unit_Minutes = "%s minut",
	Unit_Second  = "%s sekunda",
	Unit_Seconds = "%s sekund",
	Currency_Points = "%s Punktów",
	Currency_DonatorPoints = "%s Punktów Donatora",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Ta sala kinowa nie jest prywatna i nie może zostać wynajęta!",
	Rent_AlreadyRentedBy = "Ta sala kinowa jest już wynajmowana przez {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Już wynajmujesz {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Musisz wynająć na co najmniej %s minut(y).",
	Rent_MaxTime = "Nie możesz wynająć na więcej niż %s minut(y).",
	Rent_CantAfford = "Nie stać cię na ten wynajem (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} wynajął tę salę kinową na %s.",
	Rent_ExtendNotRenting = "Musisz już wynajmować tę salę kinową, aby przedłużyć swój wynajem!",
	Rent_ExtendMinTime = "Musisz przedłużyć wynajem do łącznie co najmniej %s minut(y).",
	Rent_ExtendMaxTime = "Nie możesz wynająć dłużej niż %s minut(y).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} przedłużył swój wynajem tej sali kinowej o kolejne %s.",
	Rent_RefundNotRenting = "Musisz wynajmować tę salę kinową, aby zwrócić jej wynajem.",
	Rent_RefundNotEnoughTime = "Nie zostało wystarczająco dużo czasu wynajmu, aby go zwrócić.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} zwrócił swój wynajem tej sali kinowej.",
	Rent_Refunded = "Zwrócono ci %s za %s minut(y) wynajmu.",
	Rent_NotRented = "Ta sala kinowa nie jest obecnie wynajmowana.",
	Rent_CancelledPublic = "Wynajem tej sali kinowej przez {{rgb:158,37,33}}%s{{rgb:200,200,200}} został anulowany przez administratora.",
	Rent_CancelledOwner = "Twój wynajem został anulowany i zwrócono ci %s za %s minut(y) wynajmu.",
	Rent_CancelledAdmin = "Anulowałeś wynajem {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Anulowałeś wynajem, ale jego właściciel rozłączył się, zanim mógł otrzymać zwrot.",
	Rent_ExpiredOwner = "Twój wynajem w {{rgb:158,37,33}}%s{{rgb:200,200,200}} wygasł.",
	Rent_ExpiredPublic = "Wynajem tej sali kinowej wygasł!",
	Rent_VoteSkipLocked = "Właściciel tej sali kinowej zablokował głosowanie na pominięcie.",
	Rent_VoteSkipUnlocked = "Właściciel tej sali kinowej odblokował głosowanie na pominięcie.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Nie możesz ustawić filtra graczy na sali kinowej, która nie jest prywatna!",
	Rent_FilterNotRented = "Ta sala kinowa musi zostać wynajęta, zanim będziesz mógł ustawić na niej filtr graczy!",
	Rent_FilterNotOwner = "Musisz być właścicielem tej sali kinowej, aby ustawić na niej filtr graczy!",
	Rent_FilterUpdated = "Filtr graczy został zaktualizowany.",
	Rent_FilterAdminWarn = "Ostrzeżenie administratora: Zostałeś teraz odfiltrowany z tej sali kinowej.",
	Rent_FilterSuperWarn = "Ostrzeżenie administratora: {{rgb:158,37,33}}%s{{rgb:200,200,200}} został odfiltrowany z sali kinowej, w której się znajduje.",
	Rent_FilteredOut = "Zostałeś odfiltrowany z sali kinowej.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Obecnie wynajmujesz tę salę kinową na kolejne %s.",
	Rent_CurrentlyRentedBy = "Ta sala kinowa jest obecnie wynajmowana przez {{rgb:158,37,33}}%s{{rgb:200,200,200}} na kolejne %s.",
	Rent_MustBeRented = "Ta sala kinowa musi zostać wynajęta, aby można było jej używać.",
	Rent_AdminFilteredWarn = "Ostrzeżenie administratora: Jesteś odfiltrowany z tej sali kinowej.",
	Rent_AdminEnteredFiltered = "Ostrzeżenie administratora: {{rgb:158,37,33}}%s{{rgb:200,200,200}} wszedł do sali kinowej, z której jest odfiltrowany.",
	Rent_NotAllowed = "Nie masz dostępu do tej sali kinowej.",
	Rent_VoteSkipDisabled = "Przepraszamy, właściciel tej sali kinowej wyłączył głosowanie na pominięcie.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Musisz być w sali kinowej, aby anulować jej wynajem.",
	Rent_MustBeInTheaterFilter = "Musisz być w swojej sali kinowej, aby ustawić jej filtr graczy.",
	Rent_MustBeInTheaterSeeFilter = "Musisz być w sali kinowej, aby zobaczyć jej filtr graczy.",
	Rent_NotOwnerSeeFilter = "Musisz być właścicielem tej sali kinowej, aby zobaczyć jej filtr graczy.",
	Rent_MustBeInTheaterVoteLock = "Musisz być w sali kinowej, aby zablokować głosowanie na pominięcie.",
	Rent_NotOwnerVoteLock = "Musisz być właścicielem tej sali kinowej, aby zmienić głosowanie na pominięcie.",
	Rent_MustBeInTheaterRent = "Musisz być w sali kinowej, aby ją wynająć!",
	Rent_MustBeInTheaterRefund = "Musisz być w sali kinowej, aby zwrócić jej wynajem!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Wynajmij salę kinową",
	Rent_Minutes = "Minuty",
	Rent_Purchase = "Kup",
	Rent_PurchaseFor = "Kup za %s",
	Rent_ToggleVoteSkipLock = "Przełącz blokadę głosowania na pominięcie",
	Rent_PlayerFilter = "Filtr graczy",
	Rent_AddRentTime = "Dodaj czas wynajmu",
	Rent_RefundButton = "Zwróć wynajem",
	Rent_CancelButton = "Anuluj wynajem",
	Rent_Remaining = "Pozostały wynajem",
	Rent_WhitelistMode = "Tryb białej listy",
	Rent_BlacklistMode = "Tryb czarnej listy",
	Rent_Apply = "Zastosuj",
	Rent_Retrieving = "Pobieranie...",
	Rent_Unknown = "Nieznane",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Otwarte",
	Rent_OwnerDisconnected = "Właściciel rozłączony",
	Rent_ThumbRemaining = "Pozostały wynajem: %s",
}