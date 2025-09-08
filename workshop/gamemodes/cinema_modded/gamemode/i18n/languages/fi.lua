-- Suomi language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Jani

return {
	-- Basic information (metadata)
	Name = "Suomi",
	Author = "Jani",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Äänenvoimakkuus",
	Voteskips = "Äänestys ohittamiseen",
	Loading = "Lataa...",
	Invalid = "[VIRHEELLINEN]",
	NoVideoPlaying = "Ei videota käynnissä",
	Cancel = "Peruuta",
	Set = "Valitse",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Tämänhetkistä videota on ehdottanut {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Virheellinen videopyyntö.",
	Theater_AlreadyQueued = "Pyydetty video on jo jonossa.",
	Theater_ProcessingRequest = "Käsitellään {{rgb:158,37,33}}%s{{rgb:200,200,200}} pyyntöä...",
	Theater_RequestFailed = "Pyynnetyn videon käsittelyssä ilmeni ongelma.",
	Theater_Voteskipped = "Tämänhetkinen video on äänestetty ohitettavaksi.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on pakottanut nykyisen videon ohitettavaksi.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on käynnistänyt teatterin uudelleen.",
	Theater_LostOwnership = "Olet menettänyt teatterin omistajuuden lähtemisen vuoksi.",
	Theater_NotifyOwnership = "Olet nyt tämän yksityisen teatterin omistaja.",
	Theater_OwnerLockedQueue = "Teatterin omistaja on lukinnut videojonon.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on lukinnut videojonon.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on avannut teatterin videojonon.",
	Theater_OwnerUseOnly = "Vain teatterin omistaja voi käyttää tuota.",
	Theater_PublicVideoLength = "Julkisen teatterin videopyynnöt ovat rajoitettu %s sekunnin pituuteen.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on äänestänyt ohittamista {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on lisätty videojonoon.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Nykyinen kartta ei tue Cinema-pelimuotoa.",
	Warning_Unsupported_Line2 = "Paina F1 avataksesi virallisen kartan workshopissa.",

	-- Queue interface
	Queue_Title = "VIDEOJONO",
	Request_Video = "Tee videopyyntö",
	Vote_Skip = "Äänestä ohittamista",
	Toggle_Fullscreen = "Vaihda kokoruututilaan",
	Refresh_Theater = "Lataa teatteri uudelleen",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "OMISTAJA",
	Theater_Skip = "Ohita",
	Theater_Seek = "Siirry kohtaan",
	Theater_Reset = "Käynnistä uudelleen",
	Theater_ChangeName = "Vaihda nimi",
	Theater_QueueLock = "Videojonon lukko on/off",
	Theater_SeekQuery = "HH:MM:SS tai sekunnit numeroina (esim. 1:30:00 tai 5400)",

	-- Theater list
	TheaterList_NowShowing = "NYT TOISTOSSA",

	-- Request Panel
	Request_History = "HISTORIA",
	Request_Clear = "Tyhjennä",
	Request_DeleteTooltip = "Poista video historiasta",
	Request_PlayCount = "%d pyyntö(ä)",
	Request_Url = "Pyydä URL:ia toistettavaksi",
	Request_Url_Tooltip = "Paina pyytääksesi kelvollista URL:ia toistettavaksi.\nPainike on punainen, jos URL on kelvollinen.",

	-- Scoreboard settings panel
	Settings_Title = "ASETUKSET",
	Settings_ClickActivate = "KLIKKAA AKTIVOIDAKSESI HIIRI",
	Settings_VolumeLabel = "Äänenvoimakkuus",
	Settings_VolumeTooltip = "Käytä +/- näppäimiä nostaaksesi/pienentääksesi äänenvoimakkuutta.",
	Settings_HidePlayersLabel = "Älä näytä pelaajia teatterissa",
	Settings_HidePlayersTooltip = "Vähennä pelaajien näkyvyyttä teattereissa.",
	Settings_MuteFocusLabel = "Mykistä audio kun siirryt toiseen ohjelmaan(Alt+Tab)",
	Settings_MuteFocusTooltip = "Mykistä teatterin audio kun Garry's Mod ei ole päällimmäisenä.",

	-- Video Services
	Service_EmbedDisabled = "Pyydetty video ei ole upotettavissa.",
	Service_PurchasableContent = "Pyydetty video on ostettavaa materiaalia eikä ole toistettavissa.",
	Service_StreamOffline = "Pyydetty videostreami on offline.",

	-- Act command (special case)

	-- Credits

}
