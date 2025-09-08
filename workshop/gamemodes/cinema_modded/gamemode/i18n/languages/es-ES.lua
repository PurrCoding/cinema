-- Español language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Robert Lind (ptown2)

return {
	-- Basic information (metadata)
	Name = "Español",
	Author = "Robert Lind (ptown2)",

	-- Common UI elements
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

	-- Theater list
	TheaterList_NowShowing = "MOSTRANDO AHORA",

	-- Request Panel
	Request_History = "HISTORIAL",
	Request_Clear = "Eliminar",
	Request_DeleteTooltip = "Remover el historial de este video",
	Request_PlayCount = "%d solicitud(es)",
	Request_Url = "Solicitar el enlace",
	Request_Url_Tooltip = "Pulsar para solicitar un enlace de video.\nEl botón será rojo cuando el enlace es válido.",

	-- Scoreboard settings panel
	Settings_Title = "AJUSTES",
	Settings_ClickActivate = "PULSAR CON EL BOTON IZQUIERDO PARA ACTIVAR",
	Settings_VolumeLabel = "Volumen",
	Settings_VolumeTooltip = "Pulsar los teclados +/- para incrementar o disminuir el volumen.",
	Settings_HidePlayersLabel = "Ocultar jugadores en el teatro",
	Settings_HidePlayersTooltip = "Habilite la selección para reducir la visibilidad de los jugadores en los teatros.",
	Settings_MuteFocusLabel = "Desactivar el audio mientras fuera de foco.",
	Settings_MuteFocusTooltip = "Habilite la selección para desactivar el audio en el teatro cuando Garry's Mod este fuera de foco. (ej. Minimizado)",

	-- Video Services
	Service_EmbedDisabled = "El video solicitado esta deshabilitado.",
	Service_PurchasableContent = "El video solicitado esta para compra y no se puede habilitar.",
	Service_StreamOffline = "El video en vivo solicitado está fuera de servicio.",

	-- Act command (special case)

	-- Credits

}
