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
	Theater_LostOwnership = "Je hebt hebt het eigenaarschap over deze bioscoop verloren omdat je het hebt verlaten.",
	Theater_NotifyOwnership = "Je bent nu de eigenaar van deze privébioscoop.",
	Theater_OwnerLockedQueue = "De bioscoopeigenaar heeft de rij gesloten.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de rij gesloten.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft de rij geopend",
	Theater_OwnerUseOnly = "Alleen de bioscoopeigenaar kan dit doen.",
	Theater_PublicVideoLength = "Verzoeken in openbare bioscopen hebben een tijdslimiet van $s seconde(n)",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} heeft gestemd om {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}over te slaan.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} is aan de rij toegevoegd",

	-- Warning messages
	Warning_Unsupported_Line1 = "De huidige map wordt niet ondersteunt door de Cinema gamemode",
	Warning_Unsupported_Line2 = "Druk op F1 om de officiële map te openen in workshop",

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

	-- Theater list
	TheaterList_NowShowing = "NU OP",

	-- Request Panel
	Request_History = "GESCHIEDENIS",
	Request_Clear = "Wis",
	Request_DeleteTooltip = "Wis video uit geschiedenis",
	Request_PlayCount = "%d verzoek(en)",
	Request_Url = "Verzoek URL",
	Request_Url_Tooltip = "Druk om een geldige video URL te verzoeken.\nDe knop is rood als de URL geldig is",

	-- Scoreboard settings panel
	Settings_Title = "INSTELLINGEN",
	Settings_ClickActivate = "KLIK OM JE MUIS TE ACTIVEREN",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Gebruik de +/- knoppen om je volume harder/zachter te zetten.",
	Settings_HidePlayersLabel = "Verberg Spelers In Bioscoop",
	Settings_HidePlayersTooltip = "Verminder spelerzichtbaarheid binnen bioscopen.",
	Settings_MuteFocusLabel = "Demp audio wanneer gealt-tabd",
	Settings_MuteFocusTooltip = "Demp bioscoopvolume wanneer Garry's Mod niet geselecteerd is (bv. in alt-tab.)",

	-- Video Services
	Service_EmbedDisabled = "Bij de verzochte video zijn insluitingen uitgeschakeld",
	Service_PurchasableContent = "De verzochte video is koopbaar materiaal en kan niet afgesleepd worden.",
	Service_StreamOffline = "De verzochte stream is offline.",

	-- Act command (special case)

	-- Credits

}
