-- Español language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Robert Lind (ptown2)

return {
	-- Basic information (metadata)
	Name = "Español",
	Author = "Robert Lind (ptown2)",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Volumen",
	Voteskips = "Omitido por votos",
	Loading = "Cargando...",
	Invalid = "[INVALIDO]",
	NoVideoPlaying = "No hay videos en seguimiento",
	Cancel = "Cancelar",
	Set = "Establecer",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Video actual solicitado por {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Solicitud del video esta invalido.",
	Theater_AlreadyQueued = "El video solicitado está ya en la lista.",
	Theater_ProcessingRequest = "Procesando {{rgb:158,37,33}}%s{{rgb:200,200,200}} solicitud...",
	Theater_RequestFailed = "Hubo un problema al procesar el video solicitado.",
	Theater_Voteskipped = "El video actual fue omitido por voto.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha obligado a omitir el video actual.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha reiniciado el teatro.",
	Theater_LostOwnership = "Usted ha perdido la propiedad y poder por salir de su teatro privado.",
	Theater_NotifyOwnership = "Usted es ahora el propietario de este teatro privado.",
	Theater_OwnerLockedQueue = "El dueño de este teatro ha cerrado la lista.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha cerrado la lista del teatro.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha abierto la lista del teatro.",
	Theater_OwnerUseOnly = "Solamente el propietario de este teatro puede usar eso.",
	Theater_PublicVideoLength = "Las solicitudes en teatros públicos son limitados a %s segundo(s) largo de video.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha votado para omitir {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} fue añadido a la lista.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Este mapa no está respaldado por el modo de juego Cinema.",
	Warning_Unsupported_Line2 = "Pulse el botón F1 para ver los mapas oficiales en el Steam Workshop.",
	Dependency_Missing_Line1 = "¡Vaya! Te falta algo...",
	Dependency_Missing_Line2 = "Pulse F4 para abrir el video de instrucciones.",

	-- Queue interface
	Queue_Title = "LISTA",
	Request_Video = "Solicitar video",
	Vote_Skip = "Omitir el video",
	Toggle_Fullscreen = "Alternar a pantalla completa",
	Refresh_Theater = "Actualizar teatro",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "DUEÑO",
	Theater_Skip = "Omitir",
	Theater_Seek = "Brincar",
	Theater_Reset = "Reiniciar",
	Theater_ChangeName = "Cambiar el nombre",
	Theater_QueueLock = "Alternar la lista de videos",
	Theater_SeekQuery = "HH:MM:SS o en segundos totales (ej. 1:30:00 ó 5400)",
	Theater_Pause = "Pausar",
	Theater_Resume = "Reanudar",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha pausado el vídeo.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha reanudado el vídeo.",

	-- Theater list
	TheaterList_NowShowing = "MOSTRANDO AHORA",

	-- Request Panel
	Request_History = "HISTORIAL",
	Request_Clear = "Eliminar",
	Request_DeleteTooltip = "Remover el historial de este video",
	Request_PlayCount = "%d solicitud(es)",
	Request_Url = "Solicitar el enlace",
	Request_Url_Tooltip = "Pulsar para solicitar un enlace de video.\nEl botón será rojo cuando el enlace es válido.",
	Request_Filter_AllServices = "Todos los servicios",
	Request_Filter_SortBy_LastRequest = "Última solicitud",
	Request_Filter_SortBy_Alphabet = "Alfabéticamente",
	Request_Filter_SortBy_Duration = "Duración",
	Request_Filter_SortBy_RequestCount = "Número de solicitudes",
	Request_Paginator_ResultCount = "%s resultados",
	Request_Paginator_PageOf = "Página %d de %d",

	-- Scoreboard settings panel
	Settings_Title = "AJUSTES",
	Settings_ClickActivate = "PULSAR CON EL BOTON IZQUIERDO PARA ACTIVAR",
	Settings_VolumeLabel = "Volumen",
	Settings_VolumeTooltip = "Pulsar los teclados +/- para incrementar o disminuir el volumen.",
	Settings_HidePlayersLabel = "Ocultar jugadores en el teatro",
	Settings_HidePlayersTooltip = "Habilite la selección para reducir la visibilidad de los jugadores en los teatros.",
	Settings_MuteFocusLabel = "Desactivar el audio mientras fuera de foco.",
	Settings_MuteFocusTooltip = "Habilite la selección para desactivar el audio en el teatro cuando Garry's Mod este fuera de foco. (ej. Minimizado)",
	Settings_SmoothVideoLabel = "Reproducción de video fluida",
	Settings_SmoothVideoTooltip = "Hace que algunos videos sean más fluidos a costa de los FPS.",

	-- Video Services
	Service_EmbedDisabled = "El video solicitado esta deshabilitado.",
	Service_PurchasableContent = "El video solicitado esta para compra y no se puede habilitar.",
	Service_StreamOffline = "El video en vivo solicitado está fuera de servicio.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Traducción hecha por %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s hora",
	Unit_Hours   = "%s horas",
	Unit_Minute  = "%s minuto",
	Unit_Minutes = "%s minutos",
	Unit_Second  = "%s segundo",
	Unit_Seconds = "%s segundos",
	Currency_Points = "%s Puntos",
	Currency_DonatorPoints = "%s Puntos de Donante",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "¡Este teatro no es privado y no se puede alquilar!",
	Rent_AlreadyRentedBy = "Este teatro ya está siendo alquilado por {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Ya estás alquilando {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Debes alquilar durante al menos %s minuto(s).",
	Rent_MaxTime = "No puedes alquilar durante más de %s minuto(s).",
	Rent_CantAfford = "¡No puedes pagar ese alquiler (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha alquilado este teatro durante %s.",
	Rent_ExtendNotRenting = "¡Ya debes estar alquilando este teatro para extender tu alquiler!",
	Rent_ExtendMinTime = "Debes extender el alquiler a un total de al menos %s minuto(s).",
	Rent_ExtendMaxTime = "No puedes alquilar más allá de %s minuto(s).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha extendido su alquiler de este teatro por otros %s.",
	Rent_RefundNotRenting = "Debes estar alquilando este teatro para reembolsar su alquiler.",
	Rent_RefundNotEnoughTime = "No queda suficiente tiempo en el alquiler para reembolsarlo.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} ha reembolsado su alquiler de este teatro.",
	Rent_Refunded = "Se te reembolsaron %s por %s minuto(s) de alquiler.",
	Rent_NotRented = "Este teatro no está siendo alquilado actualmente.",
	Rent_CancelledPublic = "El alquiler de este teatro de {{rgb:158,37,33}}%s{{rgb:200,200,200}} fue cancelado por un admin.",
	Rent_CancelledOwner = "Tu alquiler fue cancelado y se te reembolsaron %s por %s minuto(s) de alquiler.",
	Rent_CancelledAdmin = "Cancelaste el alquiler de {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Cancelaste el alquiler, pero su propietario se desconectó antes de poder ser reembolsado.",
	Rent_ExpiredOwner = "Tu alquiler en {{rgb:158,37,33}}%s{{rgb:200,200,200}} se ha agotado.",
	Rent_ExpiredPublic = "¡El alquiler de este teatro se ha agotado!",
	Rent_VoteSkipLocked = "El propietario de este teatro ha bloqueado las omisiones por voto.",
	Rent_VoteSkipUnlocked = "El propietario de este teatro ha desbloqueado las omisiones por voto.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "¡No puedes establecer un filtro de jugadores en un teatro que no es privado!",
	Rent_FilterNotRented = "¡Este teatro debe ser alquilado antes de que puedas establecer un filtro de jugadores en él!",
	Rent_FilterNotOwner = "¡Debes ser el propietario de este teatro para establecer un filtro de jugadores en él!",
	Rent_FilterUpdated = "El filtro de jugadores ha sido actualizado.",
	Rent_FilterAdminWarn = "Advertencia de Admin: Ahora estás filtrado de este teatro.",
	Rent_FilterSuperWarn = "Advertencia de Admin: {{rgb:158,37,33}}%s{{rgb:200,200,200}} fue filtrado de un teatro en el que se encuentra.",
	Rent_FilteredOut = "Has sido filtrado del teatro.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Actualmente estás alquilando este teatro durante los próximos %s.",
	Rent_CurrentlyRentedBy = "Este teatro está siendo alquilado actualmente por {{rgb:158,37,33}}%s{{rgb:200,200,200}} durante los próximos %s.",
	Rent_MustBeRented = "Este teatro debe ser alquilado para poder ser utilizado.",
	Rent_AdminFilteredWarn = "Advertencia de Admin: Estás filtrado de este teatro.",
	Rent_AdminEnteredFiltered = "Advertencia de Admin: {{rgb:158,37,33}}%s{{rgb:200,200,200}} entró en un teatro del que está filtrado.",
	Rent_NotAllowed = "No tienes permiso para estar en este teatro.",
	Rent_VoteSkipDisabled = "Lo sentimos, el propietario de este teatro ha deshabilitado las omisiones por voto.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Debes estar en un teatro para cancelar su alquiler.",
	Rent_MustBeInTheaterFilter = "Debes estar en tu teatro para establecer su filtro de jugadores.",
	Rent_MustBeInTheaterSeeFilter = "Debes estar en un teatro para ver su filtro de jugadores.",
	Rent_NotOwnerSeeFilter = "Debes ser propietario de este teatro para ver su filtro de jugadores.",
	Rent_MustBeInTheaterVoteLock = "Debes estar en un teatro para bloquear la omisión por voto.",
	Rent_NotOwnerVoteLock = "Debes ser propietario de este teatro para modificar la omisión por voto.",
	Rent_MustBeInTheaterRent = "¡Debes estar en un teatro para alquilarlo!",
	Rent_MustBeInTheaterRefund = "¡Debes estar en un teatro para reembolsar su alquiler!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Alquilar Teatro",
	Rent_Minutes = "Minutos",
	Rent_Purchase = "Comprar",
	Rent_PurchaseFor = "Comprar por %s",
	Rent_ToggleVoteSkipLock = "Alternar Bloqueo de Omisión por Voto",
	Rent_PlayerFilter = "Filtro de Jugadores",
	Rent_AddRentTime = "Añadir Tiempo de Alquiler",
	Rent_RefundButton = "Reembolsar Alquiler",
	Rent_CancelButton = "Cancelar Alquiler",
	Rent_Remaining = "Alquiler Restante",
	Rent_WhitelistMode = "Modo Lista Blanca",
	Rent_BlacklistMode = "Modo Lista Negra",
	Rent_Apply = "Aplicar",
	Rent_Retrieving = "Cargando...",
	Rent_Unknown = "Desconocido",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Abierto",
	Rent_OwnerDisconnected = "Propietario Desconectado",
	Rent_ThumbRemaining = "Alquiler Restante: %s",
}