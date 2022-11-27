-- Basic information
LANG.Name       = "Português (Brasil)" -- Native name for language
LANG.Id         = "pt-BR"              -- Find corresponding ID in garrysmod/resource/localization
LANG.Author     = "Tiagoquix"          -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

-- Common
LANG.Cinema                     = "CINEMA"
LANG.Volume                     = "Volume"
LANG.Voteskips                  = "Pular?"
LANG.Loading                    = "Carregando..."
LANG.Invalid                    = "[INVÁLIDO]"
LANG.NoVideoPlaying             = "Nenhum vídeo sendo reproduzido"
LANG.Cancel                     = "Cancelar"
LANG.Set                        = "Definir"

-- Theater Announcements
-- modules/theater/cl_init.lua
-- modules/theater/sh_commands.lua
-- modules/theater/sh_theater.lua
LANG.Theater_VideoRequestedBy       = C("O vídeo atual foi solicitado por ",ColHighlight,"%s",ColDefault,".")
LANG.Theater_InvalidRequest         = "Solicitação de vídeo inválida."
LANG.Theater_AlreadyQueued          = "O vídeo solicitado já está na fila."
LANG.Theater_ProcessingRequest      = C("Processando solicitação do(a) ",ColHighlight,"%s",ColDefault,"...")
LANG.Theater_RequestFailed          = "Houve um problema ao processar o vídeo solicitado."
LANG.Theater_Voteskipped            = "O vídeo atual foi pulado por meio de votação."
LANG.Theater_ForceSkipped           = C(ColHighlight,"%s",ColDefault," forçou a pular o vídeo atual.")
LANG.Theater_PlayerReset            = C(ColHighlight,"%s",ColDefault," redefiniu o teatro.")
LANG.Theater_LostOwnership          = "Você perdeu a posse do teatro por ter saído dele."
LANG.Theater_NotifyOwnership        = "Você tomou posse do teatro privado."
LANG.Theater_OwnerLockedQueue       = "O dono do teatro bloqueou a fila."
LANG.Theater_LockedQueue            = C(ColHighlight,"%s",ColDefault," bloqueou a fila do teatro.")
LANG.Theater_UnlockedQueue          = C(ColHighlight,"%s",ColDefault," desbloqueou a fila do teatro.")
LANG.Theater_OwnerUseOnly           = "Somente o dono do teatro pode usar isso."
LANG.Theater_PublicVideoLength      = "Solicitações feitas em teatros públicos são limitadas a %s segundos de duração."
LANG.Theater_PlayerVoteSkipped      = C(ColHighlight,"%s",ColDefault," votou para pular ",ColHighlight,"(%s/%s)",ColDefault,".")
LANG.Theater_VideoAddedToQueue      = C(ColHighlight,"%s",ColDefault," foi adicionado à fila.")

-- Warnings
-- cl_init.lua
LANG.Warning_Unsupported_Line1  = "O mapa atual é incompatível com o modo de jogo Cinema"
LANG.Warning_Unsupported_Line2  = "Pressione F1 para abrir o mapa oficial na Oficina Steam"

-- Queue
-- modules/scoreboard/cl_queue.lua
LANG.Queue_Title                = "FILA"
LANG.Request_Video              = "Solicitar vídeo"
LANG.Vote_Skip                  = "Votar para pular"
LANG.Toggle_Fullscreen          = "Alternar tela cheia"
LANG.Refresh_Theater            = "Atualizar teatro"

-- Theater controls
-- modules/scoreboard/cl_admin.lua
LANG.Theater_Admin              = "ADMINISTRADOR"
LANG.Theater_Owner              = "DONO"
LANG.Theater_Skip               = "Pular"
LANG.Theater_Seek               = "Avançar"
LANG.Theater_Reset              = "Redefinir"
LANG.Theater_ChangeName         = "Alterar nome"
LANG.Theater_QueueLock          = "Alternar bloqueio da fila"
LANG.Theater_SeekQuery          = "HH:MM:SS ou número de segundos (por exemplo: 1:30:00 ou 5400)"

-- Theater list
-- modules/scoreboard/cl_theaterlist.lua
LANG.TheaterList_NowShowing     = "REPRODUZINDO AGORA"

-- Request Panel
-- modules/scoreboard/cl_request.lua
LANG.Request_History            = "HISTÓRICO"
LANG.Request_Clear              = "Limpar"
LANG.Request_DeleteTooltip      = "Remover este vídeo do histórico"
LANG.Request_PlayCount          = "%d solicitação(ões)" -- e.g. 10 request(s)
LANG.Request_Url                = "Solicitar URL"
LANG.Request_Url_Tooltip        = "Clique para solicitar um vídeo de um URL válido.\nO botão ficará vermelho quando o URL for válido."

-- Scoreboard settings panel
-- modules/scoreboard/cl_settings.lua
LANG.Settings_Title              = "CONFIGURAÇÕES"
LANG.Settings_ClickActivate      = "CLIQUE PARA ATIVAR O SEU MOUSE"
LANG.Settings_VolumeLabel        = "Volume"
LANG.Settings_VolumeTooltip      = "Use as teclas + e - para aumentar ou diminuir o volume."
LANG.Settings_HidePlayersLabel   = "Ocultar jogadores em teatros"
LANG.Settings_HidePlayersTooltip = "Reduz a visiblidade dos jogadores dentro de teatros."
LANG.Settings_MuteFocusLabel     = "Silenciar áudio enquanto minimizado"
LANG.Settings_MuteFocusTooltip   = "Silencia os vídeos enquanto o Garry's Mod estiver em segundo plano (por exemplo, ao minimizar)."
LANG.Settings_SmoothVideoLabel	 = "Reproduzir vídeos suavemente"
LANG.Settings_SmoothVideoTooltip = "Torna a reprodução de vídeos mais suave, mas reduz o desempenho do jogo."

-- Video Services
LANG.Service_EmbedDisabled      = "A incorporação do vídeo solicitado está desativada."
LANG.Service_PurchasableContent = "O vídeo solicitado é um conteúdo pago e não pode ser reproduzido."
LANG.Service_StreamOffline      = "O conteúdo solicitado está fora do ar."

-- Act command (don't bother translating this)
-- modules/taunts/sv_commands.lua
LANG.ActCommand = C(ColHighlight,"%s",ColDefault," %ss") -- e.g. Sam dances

-- Credits
LANG.TranslationsCredit = "Tradução feita por %s"