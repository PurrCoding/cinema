-- Português (Brasil)
-- Author: Tiagoquix

return {
	-- Basic information (metadata)
	Name = "Português (Brasil)",
	Author = "Tiagoquix",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Volume",
	Voteskips = "Pular?",
	Loading = "Carregando...",
	Invalid = "[INVÁLIDO]",
	NoVideoPlaying = "Nenhum vídeo sendo reproduzido",
	Cancel = "Cancelar",
	Set = "Definir",

	-- Theater Announcements
	Theater_VideoRequestedBy = "O vídeo atual foi solicitado por {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Solicitação de vídeo inválida.",
	Theater_AlreadyQueued = "O vídeo solicitado já está na fila.",
	Theater_ProcessingRequest = "Processando solicitação do(a) {{rgb:158,37,33}}%s{{rgb:200,200,200}}...",
	Theater_RequestFailed = "Houve um problema ao processar o vídeo solicitado.",
	Theater_Voteskipped = "O vídeo atual foi pulado por meio de votação.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} forçou o vídeo atual a ser pulado.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} redefiniu o teatro.",
	Theater_LostOwnership = "Você perdeu a posse do teatro por ter saído dele.",
	Theater_NotifyOwnership = "Você tomou posse do teatro privado.",
	Theater_OwnerLockedQueue = "O dono do teatro travou a fila.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} travou a fila do teatro.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} destravou a fila do teatro.",
	Theater_OwnerUseOnly = "Somente o dono do teatro pode usar isto.",
	Theater_PublicVideoLength = "Solicitações feitas em teatros públicos são limitadas a %s segundos de duração.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} votou para pular {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} foi adicionado à fila.",

	-- Warning messages
	Warning_Unsupported_Line1 = "O mapa atual é incompatível com o modo de jogo Cinema.",
	Warning_Unsupported_Line2 = "Pressione F1 para abrir o mapa oficial na Oficina Steam.",
	Dependency_Missing_Line1 = "Opa! Alguma coisa está faltando...",
	Dependency_Missing_Line2 = "Pressione F4 para abrir o vídeo com as instruções.",

	-- Queue interface
	Queue_Title = "FILA",
	Request_Video = "Solicitar vídeo",
	Vote_Skip = "Votar para pular",
	Toggle_Fullscreen = "Alternar tela cheia",
	Refresh_Theater = "Atualizar teatro",

	-- Theater controls
	Theater_Admin = "ADMINISTRADOR",
	Theater_Owner = "DONO",
	Theater_Skip = "Pular",
	Theater_Seek = "Avançar",
	Theater_Reset = "Redefinir",
	Theater_ChangeName = "Alterar nome",
	Theater_QueueLock = "Alternar travamento da fila",
	Theater_SeekQuery = "HH:MM:SS ou número de segundos (por exemplo: 1:30:00 ou 5400)",
	Theater_Pause = "Pausar",
	Theater_Resume = "Retomar",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} pausou o vídeo.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} retomou o vídeo.",

	-- Theater list
	TheaterList_NowShowing = "REPRODUZINDO AGORA",

	-- Request Panel
	Request_History = "HISTÓRICO",
	Request_Clear = "Limpar",
	Request_DeleteTooltip = "Remover este vídeo do histórico",
	Request_PlayCount = "%d solicitação(ões)",
	Request_Url = "Solicitar URL",
	Request_Url_Tooltip = "Clique para solicitar um vídeo de um URL válido.\nO botão ficará vermelho quando o URL for válido.",
	Request_Filter_AllServices = "Todos os serviços",
	Request_Filter_SortBy_LastRequest = "Última solicitação",
	Request_Filter_SortBy_Alphabet = "Alfabeticamente",
	Request_Filter_SortBy_Duration = "Duração",
	Request_Filter_SortBy_RequestCount = "Número de solicitações",
	Request_Paginator_ResultCount = "%s resultados",
	Request_Paginator_PageOf = "Página %d de %d",

	-- Scoreboard settings panel
	Settings_Title = "CONFIGURAÇÕES",
	Settings_ClickActivate = "CLIQUE PARA ATIVAR O MOUSE",
	Settings_VolumeLabel = "Volume",
	Settings_VolumeTooltip = "Use as teclas \"+\" e \"-\" para aumentar ou diminuir o volume.",
	Settings_HidePlayersLabel = "Ocultar jogadores em teatros",
	Settings_HidePlayersTooltip = "Reduz a visiblidade dos jogadores dentro de teatros.",
	Settings_MuteFocusLabel = "Silenciar áudio em segundo plano",
	Settings_MuteFocusTooltip = "Silencia os vídeos enquanto o Garry's Mod estiver em segundo plano (por exemplo, ao minimizar o jogo).",
	Settings_SmoothVideoLabel = "Reproduzir vídeos suavemente",
	Settings_SmoothVideoTooltip = "Torna a reprodução de vídeos mais suave, mas reduz o desempenho do jogo.",

	-- Video Services
	Service_EmbedDisabled = "A incorporação do vídeo solicitado está desativada.",
	Service_PurchasableContent = "O vídeo solicitado é um conteúdo pago e não pode ser reproduzido.",
	Service_StreamOffline = "O conteúdo solicitado está fora do ar.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Tradução feita por %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s hora",
	Unit_Hours   = "%s horas",
	Unit_Minute  = "%s minuto",
	Unit_Minutes = "%s minutos",
	Unit_Second  = "%s segundo",
	Unit_Seconds = "%s segundos",
	Currency_Points = "%s Pontos",
	Currency_DonatorPoints = "%s Pontos de Doador",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Este teatro não é privado e não pode ser alugado!",
	Rent_AlreadyRentedBy = "Este teatro já está sendo alugado por {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Você já está alugando {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Você deve alugar por pelo menos %s minuto(s).",
	Rent_MaxTime = "Você não pode alugar por mais de %s minuto(s).",
	Rent_CantAfford = "Você não tem saldo suficiente para esse aluguel (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} alugou este teatro por %s.",
	Rent_ExtendNotRenting = "Você já precisa estar alugando este teatro para estender o aluguel!",
	Rent_ExtendMinTime = "Você deve estender o aluguel para um total de pelo menos %s minuto(s).",
	Rent_ExtendMaxTime = "Você não pode alugar além de %s minuto(s).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} estendeu o aluguel deste teatro por mais %s.",
	Rent_RefundNotRenting = "Você deve estar alugando este teatro para reembolsar o aluguel.",
	Rent_RefundNotEnoughTime = "Não há tempo suficiente restante no aluguel para reembolsá-lo.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} reembolsou o aluguel deste teatro.",
	Rent_Refunded = "Você foi reembolsado em %s por %s minuto(s) de aluguel.",
	Rent_NotRented = "Este teatro não está sendo alugado no momento.",
	Rent_CancelledPublic = "O aluguel de {{rgb:158,37,33}}%s{{rgb:200,200,200}} deste teatro foi cancelado por um administrador.",
	Rent_CancelledOwner = "Seu aluguel foi cancelado e você foi reembolsado em %s por %s minuto(s) de aluguel.",
	Rent_CancelledAdmin = "Você cancelou o aluguel de {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Você cancelou o aluguel, mas o dono se desconectou antes de poder ser reembolsado.",
	Rent_ExpiredOwner = "Seu aluguel em {{rgb:158,37,33}}%s{{rgb:200,200,200}} acabou.",
	Rent_ExpiredPublic = "O aluguel deste teatro acabou!",
	Rent_VoteSkipLocked = "O dono deste teatro travou as votações para pular.",
	Rent_VoteSkipUnlocked = "O dono deste teatro destravou as votações para pular.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Você não pode definir um filtro de jogadores em um teatro que não é privado!",
	Rent_FilterNotRented = "Este teatro precisa ser alugado antes de você poder definir um filtro de jogadores nele!",
	Rent_FilterNotOwner = "Você deve ser o dono deste teatro para definir um filtro de jogadores nele!",
	Rent_FilterUpdated = "O filtro de jogadores foi atualizado.",
	Rent_FilterAdminWarn = "Aviso do Administrador: Você agora está filtrado deste teatro.",
	Rent_FilterSuperWarn = "Aviso do Administrador: {{rgb:158,37,33}}%s{{rgb:200,200,200}} foi filtrado de um teatro em que está.",
	Rent_FilteredOut = "Você foi filtrado do teatro.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Você está atualmente alugando este teatro pelos próximos %s.",
	Rent_CurrentlyRentedBy = "Este teatro está atualmente sendo alugado por {{rgb:158,37,33}}%s{{rgb:200,200,200}} pelos próximos %s.",
	Rent_MustBeRented = "Este teatro precisa ser alugado para poder ser usado.",
	Rent_AdminFilteredWarn = "Aviso do Administrador: Você está filtrado deste teatro.",
	Rent_AdminEnteredFiltered = "Aviso do Administrador: {{rgb:158,37,33}}%s{{rgb:200,200,200}} entrou em um teatro do qual está filtrado.",
	Rent_NotAllowed = "Você não tem permissão para estar neste teatro.",
	Rent_VoteSkipDisabled = "Desculpe, o dono deste teatro desativou as votações para pular.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Você deve estar em um teatro para cancelar o aluguel dele.",
	Rent_MustBeInTheaterFilter = "Você deve estar no seu teatro para definir o filtro de jogadores dele.",
	Rent_MustBeInTheaterSeeFilter = "Você deve estar em um teatro para ver o filtro de jogadores dele.",
	Rent_NotOwnerSeeFilter = "Você deve ser dono deste teatro para ver o filtro de jogadores dele.",
	Rent_MustBeInTheaterVoteLock = "Você deve estar em um teatro para travar a votação para pular.",
	Rent_NotOwnerVoteLock = "Você deve ser dono deste teatro para modificar a votação para pular.",
	Rent_MustBeInTheaterRent = "Você deve estar em um teatro para alugá-lo!",
	Rent_MustBeInTheaterRefund = "Você deve estar em um teatro para reembolsar o aluguel dele!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Alugar Teatro",
	Rent_Minutes = "Minutos",
	Rent_Purchase = "Comprar",
	Rent_PurchaseFor = "Comprar por %s",
	Rent_ToggleVoteSkipLock = "Alternar Travamento da Votação para Pular",
	Rent_PlayerFilter = "Filtro de Jogadores",
	Rent_AddRentTime = "Adicionar Tempo de Aluguel",
	Rent_RefundButton = "Reembolsar Aluguel",
	Rent_CancelButton = "Cancelar Aluguel",
	Rent_Remaining = "Aluguel Restante",
	Rent_WhitelistMode = "Modo Lista Branca",
	Rent_BlacklistMode = "Modo Lista Negra",
	Rent_Apply = "Aplicar",
	Rent_Retrieving = "Obtendo...",
	Rent_Unknown = "Desconhecido",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Aberto",
	Rent_OwnerDisconnected = "Dono Desconectado",
	Rent_ThumbRemaining = "Aluguel Restante: %s",
}