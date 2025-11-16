-- Deutsch language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Sapd

return {
	-- Basic information (metadata)
	Name = "Deutsch",
	Author = "Sapd",

	-- Common UI elements
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

	-- Theater list
	TheaterList_NowShowing = "AKTUELLE VORFÜHRUNGEN",

	-- Request Panel
	Request_History = "VERLAUF",
	Request_Clear = "Verlauf löschen",
	Request_DeleteTooltip = "Video vom Verlauf entfernen",
	Request_PlayCount = "Bereits %d Mal Angefordert",
	Request_Url = "URL Anfordern",
	Request_Url_Tooltip = "Drücken um einen gültigen Video Link anzufordern.\nDer Button wird rot sobald der Link gültig ist.",

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

	-- Credits

}
