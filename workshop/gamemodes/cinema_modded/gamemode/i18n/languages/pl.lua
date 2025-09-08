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

	-- Theater list
	TheaterList_NowShowing = "OBECNIE GRAMY",

	-- Request Panel
	Request_History = "HISTORIA",
	Request_Clear = "Wyczyść",
	Request_DeleteTooltip = "Usuwa filmy z historii",
	Request_PlayCount = "%d żądań",
	Request_Url = "Zażądaj URL",
	Request_Url_Tooltip = "Naciśnij aby zażądać prawidłowego URL wideo.\nPrzycisk będzie czerwony gdy link jest prawidłowy",

	-- Scoreboard settings panel
	Settings_Title = "USTAWIENIA",
	Settings_ClickActivate = "KLIKNIJ ABY AKTYWOWAĆ MYSZ",
	Settings_VolumeLabel = "Głośność",
	Settings_VolumeTooltip = "Użyj klawiszy +/- aby zwiększyć/zmniejszyć głośność.",
	Settings_HidePlayersLabel = "Ukryj graczy w sali kinowej",
	Settings_HidePlayersTooltip = "Zmniejsza widoczność graczy w środku sal kinowych.",
	Settings_MuteFocusLabel = "Wycisz audio podczas alt-tabowania",
	Settings_MuteFocusTooltip = "Wycisza salę kinową podczas gdy Garry's Mod jest nieaktywne (np. alt-tabowałeś).",

	-- Video Services
	Service_EmbedDisabled = "Żądany film ma wyłączone osadzanie.",
	Service_PurchasableContent = "Żądany film jest zawartością do kupienia i nie może zostać odtworzony.",
	Service_StreamOffline = "Żądany stream jest offline.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Tłumaczenie przez %s",

}
