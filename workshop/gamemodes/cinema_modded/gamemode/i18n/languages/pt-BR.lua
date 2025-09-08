-- Português (Brasil) language file for Cinema gamemode
-- Converted from monolithic i18n.lua
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

	-- Credits
	TranslationsCredit = "Tradução feita por %s",

}
