-- Italiano
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
	Theater_PublicVideoLength = "Le richieste in un teatro pubblico sono limitate ad una durata di %s secondi.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha votato per saltare {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} è stato aggiunto alla coda.",

	-- Warning messages
	Warning_Unsupported_Line1 = "La mappa attuale non è supportata da cinema gamemode",
	Warning_Unsupported_Line2 = "Premi F1 per aprire la mappa ufficiale nel Workshop Steam",
	Dependency_Missing_Line1 = "Ops! Ti manca qualcosa...",
	Dependency_Missing_Line2 = "Premi F4 per aprire il video di istruzioni.",

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
	Theater_Pause = "Pausa",
	Theater_Resume = "Riprendi",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha messo in pausa il video.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha ripreso il video.",

	-- Theater list
	TheaterList_NowShowing = "IN RIPRODUZIONE",

	-- Request Panel
	Request_History = "CRONOLOGIA",
	Request_Clear = "Pulisci",
	Request_DeleteTooltip = "Rimuovi video dalla cronologia",
	Request_PlayCount = "%d richiesta/e",
	Request_Url = "Richiedi URL",
	Request_Url_Tooltip = "Premi per richiedere un URL valido.\nil bottone sarà rosso quando l' URL sarà valido",
	Request_Filter_AllServices = "Tutti i servizi",
	Request_Filter_SortBy_LastRequest = "Ultima richiesta",
	Request_Filter_SortBy_Alphabet = "Alfabeticamente",
	Request_Filter_SortBy_Duration = "Durata",
	Request_Filter_SortBy_RequestCount = "Numero di richieste",
	Request_Paginator_ResultCount = "%s risultati",
	Request_Paginator_PageOf = "Pagina %d di %d",

	-- Scoreboard settings panel
	Settings_Title = "IMPOSTAZIONI",
	Settings_ClickActivate = "CLICCA PER ATTIVARE IL MOUSE",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Usa i tasti +/- per aumentare/diminuire il volume.",
	Settings_HidePlayersLabel = "Nascondi giocatori nel teatro",
	Settings_HidePlayersTooltip = "Riduce la visibilità dei giocatori nel teatro.",
	Settings_MuteFocusLabel = "Silenzia l'audio alla pressione di alt-tab",
	Settings_MuteFocusTooltip = "Silenzia Gmod quando il gioco non è la finestra principale (es. premendo alt-tab).",
	Settings_SmoothVideoLabel = "Riproduzione video fluida",
	Settings_SmoothVideoTooltip = "Rende alcuni video più fluidi a scapito degli FPS.",

	-- Video Services
	Service_EmbedDisabled = "Il video richiesto non è abilitato all'incorporazione.",
	Service_PurchasableContent = "Il video richiesto è acquistabile e non può essere riprodotto.",
	Service_StreamOffline = "Lo stream richiesto è attualmente offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Traduzioni di %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s ora",
	Unit_Hours   = "%s ore",
	Unit_Minute  = "%s minuto",
	Unit_Minutes = "%s minuti",
	Unit_Second  = "%s secondo",
	Unit_Seconds = "%s secondi",
	Currency_Points = "%s Punti",
	Currency_DonatorPoints = "%s Punti Donatore",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Questo teatro non è privato e non può essere affittato!",
	Rent_AlreadyRentedBy = "Questo teatro è già affittato da {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Stai già affittando {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Devi affittare per almeno %s minuto/i.",
	Rent_MaxTime = "Non puoi affittare per più di %s minuto/i.",
	Rent_CantAfford = "Non puoi permetterti questo affitto (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha affittato questo teatro per %s.",
	Rent_ExtendNotRenting = "Devi già affittare questo teatro per estendere il tuo affitto!",
	Rent_ExtendMinTime = "Devi estendere l'affitto a un totale di almeno %s minuto/i.",
	Rent_ExtendMaxTime = "Non puoi affittare oltre %s minuto/i.",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha esteso l'affitto di questo teatro per altri %s.",
	Rent_RefundNotRenting = "Devi affittare questo teatro per ottenere il rimborso dell'affitto.",
	Rent_RefundNotEnoughTime = "Non c'è abbastanza tempo rimasto sull'affitto per rimborsarlo.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha rimborsato l'affitto di questo teatro.",
	Rent_Refunded = "Ti sono stati rimborsati %s per %s minuto/i di affitto.",
	Rent_NotRented = "Questo teatro attualmente non è affittato.",
	Rent_CancelledPublic = "L'affitto di questo teatro di {{rgb:158,37,33}}%s{{rgb:200,200,200}} è stato annullato da un admin.",
	Rent_CancelledOwner = "Il tuo affitto è stato annullato e ti sono stati rimborsati %s per %s minuto/i di affitto.",
	Rent_CancelledAdmin = "Hai annullato l'affitto di {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Hai annullato l'affitto, ma il suo proprietario si è disconnesso prima di poter essere rimborsato.",
	Rent_ExpiredOwner = "Il tuo affitto in {{rgb:158,37,33}}%s{{rgb:200,200,200}} è scaduto.",
	Rent_ExpiredPublic = "L'affitto di questo teatro è scaduto!",
	Rent_VoteSkipLocked = "Il proprietario di questo teatro ha bloccato i voti per saltare.",
	Rent_VoteSkipUnlocked = "Il proprietario di questo teatro ha sbloccato i voti per saltare.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Non puoi impostare un filtro giocatori su un teatro che non è privato!",
	Rent_FilterNotRented = "Questo teatro deve essere affittato prima di poter impostare un filtro giocatori su di esso!",
	Rent_FilterNotOwner = "Devi essere il proprietario di questo teatro per impostare un filtro giocatori su di esso!",
	Rent_FilterUpdated = "Il filtro giocatori è stato aggiornato.",
	Rent_FilterAdminWarn = "Avviso Admin: Ora sei filtrato da questo teatro.",
	Rent_FilterSuperWarn = "Avviso Admin: {{rgb:158,37,33}}%s{{rgb:200,200,200}} è stato filtrato da un teatro in cui si trova.",
	Rent_FilteredOut = "Sei stato filtrato dal teatro.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Stai attualmente affittando questo teatro per i prossimi %s.",
	Rent_CurrentlyRentedBy = "Questo teatro è attualmente affittato da {{rgb:158,37,33}}%s{{rgb:200,200,200}} per i prossimi %s.",
	Rent_MustBeRented = "Questo teatro deve essere affittato per poter essere utilizzato.",
	Rent_AdminFilteredWarn = "Avviso Admin: Sei filtrato da questo teatro.",
	Rent_AdminEnteredFiltered = "Avviso Admin: {{rgb:158,37,33}}%s{{rgb:200,200,200}} è entrato in un teatro da cui è filtrato.",
	Rent_NotAllowed = "Non sei autorizzato in questo teatro.",
	Rent_VoteSkipDisabled = "Spiacenti, il proprietario di questo teatro ha disabilitato i voti per saltare.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Devi essere in un teatro per annullarne l'affitto.",
	Rent_MustBeInTheaterFilter = "Devi essere nel tuo teatro per impostarne il filtro giocatori.",
	Rent_MustBeInTheaterSeeFilter = "Devi essere in un teatro per vederne il filtro giocatori.",
	Rent_NotOwnerSeeFilter = "Devi possedere questo teatro per vederne il filtro giocatori.",
	Rent_MustBeInTheaterVoteLock = "Devi essere in un teatro per bloccare il voto per saltare.",
	Rent_NotOwnerVoteLock = "Devi possedere questo teatro per modificare il voto per saltare.",
	Rent_MustBeInTheaterRent = "Devi essere in un teatro per affittarlo!",
	Rent_MustBeInTheaterRefund = "Devi essere in un teatro per ottenere il rimborso del suo affitto!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Affitta Teatro",
	Rent_Minutes = "Minuti",
	Rent_Purchase = "Acquista",
	Rent_PurchaseFor = "Acquista per %s",
	Rent_ToggleVoteSkipLock = "Attiva/Disattiva Blocco Voti per Saltare",
	Rent_PlayerFilter = "Filtro Giocatori",
	Rent_AddRentTime = "Aggiungi Tempo di Affitto",
	Rent_RefundButton = "Rimborsa Affitto",
	Rent_CancelButton = "Annulla Affitto",
	Rent_Remaining = "Affitto Rimanente",
	Rent_WhitelistMode = "Modalità Whitelist",
	Rent_BlacklistMode = "Modalità Blacklist",
	Rent_Apply = "Applica",
	Rent_Retrieving = "Recupero...",
	Rent_Unknown = "Sconosciuto",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Aperto",
	Rent_OwnerDisconnected = "Proprietario Disconnesso",
	Rent_ThumbRemaining = "Affitto Rimanente: %s",
}