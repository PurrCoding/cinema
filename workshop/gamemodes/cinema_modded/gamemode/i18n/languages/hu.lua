-- Hungarian language file for Cinema gamemode
-- Converted from monolithic i18n.lua
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

	-- Theater list
	TheaterList_NowShowing = "JELENLEG FUT",

	-- Request Panel
	Request_History = "ELŐZMÉNYEK",
	Request_Clear = "Kitakarítás",
	Request_DeleteTooltip = "Videó törlése az előzményekből",
	Request_PlayCount = "%d kérés",
	Request_Url = "Eme URL kérése",
	Request_Url_Tooltip = "Nyomd meg, hogy kérj egy érvényes videót.\nA gomb csak akkor lesz piros, ha az URL érvényes.",

	-- Scoreboard settings panel
	Settings_Title = "BEÁLLÍTÁSOK",
	Settings_ClickActivate = "KATTINTS AZ EGÉR AKTIVÁLÁSÁHOZ",
	Settings_VolumeLabel = "Hangerő",
	Settings_VolumeTooltip = "Használd a +/- gombokat a hangerő növeléséhez/csökkentéséhez..",
	Settings_HidePlayersLabel = "Lejátszó elrejtése a moziban",
	Settings_HidePlayersTooltip = "A lejátszó láthatósága csökkentve van.",
	Settings_MuteFocusLabel = "Alt-Tab esetén némítás",
	Settings_MuteFocusTooltip = "A mozi hangja némítva lesz, ha a Garry's Mod ablaka nem aktív (pl. Alt-Tab esetén).",

	-- Video Services
	Service_EmbedDisabled = "A kért videó beágyazása nem megengedett.",
	Service_PurchasableContent = "A kért videó egy megvásárolandó elem és nem lejátszható.",
	Service_StreamOffline = "A kért stream jelenleg offline.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "A fordítást készítette: %s",

}
