-- Česky language file for Cinema gamemode
-- Converted from monolithic i18n.lua
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

	-- Theater list
	TheaterList_NowShowing = "NYNÍ SE PROMÍTÁ",

	-- Request Panel
	Request_History = "HISTORIE",
	Request_Clear = "Vyčistit",
	Request_DeleteTooltip = "Odstranit video z historie",
	Request_PlayCount = "%d vyžádáno",
	Request_Url = "Vyžádat video",
	Request_Url_Tooltip = "Stiskněte pro vyžádání platného videa.\nTlačítko zčervená když je URL platná",

	-- Scoreboard settings panel
	Settings_Title = "NASTAVENÍ",
	Settings_ClickActivate = "KLIKNĚTE PRO AKTIVACI KURZORU MYŠI",
	Settings_VolumeLabel = "Hlasitost",
	Settings_VolumeTooltip = "Stiskněte klávesy +/- pro zvýšení/snížení hlasitosti.",
	Settings_HidePlayersLabel = "Skrýt hráče v kinech",
	Settings_HidePlayersTooltip = "Redukuje viditelnost hráčů uvnitř kin.",
	Settings_MuteFocusLabel = "Ztišit zvuk při alt-tab",
	Settings_MuteFocusTooltip = "Ztiší zvuk v kině když je okno Garry's Mod neaktivní (např. při stisknutí alt-tab).",

	-- Video Services
	Service_EmbedDisabled = "Požadované video má zakázáno vkládání.",
	Service_PurchasableContent = "Požadované video je zakoupitelný obsah a nemůže být přehráno.",
	Service_StreamOffline = "Požadovaný stream je offline.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Překlad: %s",

}
