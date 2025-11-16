-- Italiano language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Wolfaloo

return {
	-- Basic information (metadata)
	Name = "Italiano",
	Author = "Wolfaloo",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Volume",
	Voteskips = "Vota per saltare",
	Loading = "Caricamento...",
	Invalid = "[NON VALIDO]",
	NoVideoPlaying = "Nessun video in riproduzione",
	Cancel = "Cancella",
	Set = "Setta",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Video attuale richiesto da {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Richiesta non valida.",
	Theater_AlreadyQueued = "Il video richiesto è gia in coda.",
	Theater_ProcessingRequest = "Richiedendo il video a {{rgb:158,37,33}}%s{{rgb:200,200,200}} ...",
	Theater_RequestFailed = "Si è verificato un problema nella richiesta del video.",
	Theater_Voteskipped = "Il seguente video è stato saltato a causa di un voto.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha forzato il salto del video.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha resettato il teatro.",
	Theater_LostOwnership = "Hai perso la proprietà del teatro perchè lo hai abbandonato.",
	Theater_NotifyOwnership = "Sei il padrone di questo teatro.",
	Theater_OwnerLockedQueue = "Il proprietario del teatro ha bloccato la coda di riproduzione.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha bloccato la coda di riproduzione.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha sbloccato la coda di riproduzione.",
	Theater_OwnerUseOnly = "Solo il proprietario del teatro può usare questa funzione.",
	Theater_PublicVideoLength = "Le richieste in un teatro publico sono limitate ad una durata di %s second(s) secondi.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha votato per saltare {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} è stato aggiunto alla coda.",

	-- Warning messages
	Warning_Unsupported_Line1 = "La mappa attuale non è supportata da cinema gamemode",
	Warning_Unsupported_Line2 = "Premi F1 per aprire la mappa ufficiale nel Workshop Steam",

	-- Queue interface
	Queue_Title = "CODA",
	Request_Video = "Richiedi Video",
	Vote_Skip = "Vota per saltare",
	Toggle_Fullscreen = "Schermo intero",
	Refresh_Theater = "Ricarica teatro",

	-- Theater controls
	Theater_Admin = "AMMINISTRATORE",
	Theater_Owner = "PROPRIETARIO",
	Theater_Skip = "Salta",
	Theater_Seek = "Ripeti",
	Theater_Reset = "Resetta",
	Theater_ChangeName = "Cambia nome",
	Theater_QueueLock = "Blocca la coda",
	Theater_SeekQuery = "HH:MM:SS o numero di secondi (es. 1:30:00 o 5400)",

	-- Theater list
	TheaterList_NowShowing = "IN RIPRODUZIONE",

	-- Request Panel
	Request_History = "CRONOLOGIA",
	Request_Clear = "Pulisci",
	Request_DeleteTooltip = "Rimuovi video dalla cronologia",
	Request_PlayCount = "%d request(s)",
	Request_Url = "Richiedi URL",
	Request_Url_Tooltip = "Premi per richiedere un URL valido.\nil bottone sarà rosso quando l' URL sarà valido",

	-- Scoreboard settings panel
	Settings_Title = "IMPOSTAZIONI",
	Settings_ClickActivate = "CLICCA PER ATTIVARE IL MUOSE",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Usa i tasti +/- per aumentare/diminuire il volume.",
	Settings_HidePlayersLabel = "Nascondi giocatori nel teatro",
	Settings_HidePlayersTooltip = "Riduce la visibilità dei giocatori nel teatro.",
	Settings_MuteFocusLabel = "Silenzia l'audio alla pressione di alt-tab",
	Settings_MuteFocusTooltip = "Silenzia Gmod quando il gioco non è la finestra principale (es. premendo alt-tab).",

	-- Video Services
	Service_EmbedDisabled = "Il video richiesto non è abilitato all'incorporazione.",
	Service_PurchasableContent = "Il video richiesto è acquistabile e non può essere riprodotto.",
	Service_StreamOffline = "Lo stream richiesto è attualmente offline.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Traduzioni di %s",

}
