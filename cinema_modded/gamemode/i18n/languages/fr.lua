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
	Dependency_Missing_Line1 = "Oups ! Il vous manque quelque chose...",
	Dependency_Missing_Line2 = "Appuyez sur F4 pour ouvrir la vidéo d'instructions.",

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
	Theater_Pause = "Pause",
	Theater_Resume = "Reprendre",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a mis la vidéo en pause.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a repris la vidéo.",

	-- Theater list
	TheaterList_NowShowing = "EN LECTURE",

	-- Request Panel
	Request_History = "HISTORIQUE",
	Request_Clear = "Effacer",
	Request_DeleteTooltip = "Effacer la vidéo de l'historique",
	Request_PlayCount = "%d requête(s)",
	Request_Url = "Proposer l'URL",
	Request_Url_Tooltip = "Appuyer pour proposer une URL de vidéo valide.\nLe bouton deviendra rouge si l'URL est valide.",
	Request_Filter_AllServices = "Tous les services",
	Request_Filter_SortBy_LastRequest = "Dernière requête",
	Request_Filter_SortBy_Alphabet = "Alphabétiquement",
	Request_Filter_SortBy_Duration = "Durée",
	Request_Filter_SortBy_RequestCount = "Nombre de requêtes",
	Request_Paginator_ResultCount = "%s résultats",
	Request_Paginator_PageOf = "Page %d sur %d",

	-- Scoreboard settings panel
	Settings_Title = "OPTIONS",
	Settings_ClickActivate = "CLIQUER POUR ACTIVER LA SOURIS",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Utilisez les touches +/- pour augmenter/diminuer le volume.",
	Settings_HidePlayersLabel = "Masquer les joueurs dans le théatre",
	Settings_HidePlayersTooltip = "Réduire la visibilité des joueurs à l'intérieur du théatre.",
	Settings_MuteFocusLabel = "Désactiver le son dans le menu ALT-TAB",
	Settings_MuteFocusTooltip = "Désactiver le son de la vidéo quand Garry's Mod n'est pas au premier-plan (si ALT-TAB, par exemple).",
	Settings_SmoothVideoLabel = "Lecture vidéo fluide",
	Settings_SmoothVideoTooltip = "Rend certaines vidéos plus fluides au détriment des FPS.",

	-- Video Services
	Service_EmbedDisabled = "La vidéo proposée n'a pas l'intégration activée.",
	Service_PurchasableContent = "La vidéo proposée est un contenu payant et ne peut pas être lue.",
	Service_StreamOffline = "Le stream proposé est hors-ligne.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Traductions par %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s heure",
	Unit_Hours   = "%s heures",
	Unit_Minute  = "%s minute",
	Unit_Minutes = "%s minutes",
	Unit_Second  = "%s seconde",
	Unit_Seconds = "%s secondes",
	Currency_Points = "%s Points",
	Currency_DonatorPoints = "%s Points de Donateur",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Ce théatre n'est pas privé et ne peut pas être loué !",
	Rent_AlreadyRentedBy = "Ce théatre est déjà loué par {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Vous louez déjà {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Vous devez louer pendant au moins %s minute(s).",
	Rent_MaxTime = "Vous ne pouvez pas louer pendant plus de %s minute(s).",
	Rent_CantAfford = "Vous ne pouvez pas vous permettre cette location (%s) !",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a loué ce théatre pendant %s.",
	Rent_ExtendNotRenting = "Vous devez déjà louer ce théatre pour prolonger votre location !",
	Rent_ExtendMinTime = "Vous devez prolonger la location à un total d'au moins %s minute(s).",
	Rent_ExtendMaxTime = "Vous ne pouvez pas louer au-delà de %s minute(s).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} a prolongé sa location de ce théatre de %s supplémentaires.",
	Rent_RefundNotRenting = "Vous devez louer ce théatre pour vous faire rembourser sa location.",
	Rent_RefundNotEnoughTime = "Il ne reste pas assez de temps sur la location pour la rembourser.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} s'est fait rembourser sa location de ce théatre.",
	Rent_Refunded = "Vous avez été remboursé de %s pour %s minute(s) de location.",
	Rent_NotRented = "Ce théatre n'est actuellement pas loué.",
	Rent_CancelledPublic = "La location de ce théatre par {{rgb:158,37,33}}%s{{rgb:200,200,200}} a été annulée par un admin.",
	Rent_CancelledOwner = "Votre location a été annulée et vous avez été remboursé de %s pour %s minute(s) de location.",
	Rent_CancelledAdmin = "Vous avez annulé la location de {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Vous avez annulé la location, mais son propriétaire s'est déconnecté avant de pouvoir être remboursé.",
	Rent_ExpiredOwner = "Votre location dans {{rgb:158,37,33}}%s{{rgb:200,200,200}} est arrivée à échéance.",
	Rent_ExpiredPublic = "La location de ce théatre est arrivée à échéance !",
	Rent_VoteSkipLocked = "Le propriétaire de ce théatre a verrouillé les votes de passage.",
	Rent_VoteSkipUnlocked = "Le propriétaire de ce théatre a déverrouillé les votes de passage.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Vous ne pouvez pas définir de filtre de joueurs sur un théatre qui n'est pas privé !",
	Rent_FilterNotRented = "Ce théatre doit être loué avant que vous puissiez y définir un filtre de joueurs !",
	Rent_FilterNotOwner = "Vous devez être le propriétaire de ce théatre pour y définir un filtre de joueurs !",
	Rent_FilterUpdated = "Le filtre de joueurs a été mis à jour.",
	Rent_FilterAdminWarn = "Avertissement Admin : Vous êtes maintenant filtré de ce théatre.",
	Rent_FilterSuperWarn = "Avertissement Admin : {{rgb:158,37,33}}%s{{rgb:200,200,200}} a été filtré d'un théatre dans lequel il se trouve.",
	Rent_FilteredOut = "Vous avez été filtré du théatre.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Vous louez actuellement ce théatre pour les %s à venir.",
	Rent_CurrentlyRentedBy = "Ce théatre est actuellement loué par {{rgb:158,37,33}}%s{{rgb:200,200,200}} pour les %s à venir.",
	Rent_MustBeRented = "Ce théatre doit être loué pour pouvoir être utilisé.",
	Rent_AdminFilteredWarn = "Avertissement Admin : Vous êtes filtré de ce théatre.",
	Rent_AdminEnteredFiltered = "Avertissement Admin : {{rgb:158,37,33}}%s{{rgb:200,200,200}} est entré dans un théatre dont il est filtré.",
	Rent_NotAllowed = "Vous n'êtes pas autorisé dans ce théatre.",
	Rent_VoteSkipDisabled = "Désolé, le propriétaire de ce théatre a désactivé les votes de passage.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Vous devez être dans un théatre pour annuler sa location.",
	Rent_MustBeInTheaterFilter = "Vous devez être dans votre théatre pour définir son filtre de joueurs.",
	Rent_MustBeInTheaterSeeFilter = "Vous devez être dans un théatre pour voir son filtre de joueurs.",
	Rent_NotOwnerSeeFilter = "Vous devez posséder ce théatre pour voir son filtre de joueurs.",
	Rent_MustBeInTheaterVoteLock = "Vous devez être dans un théatre pour verrouiller le vote de passage.",
	Rent_NotOwnerVoteLock = "Vous devez posséder ce théatre pour modifier le vote de passage.",
	Rent_MustBeInTheaterRent = "Vous devez être dans un théatre pour le louer !",
	Rent_MustBeInTheaterRefund = "Vous devez être dans un théatre pour vous faire rembourser sa location !",

	-- Theater Rentals: UI
	Rent_RentTheater = "Louer le théatre",
	Rent_Minutes = "Minutes",
	Rent_Purchase = "Acheter",
	Rent_PurchaseFor = "Acheter pour %s",
	Rent_ToggleVoteSkipLock = "Verrouiller/déverrouiller le vote de passage",
	Rent_PlayerFilter = "Filtre de joueurs",
	Rent_AddRentTime = "Ajouter du temps de location",
	Rent_RefundButton = "Rembourser la location",
	Rent_CancelButton = "Annuler la location",
	Rent_Remaining = "Location restante",
	Rent_WhitelistMode = "Mode liste blanche",
	Rent_BlacklistMode = "Mode liste noire",
	Rent_Apply = "Appliquer",
	Rent_Retrieving = "Récupération...",
	Rent_Unknown = "Inconnu",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Ouvert",
	Rent_OwnerDisconnected = "Propriétaire déconnecté",
	Rent_ThumbRemaining = "Location restante : %s",
}