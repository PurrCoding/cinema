-- Français language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Raphy, Kcejalppe

return {
	-- Basic information (metadata)
	Name = "Français",
	Author = "Raphy, Kcejalppe",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Volume",
	Voteskips = "Votes de passage",
	Loading = "Chargement...",
	Invalid = "[INVALIDE]",
	NoVideoPlaying = "Pas de vidéo en lecture",
	Cancel = "Annuler",
	Set = "Régler",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Vidéo actuelle proposée par {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Requête vidéo invalide.",
	Theater_AlreadyQueued = "La vidéo proposée est déjà dans la liste d'attente.",
	Theater_ProcessingRequest = "Traitement de {{rgb:158,37,33}}%s{{rgb:200,200,200}} en cours...",
	Theater_RequestFailed = "Un problème est servenu lors du traitement de la vidéo proposée.",
	Theater_Voteskipped = "La vidéo actuelle a été passée.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a passé de force la vidéo actuelle.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a réinitialisé le théatre.",
	Theater_LostOwnership = "Vous avez perdu le statut de propriétaire du théatre car vous l'avez quitté.",
	Theater_NotifyOwnership = "Vous êtes maintenant le propriétaire de ce théatre privé.",
	Theater_OwnerLockedQueue = "Le propriétaire de ce théatre a verrouillé la liste d'attente.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a verrouillé la liste d'attente.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a déverrouillé la liste d'attente.",
	Theater_OwnerUseOnly = "Seul le propriétaire du théatre peut utiliser cela.",
	Theater_PublicVideoLength = "Les requêtes de théatres publics sont limitées à %s seconde(s).",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a voté pour passer {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a été ajoutée à la liste d'attente.",

	-- Warning messages
	Warning_Unsupported_Line1 = "La carte actuelle n'est pas supportée par le mode de jeu Cinema",
	Warning_Unsupported_Line2 = "Appuyez sur F1 pour ouvrir la carte officielle dans le workshop",

	-- Queue interface
	Queue_Title = "LISTE D'ATTENTE",
	Request_Video = "Proposer une vidéo",
	Vote_Skip = "Voter pour passer",
	Toggle_Fullscreen = "Activer le plein-écran",
	Refresh_Theater = "Actualiser le théatre",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "PROPRIETAIRE",
	Theater_Skip = "Passer",
	Theater_Seek = "Chercher",
	Theater_Reset = "Réinitialiser",
	Theater_ChangeName = "Changer le nom",
	Theater_QueueLock = "Verrouiller la liste d'attente",
	Theater_SeekQuery = "HH:MM:SS ou un nombre en secondes (par exemple 1:30:00 ou 5400)",

	-- Theater list
	TheaterList_NowShowing = "EN LECTURE",

	-- Request Panel
	Request_History = "HISTORIQUE",
	Request_Clear = "Effacer",
	Request_DeleteTooltip = "Effacer la vidéo de l'historique",
	Request_PlayCount = "%d requête(s)",
	Request_Url = "Proposer l'URL",
	Request_Url_Tooltip = "Appuyer pour proposer une URL de vidéo valide.\nLe bouton deviendra rouge si l'URL est valide.",

	-- Scoreboard settings panel
	Settings_Title = "OPTIONS",
	Settings_ClickActivate = "CLIQUER POUR ACTIVER LA SOURIS",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Utilisez les touches +/- pour augmenter/diminuer le volume.",
	Settings_HidePlayersLabel = "Masquer les joueurs dans le théatre",
	Settings_HidePlayersTooltip = "Réduire la visibilité des joueurs à l'intérieur du théatre.",
	Settings_MuteFocusLabel = "Désactiver le son dans le menu ALT-TAB",
	Settings_MuteFocusTooltip = "Désactiver le son de la vidéo quand Garry's Mod n'est pas au premier-plan (si ALT-TAB, par exemple).",

	-- Video Services
	Service_EmbedDisabled = "La vidéo proposée n'a pas l'intégration activée.",
	Service_PurchasableContent = "La vidéo proposée est un contenu payant et ne peut pas être lue.",
	Service_StreamOffline = "Le stream proposé est hors-ligne.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Traductions par %s",

}
