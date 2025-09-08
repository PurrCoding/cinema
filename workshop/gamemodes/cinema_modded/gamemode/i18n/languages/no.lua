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

	-- Theater list
	TheaterList_NowShowing = "VISER NÅ",

	-- Request Panel
	Request_History = "HISTORIE",
	Request_Clear = "Slett",
	Request_DeleteTooltip = "Fjern video fra histore",
	Request_PlayCount = "%d forespørsel(er)",
	Request_Url = "Be om en URL",
	Request_Url_Tooltip = "Klikk for å be om en gyldig video URL.\nKnappen vil bli rød når URL'en er ugyldig",

	-- Scoreboard settings panel
	Settings_Title = "INNSTILLINGER",
	Settings_ClickActivate = "KLIKK FOR Å AKTIVERE MUSEN",
	Settings_VolumeLabel = "Volum",
	Settings_VolumeTooltip = "Bruk +/- tastene for å øke/redusere volumet.",
	Settings_HidePlayersLabel = "Skjul Spillere I Kino",
	Settings_HidePlayersTooltip = "Reduser spiller synlighet inne i kinoene.",
	Settings_MuteFocusLabel = "Skru av lyd mens du er alt-tabbet",
	Settings_MuteFocusTooltip = "Skru av kino lyden mens Garry's Mod er ute av fokus (f.eks. i alt-tab).",

	-- Video Services
	Service_EmbedDisabled = "Innholdet til den følgende videoen er slått av.",
	Service_PurchasableContent = "Den forespurte videoen er kjøpt innhold og kan ikke bli spilt av.",
	Service_StreamOffline = "Den forespurte stream er offline.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Oversettelse av %s",

}
