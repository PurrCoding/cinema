if CLIENT then

	local DefaultId = "en"
	local CurrentId = GetConVar("gmod_language"):GetString()

	local patterns = {
		format 	= "{{%s:%s}}",
		tag 	= "{{.-}}",
		data 	= "{{(.-):(.-)}}",
		rgb 	= "(%d+),(%d+),(%d+)"
	}

	local function parseTag(tag)
		local key, value = tag:match(patterns.data)

		-- Deserialize color
		if key == "rgb" then
			local r,g,b = value:match(patterns.rgb)
			return Color(r,g,b)
		end

		return tag
	end

	local function Compile(...)
		local str = ""
		for _, v in pairs({...}) do
			-- Serialize color
			if istable(v) and v.r and v.g and v.b then
				local col = ("%d,%d,%d"):format(v.r, v.g, v.b)
				str = str .. patterns.format:format("rgb", col)
			else
				str = str .. tostring(v)
			end
		end
		return str
	end

	local Languages = {
		["en"] = {
			-- Basic information
			Name = "English", -- Native name for language
			Author = "PixelTail Games", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Volume",
			Voteskips = "Voteskips",
			Loading = "Loading...",
			Invalid = "[INVALID]",
			NoVideoPlaying = "No video playing",
			Cancel = "Cancel",
			Set = "Set",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("The current video was requested by ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Invalid video request.",
			Theater_AlreadyQueued = "The requested video is already in the queue.",
			Theater_ProcessingRequest = Compile("Processing ", ColHighlight, "%s", ColDefault, " request..."),
			Theater_RequestFailed = "There was a problem processing the requested video.",
			Theater_Voteskipped = "The current video has been voteskipped.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " has forced the current video to be skipped."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " has reset the theater."),
			Theater_LostOwnership = "You have lost theater ownership due to leaving the theater.",
			Theater_NotifyOwnership = "You are now the owner of the private theater.",
			Theater_OwnerLockedQueue = "The owner of the theater has locked the queue.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " has locked the theater queue."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " has unlocked the theater queue."),
			Theater_OwnerUseOnly = "Only the theater owner can use that.",
			Theater_PublicVideoLength = "Public theater requests are limited to %s seconds in length.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " has voted to skip ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " has been added to the queue."),

			-- Warnings
			Warning_Unsupported_Line1 = "The current map is unsupported by the Cinema gamemode.",
			Warning_Unsupported_Line2 = "Press F1 to open the official map on the Steam Workshop.",

			Dependency_Missing_Line1 = "Oops! You are missing something...",
			Dependency_Missing_Line2 = "Press F4 to open the instructions video.",

			-- Queue
			Queue_Title = "QUEUE",
			Request_Video = "Request video",
			Vote_Skip = "Vote to skip",
			Toggle_Fullscreen = "Toggle fullscreen",
			Refresh_Theater = "Refresh theater",

			-- Theater controls
			Theater_Admin = "ADMIN",
			Theater_Owner = "OWNER",
			Theater_Skip = "Skip",
			Theater_Seek = "Seek",
			Theater_Reset = "Reset",
			Theater_ChangeName = "Change name",
			Theater_QueueLock = "Toggle queue lock",
			Theater_SeekQuery = "HH:MM:SS or number of seconds (e.g. 1:30:00 or 5400)",

			-- Theater list
			TheaterList_NowShowing = "NOW PLAYING",

			-- Request Panel
			Request_History = "HISTORY",
			Request_Clear = "Clear",
			Request_DeleteTooltip = "Remove this video from history",
			Request_PlayCount = "%d request(s)", -- e.g. 10 request(s)
			Request_Url = "Request URL",
			Request_Url_Tooltip = "Press to request a video from a valid URL.\nThe button will turn red when the URL is valid.",
			Request_Filter_AllServices = "All services",
			Request_Filter_SortBy_LastRequest = "Last request",
			Request_Filter_SortBy_Alphabet = "Alphabetically",
			Request_Filter_SortBy_Duration = "Duration",
			Request_Filter_SortBy_RequestCount = "Request count",
			Request_Paginator_ResultCount = "%s results",
			Request_Paginator_PageOf = "Page %d of %d",

			-- Scoreboard settings panel
			Settings_Title = "SETTINGS",
			Settings_ClickActivate = "CLICK TO ACTIVATE YOUR MOUSE",
			Settings_VolumeLabel = "Volume",
			Settings_VolumeTooltip = "Use the \"+\" and \"-\" keys to increase or decrease the volume.",
			Settings_HidePlayersLabel = "Hide players in theaters",
			Settings_HidePlayersTooltip = "Reduces player visibility inside of theaters.",
			Settings_MuteFocusLabel = "Mute audio while alt-tabbed",
			Settings_MuteFocusTooltip = "Mutes theater volume while Garry's Mod is out-of-focus (e.g. while alt-tabbed).",
			Settings_SmoothVideoLabel = "Smooth video playback",
			Settings_SmoothVideoTooltip = "Make some videos smoother at the cost of FPS.",

			-- Video Services
			Service_EmbedDisabled = "The requested video has disabled embed support.",
			Service_PurchasableContent = "The requested video is a paid content and cannot be played.",
			Service_StreamOffline = "The requested stream is offline.",

			-- Act command (don't bother translating this)
			ActCommand = Compile(ColHighlight, "%s", ColDefault, " %ss"), -- e.g. Sam dances

			-- Credits
			TranslationsCredit = "Translations made by %s",
		},
		["pt-BR"] = {
			-- Basic information
			Name = "Português (Brasil)", -- Native name for language
			Author = "Tiagoquix", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Volume",
			Voteskips = "Pular?",
			Loading = "Carregando...",
			Invalid = "[INVÁLIDO]",
			NoVideoPlaying = "Nenhum vídeo sendo reproduzido",
			Cancel = "Cancelar",
			Set = "Definir",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("O vídeo atual foi solicitado por ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Solicitação de vídeo inválida.",
			Theater_AlreadyQueued = "O vídeo solicitado já está na fila.",
			Theater_ProcessingRequest = Compile("Processando solicitação do(a) ", ColHighlight, "%s", ColDefault, "..."),
			Theater_RequestFailed = "Houve um problema ao processar o vídeo solicitado.",
			Theater_Voteskipped = "O vídeo atual foi pulado por meio de votação.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " forçou o vídeo atual a ser pulado."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " redefiniu o teatro."),
			Theater_LostOwnership = "Você perdeu a posse do teatro por ter saído dele.",
			Theater_NotifyOwnership = "Você tomou posse do teatro privado.",
			Theater_OwnerLockedQueue = "O dono do teatro travou a fila.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " travou a fila do teatro."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " destravou a fila do teatro."),
			Theater_OwnerUseOnly = "Somente o dono do teatro pode usar isto.",
			Theater_PublicVideoLength = "Solicitações feitas em teatros públicos são limitadas a %s segundos de duração.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " votou para pular ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " foi adicionado à fila."),

			-- Warnings
			Warning_Unsupported_Line1 = "O mapa atual é incompatível com o modo de jogo Cinema.",
			Warning_Unsupported_Line2 = "Pressione F1 para abrir o mapa oficial na Oficina Steam.",

			Dependency_Missing_Line1 = "Opa! Alguma coisa está faltando...",
			Dependency_Missing_Line2 = "Pressione F4 para abrir o vídeo com as instruções.",

			-- Queue
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
			Request_PlayCount = "%d solicitação(ões)", -- e.g. 10 request(s)
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

			-- Credits
			TranslationsCredit = "Tradução feita por %s",
		},
		["zh-TW"] = {
			-- Basic information
			Name = "Chinese 台灣正體", -- Native name for language
			Author = "Poheart", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "電影院",
			Volume = "音量",
			Voteskips = "投票跳過",
			Loading = "載入中...",
			Invalid = "[無效]",
			NoVideoPlaying = "沒有影片播放中",
			Cancel = "取消",
			Set = "設定",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("目前的影片由 ", ColHighlight, "%s", ColDefault, "提出."),
			Theater_InvalidRequest = "無效的影片請求.",
			Theater_AlreadyQueued = "所請求的影片已經在佇列中.",
			Theater_ProcessingRequest = Compile("正在處理 ", ColHighlight, "%s", ColDefault, " 的請求..."),
			Theater_RequestFailed = "處理所請求的影片時出現了問題.",
			Theater_Voteskipped = "目前的的影片已經被投票跳過.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " 已強制跳過目前的影片."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " 已重設影院."),
			Theater_LostOwnership = "由於你已經離開影院,你失去了影院的擁有權.",
			Theater_NotifyOwnership = "你現在是本私人影院的擁有者.",
			Theater_OwnerLockedQueue = "影院擁有者已鎖定了本影院的影片佇列.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " 已鎖定了本影院的影片佇列."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " 已解鎖了本影院的影片佇列."),
			Theater_OwnerUseOnly = "只有影院擁有者才能使用.",
			Theater_PublicVideoLength = "公眾影院的影片請求只能播放 %s 秒內的長度",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " 已投票跳過目前的影片 ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " 已加入到佇列."),

			-- Warnings
			Warning_Unsupported_Line1 = "目前地圖不支援Cinema模式",
			Warning_Unsupported_Line2 = "請按F1打開Steam Workship的Cinema模式官方地圖",

			-- Queue
			Queue_Title = "佇列",
			Request_Video = "請求影片",
			Vote_Skip = "投票跳過",
			Toggle_Fullscreen = "切換全屏模式",
			Refresh_Theater = "刷新影院",

			-- Theater controls
			Theater_Admin = "管理員",
			Theater_Owner = "擁有者",
			Theater_Skip = "跳過",
			Theater_Seek = "跳至",
			Theater_Reset = "重設",
			Theater_ChangeName = "更改名稱",
			Theater_QueueLock = "切換佇列鎖定",
			Theater_SeekQuery = "HH:MM:SS 或秒數 (e.g. 1:30:00 或 5400)",

			-- Theater list
			TheaterList_NowShowing = "現正放映",

			-- Request Panel
			Request_History = "播放記錄",
			Request_Clear = "清除",
			Request_DeleteTooltip = "從播放記錄中移除",
			Request_PlayCount = "%d 個請求", -- e.g. 10 request(s)
			Request_Url = "請求網址",
			Request_Url_Tooltip = "按下請求一個有效的視頻網址.\n按鈕將會變成紅色當您提供一個有效的URL",

			-- Scoreboard settings panel
			Settings_Title = "設定",
			Settings_ClickActivate = "按一下顯示你的鼠標",
			Settings_VolumeLabel = "音量",
			Settings_VolumeTooltip = "利用 +/- 鍵以 增加/減小 音量.",
			Settings_HidePlayersLabel = "隱藏影院內其他玩家",
			Settings_HidePlayersTooltip = "減低影院內的玩家可見性.",
			Settings_MuteFocusLabel = "當Alt-Tab時靜音",
			Settings_MuteFocusTooltip = "當你Alt-tab 切換窗口時靜音影院內播放的視頻.",

			-- Video Services
			Service_EmbedDisabled = "所請求的影片禁用了嵌入式播放的使用.",
			Service_PurchasableContent = "所請求的影片是可購買內容因此不能被播放.",
			Service_StreamOffline = "所請求的直播已離線.",

			-- Credits
			TranslationsCredit = "由 %s 翻譯",

		},
		["zh-CN"] = {
			-- Basic information
			Name = "简体中文", -- Native name for language
			Author = "初雪OriginalSnow", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "电影院",
			Volume = "音量",
			Voteskips = "投票跳过",
			Loading = "加载中...",
			Invalid = "[无效]",
			NoVideoPlaying = "当前没有视频播放",
			Cancel = "取消",
			Set = "设置",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("当前的视频由 ", ColHighlight, "%s", ColDefault, " 点播"),
			Theater_InvalidRequest = "你的点播无效",
			Theater_AlreadyQueued = "你的点播已经在排队列表中",
			Theater_ProcessingRequest = Compile("正在处理 ", ColHighlight, "%s", ColDefault, " 的点播..."),
			Theater_RequestFailed = "视频点播时出了一点小问题...",
			Theater_Voteskipped = "该视频已被投票跳过",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " 已强制跳过当前视频"),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " 重置了当前影院"),
			Theater_LostOwnership = "由于你离开了影院，你已失去该影院的所有权",
			Theater_NotifyOwnership = "你现在是该私人影院的拥有者了",
			Theater_OwnerLockedQueue = "影院拥有者锁定了该影院的视频点播",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " 已经锁定了该影院的点播权限"),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " 已经解锁了该影院的点播权限"),
			Theater_OwnerUseOnly = "只有影院拥有者才能使用.",
			Theater_PublicVideoLength = "公共影院只能点播 %s 秒内的视频",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " 投票跳过： ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " 已点播"),

			-- Warnings
			Warning_Unsupported_Line1 = "当前地图不支持Cinema模式",
			Warning_Unsupported_Line2 = "按下 F1 来打开创意工坊的 Cinema 官方地图",

			Dependency_Missing_Line1 = "哎呀！你好像丢失了某些东西...",
			Dependency_Missing_Line2 = "按下 F4 来打开介绍视频",

			-- Queue
			Queue_Title = "点播列表",
			Request_Video = "点播",
			Vote_Skip = "投票跳过",
			Toggle_Fullscreen = "切换全屏",
			Refresh_Theater = "刷新影院",

			-- Theater controls
			Theater_Admin = "管理员",
			Theater_Owner = "拥有者",
			Theater_Skip = "跳过",
			Theater_Seek = "跳转",
			Theater_Reset = "重置",
			Theater_ChangeName = "修改影院名称",
			Theater_QueueLock = "锁定点播列表",
			Theater_SeekQuery = "HH:MM:SS 或秒数 (示例： 1:30:00 或 5400)",

			-- Theater list
			TheaterList_NowShowing = "正在播放",

			-- Request Panel
			Request_History = "历史记录",
			Request_Clear = "清空",
			Request_DeleteTooltip = "从历史记录中删除",
			Request_PlayCount = "%d 个请求",
			Request_Url = "点播该视频",
			Request_Url_Tooltip = "当地址有效时\n该按钮会变红哦",
			Request_Filter_AllServices = "全部",
			Request_Filter_SortBy_LastRequest = "按点播顺序排列",
			Request_Filter_SortBy_Alphabet = "按字母顺序排列",
			Request_Filter_SortBy_Duration = "按时间顺序排列",
			Request_Filter_SortBy_RequestCount = "按点播次数排列",
			Request_Paginator_ResultCount = "%s 个点播",
			Request_Paginator_PageOf = "第 %d / %d 页",

			-- Scoreboard settings panel
			Settings_Title = "设置",
			Settings_ClickActivate = "按一下左键来呼出鼠标",
			Settings_VolumeLabel = "音量",
			Settings_VolumeTooltip = "使用 +/- 键来 增加/减小 音量",
			Settings_HidePlayersLabel = "隐藏其他玩家",
			Settings_HidePlayersTooltip = "降低其他玩家的可见性",
			Settings_MuteFocusLabel = "失去焦点时静音",
			Settings_MuteFocusTooltip = "当GMod失去焦点后，静音视频",
			Settings_SmoothVideoLabel = "优化视频播放",
			Settings_SmoothVideoTooltip = "通过降低FPS来提升视频流畅度",

			-- Video Services
			Service_EmbedDisabled = "你所点播的视频禁止嵌入式播放！",
			Service_PurchasableContent = "你所点播的视频可能是付费内容",
			Service_StreamOffline = "直播已停止",

			-- Credits
			TranslationsCredit = "%s 翻译",
		},
		["cs"] = {
			-- Basic information
			Name = "Česky", -- Native name for language
			Author = "MatesakCZ", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Hlasitost",
			Voteskips = "Hlasy o přeskočení",
			Loading = "Načítání...",
			Invalid = "[NEPLATNÝ]",
			NoVideoPlaying = "Nepřehrává se žádné video",
			Cancel = "Zrušit",
			Set = "Nastavit",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Současné video vyžádáno hráčem ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Neplatný video požadavek.",
			Theater_AlreadyQueued = "Požadované video je již ve frontě.",
			Theater_ProcessingRequest = Compile("Zpracovává se ", ColHighlight, "%s", ColDefault, " požadavek..."),
			Theater_RequestFailed = "Nastal problém při zpracování požadovaného videa.",
			Theater_Voteskipped = "Současné video bylo přeskočeno hlasováním.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " vynutil/a přeskočení současného videa."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " resetoval/a kino."),
			Theater_LostOwnership = "Ztratil/a jsi vlastnictví kina z důvodu jeho opuštění.",
			Theater_NotifyOwnership = "Jsi nyní majitelem tohoto soukromého kina.",
			Theater_OwnerLockedQueue = "Majitel kina uzamkl frontu videí.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " uzamkl/a frontu videí."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " odemkl/a frontu videí."),
			Theater_OwnerUseOnly = "Toto může použít pouze majitel kina.",
			Theater_PublicVideoLength = "Videa vyžádaná ve veřejných kinech jsou omezena na maximální délku %s sekund.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " hlasoval/a pro přeskočení ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " bylo přidáno do fronty."),

			-- Warnings
			Warning_Unsupported_Line1 = "Současná mapa není podporována herním módem Cinema.",
			Warning_Unsupported_Line2 = "Stiskněte F1 pro otevření oficiální mapy ve workshopu.",

			-- Queue
			Queue_Title = "FRONTA",
			Request_Video = "Vyžádat video",
			Vote_Skip = "Hlasovat o přeskočení",
			Toggle_Fullscreen = "Na celou obrazovku",
			Refresh_Theater = "Obnovit kino",

			-- Theater controls
			Theater_Admin = "ADMIN",
			Theater_Owner = "MAJITEL",
			Theater_Skip = "Přeskočit",
			Theater_Seek = "Přetočit",
			Theater_Reset = "Reset",
			Theater_ChangeName = "Změnit jméno",
			Theater_QueueLock = "Přepnout zámek fronty",
			Theater_SeekQuery = "HH:MM:SS nebo počet sekund (např. 1:30:00 nebo 5400)",

			-- Theater list
			TheaterList_NowShowing = "NYNÍ SE PROMÍTÁ",

			-- Request Panel
			Request_History = "HISTORIE",
			Request_Clear = "Vyčistit",
			Request_DeleteTooltip = "Odstranit video z historie",
			Request_PlayCount = "%d vyžádáno", -- e.g. 10 request(s)
			Request_Url = "Vyžádat video",
			Request_Url_Tooltip = "Stiskněte pro vyžádání platného videa.\nTlačítko zčervená když je URL platná",

			-- Scoreboard settings panel
			Settings_Title = "NASTAVENÍ",
			Settings_ClickActivate = "KLIKNĚTE PRO AKTIVACI KURZORU MYŠI",
			Settings_VolumeLabel = "Hlasitost",
			Settings_VolumeTooltip = "Stiskněte klávesy +/- pro zvýšení/snížení hlasitosti.",
			Settings_HidePlayersLabel = "Skrýt hráče v kinech",
			Settings_HidePlayersTooltip = "Redukuje viditelnost hráčů uvnitř kin.",
			Settings_MuteFocusLabel = "Ztišit zvuk při alt-tab",
			Settings_MuteFocusTooltip = "Ztiší zvuk v kině když je okno Garry's Mod neaktivní (např. při stisknutí alt-tab).",

			-- Video Services
			Service_EmbedDisabled = "Požadované video má zakázáno vkládání.",
			Service_PurchasableContent = "Požadované video je zakoupitelný obsah a nemůže být přehráno.",
			Service_StreamOffline = "Požadovaný stream je offline.",

			-- Credits
			TranslationsCredit = "Překlad: %s",
		},
		["nl"] = {
			-- Basic information
			Name = "Nederlands", -- Native name for language
			Author = "Ubister", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Volume",
			Voteskips = "Stemmen om over te slaan", --I could not make this any shorter and let it keep the correct meaning ~Ubi
			Loading = "Laden...",
			Invalid = "[ONGELDIG]",
			NoVideoPlaying = "Geen afspelende video",
			Cancel = "Annuleer",
			Set = "Stel",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Deze video is verzocht door ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Ongeldig videoverzoek.",
			Theater_AlreadyQueued = "De verzochte video is al in de rij.",
			Theater_ProcessingRequest = Compile("Verzoek ", ColHighlight, "%s", ColDefault, " verwerken..."),
			Theater_RequestFailed = "Er trad een probleem op bij het verwerken van de verzochte video.",
			Theater_Voteskipped = "Deze video is weggestemd.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " heeft deze video overgeslagen."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " heeft de bioscoop gereset."),
			Theater_LostOwnership = "Je hebt hebt het eigenaarschap over deze bioscoop verloren omdat je het hebt verlaten.",
			Theater_NotifyOwnership = "Je bent nu de eigenaar van deze privébioscoop.",
			Theater_OwnerLockedQueue = "De bioscoopeigenaar heeft de rij gesloten.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " heeft de rij gesloten."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " heeft de rij geopend"),
			Theater_OwnerUseOnly = "Alleen de bioscoopeigenaar kan dit doen.",
			Theater_PublicVideoLength = "Verzoeken in openbare bioscopen hebben een tijdslimiet van $s seconde(n)",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " heeft gestemd om ", ColHighlight, "(%s/%s)", ColDefault, "over te slaan."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " is aan de rij toegevoegd"),

			-- Warnings
			Warning_Unsupported_Line1 = "De huidige map wordt niet ondersteunt door de Cinema gamemode",
			Warning_Unsupported_Line2 = "Druk op F1 om de officiële map te openen in workshop",

			-- Queue
			Queue_Title = "RIJ",
			Request_Video = "Verzoek Video",
			Vote_Skip = "Wegstemmen",
			Toggle_Fullscreen = "Schakel Vol Scherm In",
			Refresh_Theater = "Bioscoop Verversen",

			-- Theater controls
			Theater_Admin = "ADMIN",
			Theater_Owner = "EIGENAAR",
			Theater_Skip = "Overslaan",
			Theater_Seek = "Zoek",
			Theater_Reset = "Reset",
			Theater_ChangeName = "Wijzig Naam",
			Theater_QueueLock = "Sluit Rij",
			Theater_SeekQuery = "HH:MM:SS of het aantal seconden (bv. 1:30:00 of 5400)",

			-- Theater list
			TheaterList_NowShowing = "NU OP",

			-- Request Panel
			Request_History = "GESCHIEDENIS",
			Request_Clear = "Wis",
			Request_DeleteTooltip = "Wis video uit geschiedenis",
			Request_PlayCount = "%d verzoek(en)", -- e.g. 10 request(s)
			Request_Url = "Verzoek URL",
			Request_Url_Tooltip = "Druk om een geldige video URL te verzoeken.\nDe knop is rood als de URL geldig is",

			-- Scoreboard settings panel
			Settings_Title = "INSTELLINGEN",
			Settings_ClickActivate = "KLIK OM JE MUIS TE ACTIVEREN",
			Settings_VolumeLabel = "Volume",
			Settings_VolumeTooltip = "Gebruik de +/- knoppen om je volume harder/zachter te zetten.",
			Settings_HidePlayersLabel = "Verberg Spelers In Bioscoop",
			Settings_HidePlayersTooltip = "Verminder spelerzichtbaarheid binnen bioscopen.",
			Settings_MuteFocusLabel = "Demp audio wanneer gealt-tabd", --Looks weird but it's correct Dutch grammar when considering ''alt tabbing'' as a verb ~Ubi
			Settings_MuteFocusTooltip = "Demp bioscoopvolume wanneer Garry's Mod niet geselecteerd is (bv. in alt-tab.)",

			-- Video Services
			Service_EmbedDisabled = "Bij de verzochte video zijn insluitingen uitgeschakeld",
			Service_PurchasableContent = "De verzochte video is koopbaar materiaal en kan niet afgesleepd worden.",
			Service_StreamOffline = "De verzochte stream is offline.",
		},
		["fi"] = {
			-- Basic information
			Name = "Suomi", -- Native name for language
			Author = "Jani", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Äänenvoimakkuus",
			Voteskips = "Äänestys ohittamiseen",
			Loading = "Lataa...",
			Invalid = "[VIRHEELLINEN]",
			NoVideoPlaying = "Ei videota käynnissä",
			Cancel = "Peruuta",
			Set = "Valitse",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Tämänhetkistä videota on ehdottanut ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Virheellinen videopyyntö.",
			Theater_AlreadyQueued = "Pyydetty video on jo jonossa.",
			Theater_ProcessingRequest = Compile("Käsitellään ", ColHighlight, "%s", ColDefault, " pyyntöä..."),
			Theater_RequestFailed = "Pyynnetyn videon käsittelyssä ilmeni ongelma.",
			Theater_Voteskipped = "Tämänhetkinen video on äänestetty ohitettavaksi.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " on pakottanut nykyisen videon ohitettavaksi."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " on käynnistänyt teatterin uudelleen."),
			Theater_LostOwnership = "Olet menettänyt teatterin omistajuuden lähtemisen vuoksi.",
			Theater_NotifyOwnership = "Olet nyt tämän yksityisen teatterin omistaja.",
			Theater_OwnerLockedQueue = "Teatterin omistaja on lukinnut videojonon.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " on lukinnut videojonon."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " on avannut teatterin videojonon."),
			Theater_OwnerUseOnly = "Vain teatterin omistaja voi käyttää tuota.",
			Theater_PublicVideoLength = "Julkisen teatterin videopyynnöt ovat rajoitettu %s sekunnin pituuteen.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " on äänestänyt ohittamista ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " on lisätty videojonoon."),

			-- Warnings
			Warning_Unsupported_Line1 = "Nykyinen kartta ei tue Cinema-pelimuotoa.",
			Warning_Unsupported_Line2 = "Paina F1 avataksesi virallisen kartan workshopissa.",

			-- Queue
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
			Request_PlayCount = "%d pyyntö(ä)", -- esim. 10 pyyntö(ä)
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
		},
		["fr"] = {
			-- Basic information
			Name = "Français", -- Native name for language
			Author = "Raphy, Kcejalppe", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Volume",
			Voteskips = "Votes de passage",
			Loading = "Chargement...",
			Invalid = "[INVALIDE]",
			NoVideoPlaying = "Pas de vidéo en lecture",
			Cancel = "Annuler",
			Set = "Régler",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Vidéo actuelle proposée par ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Requête vidéo invalide.",
			Theater_AlreadyQueued = "La vidéo proposée est déjà dans la liste d'attente.",
			Theater_ProcessingRequest = Compile("Traitement de ", ColHighlight, "%s", ColDefault, " en cours..."),
			Theater_RequestFailed = "Un problème est servenu lors du traitement de la vidéo proposée.",
			Theater_Voteskipped = "La vidéo actuelle a été passée.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " a passé de force la vidéo actuelle."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " a réinitialisé le théatre."),
			Theater_LostOwnership = "Vous avez perdu le statut de propriétaire du théatre car vous l'avez quitté.",
			Theater_NotifyOwnership = "Vous êtes maintenant le propriétaire de ce théatre privé.",
			Theater_OwnerLockedQueue = "Le propriétaire de ce théatre a verrouillé la liste d'attente.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " a verrouillé la liste d'attente."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " a déverrouillé la liste d'attente."),
			Theater_OwnerUseOnly = "Seul le propriétaire du théatre peut utiliser cela.",
			Theater_PublicVideoLength = "Les requêtes de théatres publics sont limitées à %s seconde(s).",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " a voté pour passer ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " a été ajoutée à la liste d'attente."),

			-- Warnings
			Warning_Unsupported_Line1 = "La carte actuelle n'est pas supportée par le mode de jeu Cinema",
			Warning_Unsupported_Line2 = "Appuyez sur F1 pour ouvrir la carte officielle dans le workshop",

			-- Queue
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
			Request_PlayCount = "%d requête(s)", -- e.g. 10 request(s)
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

			-- Credits
			TranslationsCredit = "Traductions par %s",
		},
		["de"] = {
			-- Basic information
			Name = "Deutsch", -- Native name for language
			Author = "Sapd", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Volume = "Lautstärke",
			Voteskips = "Abwählungen", -- Sounds weird, but no other short word/sentence.
			Loading = "Lade...",
			Invalid = "[UNGÜLTIG]",
			NoVideoPlaying = "Kein aktives Video",
			Cancel = "Abbrechen",
			Set = "Anwenden",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Aktuelles Video angefordert von ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Ungültiger Video Wunsch.",
			Theater_AlreadyQueued = "Das angeforderte Video ist bereits in der Warteschlange.",
			Theater_ProcessingRequest = Compile("Verarbeite ", ColHighlight, "%s", ColDefault, " Wunsch..."),
			Theater_RequestFailed = "Es gab ein Problem bei der Verarbeitung des angeforderten Videos.",
			Theater_Voteskipped = "Das aktuelle Video wurde abgewählt.", -- Using "abgewählt" as neologism
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " hat das Überspringen des Videos erzwungen."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " hat das Theater zurückgesetzt."),
			Theater_LostOwnership = "Da du das Theater verlassen hast, bist du nicht mehr der Besitzer.",
			Theater_NotifyOwnership = "Du bist nun der Besitzer des privaten Theaters.",
			Theater_OwnerLockedQueue = "Der Besitzer des Theaters hat die Warteschlange gesperrt.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " hat die Warteschlange des Theaters gesperrt."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " hat die Warteschlange des Theaters freigegeben."),
			Theater_OwnerUseOnly = "Nur der Besitzer des Theaters kann das benutzen.",
			Theater_PublicVideoLength = "Videowünsche in öffentlichen Theatern sind auf %s Sekunden begrenzt.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " hat dafür gestimmt, das Video zu überspringen ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " wurde zur Warteschlange hinzugefügt."),

			-- Warnings
			Warning_Unsupported_Line1 = "Die aktuelle Map wird nicht vom Cinema Gamemode unterstützt.",
			Warning_Unsupported_Line2 = "Drücke F1 um die offizielle Map im Workshop zu öffnen.",

			Dependency_Missing_Line1 = "Ups... du hast etwas übersehen!",
			Dependency_Missing_Line2 = "Drücke F4 um die Anleitungsvideo zu öffnen.",

			-- Queue
			-- In English the 2nd Words are also written with capital Letters.
			-- But here in German I need up to 3 words, it would look weird here
			Queue_Title = "WARTESCHLANGE",
			Request_Video = "Video anfordern",
			Vote_Skip = "Für Überspringen stimmen",
			Toggle_Fullscreen = "Vollbildmodus umschalten",
			Refresh_Theater = "Theater neu laden",

			-- Theater controls
			Theater_Admin = "ADMIN",
			Theater_Owner = "BESITZER",
			Theater_Skip = "Überspringen",
			Theater_Seek = "Starten bei...", -- There is no direct translation for "seek" so I use "start at ...", just like youtube
			Theater_Reset = "Zurücksetzen",
			Theater_ChangeName = "Name ändern",
			Theater_QueueLock = "Warteliste ein/aus", -- Warteschlange also sounds better here, but doesn't fit
			Theater_SeekQuery = "HH:MM:SS oder Zeit in Sekunden (z.B. 1:30:00 oder 5400)", -- h also stands in german for hours

			-- Theater list
			TheaterList_NowShowing = "AKTUELLE VORFÜHRUNGEN",

			-- Request Panel
			Request_History = "VERLAUF",
			Request_Clear = "Verlauf löschen",
			Request_DeleteTooltip = "Video vom Verlauf entfernen",
			Request_PlayCount = "Bereits %d Mal Angefordert", -- e.g. 10 request(s)
			Request_Url = "URL Anfordern",
			Request_Url_Tooltip = "Drücken um einen gültigen Video Link anzufordern.\nDer Button wird rot sobald der Link gültig ist.",

			-- Scoreboard settings panel
			Settings_Title = "EINSTELLUNGEN",
			Settings_ClickActivate = "KLICKEN UM MAUS ZU AKTIVIEREN",
			Settings_VolumeLabel = "Lautstärke", -- Can't use umlaut Ä here, because the gamemode somehow try's to convert the word to uppercase (even if it is already written so). And so the small letter ä would stand there, instead of Ä.
			Settings_VolumeTooltip = "Benutze die +/- Tasten um die Lautstärke zu erhöhen/senken.",
			Settings_HidePlayersLabel = "Spieler im Theater ausblenden",
			Settings_HidePlayersTooltip = "Reduziert die Sichtbarkeit der Spieler innerhalb der Theater.",
			Settings_MuteFocusLabel = "Im Hintergrund stummschalten",
			Settings_MuteFocusTooltip = "Theater Audio stummschalten während Garrysmod minimiert ist.",
			Settings_SmoothVideoLabel = "Flüssige Videowiedergabe",
			Settings_SmoothVideoTooltip = "Mach einige Videos flüssiger auf Kosten der FPS.",

			-- Video Services
			Service_EmbedDisabled = "Das angeforderte Video hat die Einbettung deaktiviert.",
			Service_PurchasableContent = "Das angeforderte Video ist kaufbar und kann somit nicht abgespielt werden.",
			Service_StreamOffline = "Der angeforderte Stream ist offline.",
		},
		["hu"] = {
			-- Basic information
			Name = "Hungarian", -- Native name for language
			Author = "David Tamas", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "MOZI",
			Volume = "Hangerő",
			Voteskips = "Leszavazások",
			Loading = "Betöltés...",
			Invalid = "[ÉRVÉNYTELEN]",
			NoVideoPlaying = "Nincs videó lejátszás alatt",
			Cancel = "Mégse",
			Set = "Beállít",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("A jelenlegi videót kérte: ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Érvénytelen videókérés.",
			Theater_AlreadyQueued = "A kért videó már a sorban van.",
			Theater_ProcessingRequest = Compile(ColHighlight, "%s", ColDefault, "kérésének feldolgozása..."),
			Theater_RequestFailed = "Hiba törén a kért videó feldolgozása közben.",
			Theater_Voteskipped = "A jelenlegi videót leszavazták.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " kényszerítette a következő videó lejátszását."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " a mozitermet alaphelyzetbe állította."),
			Theater_LostOwnership = "Elvesztetted a terem feletti tulajdonjogot, mert kiléptél belőle.",
			Theater_NotifyOwnership = "Te vagy a tulajdonosa a privát teremnek.",
			Theater_OwnerLockedQueue = "A terem tulajdonosa lezárta a sort.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " lezárta a terem várakozósorát."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " feloldotta a terem várakozósorát."),
			Theater_OwnerUseOnly = "Csak a teremtulajdonos képes ezt megcsinálni.",
			Theater_PublicVideoLength = "A nyilvános termek kérései korlátozva vannak %s másodperc hosszúságra.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " szavazott, hogy továbblépjen a következő videóra.", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " hozzáadva a sorhoz."),

			-- Warnings
			Warning_Unsupported_Line1 = "A jelenlegi térképet nem támogatja a Mozi játékmód.",
			Warning_Unsupported_Line2 = "Nyomd meg az F1 gombot és megnyílik a Műhely a hivatalos pályával.",

			-- Queue
			Queue_Title = "LEJÁTSZÁSI SOR",
			Request_Video = "Videó kérése",
			Vote_Skip = "Szavazás továbblépésről",
			Toggle_Fullscreen = "Váltás teljes képernyőre",
			Refresh_Theater = "Terem alaphelyzetbe",

			-- Theater controls
			Theater_Admin = "ADMINISZTRÁTOR",
			Theater_Owner = "TULAJDONOS",
			Theater_Skip = "Átugrás",
			Theater_Seek = "Beletekerés",
			Theater_Reset = "Alaphelyzet",
			Theater_ChangeName = "Név megváltoztatása",
			Theater_QueueLock = "Várakozási sor zárása be/ki",
			Theater_SeekQuery = "ÓÓ:PP:MM vagy a másodpercek száma (1:30:00 vagy 5400)",

			-- Theater list
			TheaterList_NowShowing = "JELENLEG FUT",

			-- Request Panel
			Request_History = "ELŐZMÉNYEK",
			Request_Clear = "Kitakarítás",
			Request_DeleteTooltip = "Videó törlése az előzményekből",
			Request_PlayCount = "%d kérés", -- e.g. 10 request(s)
			Request_Url = "Eme URL kérése",
			Request_Url_Tooltip = "Nyomd meg, hogy kérj egy érvényes videót.\nA gomb csak akkor lesz piros, ha az URL érvényes.",

			-- Scoreboard settings panel
			Settings_Title = "BEÁLLÍTÁSOK",
			Settings_ClickActivate = "KATTINTS AZ EGÉR AKTIVÁLÁSÁHOZ",
			Settings_VolumeLabel = "Hangerő",
			Settings_VolumeTooltip = "Használd a +/- gombokat a hangerő növeléséhez/csökkentéséhez..",
			Settings_HidePlayersLabel = "Lejátszó elrejtése a moziban",
			Settings_HidePlayersTooltip = "A lejátszó láthatósága csökkentve van.",
			Settings_MuteFocusLabel = "Alt-Tab esetén némítás",
			Settings_MuteFocusTooltip = "A mozi hangja némítva lesz, ha a Garry's Mod ablaka nem aktív (pl. Alt-Tab esetén).",

			-- Video Services
			Service_EmbedDisabled = "A kért videó beágyazása nem megengedett.",
			Service_PurchasableContent = "A kért videó egy megvásárolandó elem és nem lejátszható.",
			Service_StreamOffline = "A kért stream jelenleg offline.",

			-- Credits
			TranslationsCredit = "A fordítást készítette: %s",
		},
		["it"] = {
			-- Basic information
			Name = "Italiano", -- Native name for language
			Author = "Wolfaloo", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Volume",
			Voteskips = "Vota per saltare",
			Loading = "Caricamento...",
			Invalid = "[NON VALIDO]",
			NoVideoPlaying = "Nessun video in riproduzione",
			Cancel = "Cancella",
			Set = "Setta",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Video attuale richiesto da ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Richiesta non valida.",
			Theater_AlreadyQueued = "Il video richiesto è gia in coda.",
			Theater_ProcessingRequest = Compile("Richiedendo il video a ", ColHighlight, "%s", ColDefault, " ..."),
			Theater_RequestFailed = "Si è verificato un problema nella richiesta del video.",
			Theater_Voteskipped = "Il seguente video è stato saltato a causa di un voto.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " ha forzato il salto del video."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " ha resettato il teatro."),
			Theater_LostOwnership = "Hai perso la proprietà del teatro perchè lo hai abbandonato.",
			Theater_NotifyOwnership = "Sei il padrone di questo teatro.",
			Theater_OwnerLockedQueue = "Il proprietario del teatro ha bloccato la coda di riproduzione.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " ha bloccato la coda di riproduzione."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " ha sbloccato la coda di riproduzione."),
			Theater_OwnerUseOnly = "Solo il proprietario del teatro può usare questa funzione.",
			Theater_PublicVideoLength = "Le richieste in un teatro publico sono limitate ad una durata di %s second(s) secondi.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " ha votato per saltare ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " è stato aggiunto alla coda."),

			-- Warnings
			Warning_Unsupported_Line1 = "La mappa attuale non è supportata da cinema gamemode",
			Warning_Unsupported_Line2 = "Premi F1 per aprire la mappa ufficiale nel Workshop Steam",

			-- Queue
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
			Request_PlayCount = "%d request(s)", -- es. 10 richieste
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

			-- Credits
			TranslationsCredit = "Traduzioni di %s",
		},
		["ja"] = {
			-- Basic information
			Name = "日本語", -- Native name for language
			Author = "f122apg", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "音量",
			Voteskips = "スキップの投票数", -- I'm not sure what voteskips means, this says number of votes to skip
			Loading = "読み込み中...",
			Invalid = "【無効】",
			NoVideoPlaying = "再生中の動画はありません。",
			Cancel = "キャンセル",
			Set = "セット",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("", ColHighlight, "%s", ColDefault, "は動画をリクエストしました。"),
			Theater_InvalidRequest = "無効なリクエスト",
			Theater_AlreadyQueued = "この動画は既にキューに存在しています。",
			Theater_ProcessingRequest = Compile("", ColHighlight, "%s", ColDefault, "はリクエスト処理中です。"),
			Theater_RequestFailed = "リクエスト処理が失敗しました。",
			Theater_Voteskipped = "この動画は投票により、スキップされました。",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, "は動画を強制的にスキップしました。"),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, "はtheaterをリセットしました。"),
			Theater_LostOwnership = "あなたはPrivate theaterを抜けた為、オーナー権限が失われました。",
			Theater_NotifyOwnership = "あなたはPrivate theaterのオーナーになりました。",
			Theater_OwnerLockedQueue = "オーナーがキューにロックをかけました。",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " はキューにロックをかけました。"),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " はキューのロックを解除しました。"),
			Theater_OwnerUseOnly = "オーナーだけが使用できます。",
			Theater_PublicVideoLength = "Public theaterは%s秒に1度リクエストできます。",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, "は", ColHighlight, "(%s/%s)", ColDefault, "をスキップ投票しました。"),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, "はキューを追加しました。"),

			-- Warnings
			Warning_Unsupported_Line1 = "このマップはCinema gamemodeに対応していません。",
			Warning_Unsupported_Line2 = "F1を押すとワークショップにある公式のマップを開きます。",

			-- Queue
			Queue_Title = "キュー",
			Request_Video = "動画をリクエストする",
			Vote_Skip = "スキップに投票する",
			Toggle_Fullscreen = "フルスクリーンに変更する",
			Refresh_Theater = "theaterを更新する",

			-- Theater controls
			Theater_Admin = "管理者",
			Theater_Owner = "オーナー",
			Theater_Skip = "スキップ",
			Theater_Seek = "シーク",
			Theater_Reset = "リセット",
			Theater_ChangeName = "名前を変更",
			Theater_QueueLock = "キューをロック",
			Theater_SeekQuery = "HH:MM:SSまたは秒数【例 1:30:00または5400】",

			-- Theater list
			TheaterList_NowShowing = "上映中",

			-- Request Panel
			Request_History = "履歴",
			Request_Clear = "クリア",
			Request_DeleteTooltip = "履歴から削除する",
			Request_PlayCount = "リクエスト回数：%d", -- e.g. 10 request(s),
			Request_Url = "リクエストURL",
			Request_Url_Tooltip = "URLが有効な時にリクエストを押します。\nこのボタンが赤い時はリクエスト可能な動画です。",

			-- Scoreboard settings panel
			Settings_Title = "設定",
			Settings_ClickActivate = "マウスをアクティブにするにはクリックします。",
			Settings_VolumeLabel = "音量",
			Settings_VolumeTooltip = "+/-キーで音量の上げ/下げが可能です。",
			Settings_HidePlayersLabel = "プレイヤーを非表示",
			Settings_HidePlayersTooltip = "theater内にいるプレイヤーを非表示にします。",
			Settings_MuteFocusLabel = "ウィンドウ切り替え時、ミュートにする",
			Settings_MuteFocusTooltip = "Garry's Modから別ウィンドウに切り替えた時にミュートします。(Alt+Tabを押した時など)",

			-- Video Services
			Service_EmbedDisabled = "リクエストされた動画は埋め込みを無効にしています。",
			Service_PurchasableContent = "リクエストされた動画は有料の動画なので再生できません。",
			Service_StreamOffline = "リクエストされたストリームはオフラインです。",

			-- Credits
			TranslationsCredit = "翻訳者：%s",
		},
		["ko"] = {
			-- Basic information
			Name = "한국어", -- Native name for language
			Author = "ChiNo", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "시네마",
			Volume = "음량",
			Voteskips = "투표 건너뛰기",
			Loading = "불러오는 중...",
			Invalid = "[인식 불가능]",
			NoVideoPlaying = "재생 중인 비디오 없음",
			Cancel = "취소",
			Set = "확인",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("현재 비디오를 신청한 플레이어는 ", ColHighlight, "%s", ColDefault, " 입니다."),
			Theater_InvalidRequest = "인식 불가능한 비디오 정보.",
			Theater_AlreadyQueued = "선택하신 비디오는 이미 대기 열에 있습니다.",
			Theater_ProcessingRequest = Compile("스트리밍 서비스 ", ColHighlight, "%s", ColDefault, "를 불러오는 중..."),
			Theater_RequestFailed = "선택하신 비디오를 불러오는 중 문제가 생겼습니다.",
			Theater_Voteskipped = "현재 재생 중이었던 비디오는 투표로 인해 건너뛰어졌습니다.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " 님이 강제로 건너뛰기 하였습니다."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " 님이 극장을 초기화하였습니다."),
			Theater_LostOwnership = "극장을 떠나서 가지고 있던 주인 권한을 잃으셨습니다.",
			Theater_NotifyOwnership = "당신은 이 개인 극장의 주인 권한을 얻으셨습니다.",
			Theater_OwnerLockedQueue = "극장의 주인이 대기 열을 잠갔습니다.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " 님이 대기 열을 잠갔습니다."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " 님이 대기 열을 잠금 해제하였습니다."),
			Theater_OwnerUseOnly = "오로지 주인만이 이것을 사용할 수 있습니다.",
			Theater_PublicVideoLength = "공용 극장은 %s 초의 길이 제한이 있습니다.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " 님이 건너뛰기 투표를 하였습니다. ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " 비디오가 대기열에 추가되었습니다."),

			-- Warnings
			Warning_Unsupported_Line1 = "선택하신 맵은 시네마 게임 모드에 호환되지 않습니다.",
			Warning_Unsupported_Line2 = "F1을 눌러 시네마 공식 맵을 창작 마당에서 확인하세요.",

			-- Queue
			Queue_Title = "대기 열",
			Request_Video = "비디오 신청",
			Vote_Skip = "투표 건너뛰기",
			Toggle_Fullscreen = "항상 전체 화면",
			Refresh_Theater = "극장 새로 고침",

			-- Theater controls
			Theater_Admin = "관리자",
			Theater_Owner = "서버 주인",
			Theater_Skip = "건너뛰기",
			Theater_Seek = "시간 건너뛰기",
			Theater_Reset = "초기화",
			Theater_ChangeName = "이름 바꾸기",
			Theater_QueueLock = "항상 대기 열 잠구기",
			Theater_SeekQuery = "HH:MM:SS 의 양식으로 숫자를 입력하십시오. (예. 1:30:00 또는 5400)",

			-- Theater list
			TheaterList_NowShowing = "지금 재생 중",

			-- Request Panel
			Request_History = "최근 기록",
			Request_Clear = "초기화",
			Request_DeleteTooltip = "비디오를 최근 기록에서 삭제합니다.",
			Request_PlayCount = "%d 개 신청됨", -- e.g. 10 request(s)
			Request_Url = "URL 요청",
			Request_Url_Tooltip = "올바른 URL을 요청하십시오.\n버튼 색깔이 빨간색일때 올바른 URL입니다.",

			-- Scoreboard settings panel
			Settings_Title = "설정",
			Settings_ClickActivate = "마우스를 클릭하여 활성화합니다.",
			Settings_VolumeLabel = "음량",
			Settings_VolumeTooltip = "+/- 키를 사용해 음량을 올리거나 내리세요.",
			Settings_HidePlayersLabel = "극장에서 다른 플레이어 숨김",
			Settings_HidePlayersTooltip = "다른 플레이어들을 숨겨서 안 보이게 합니다.",
			Settings_MuteFocusLabel = "ALT + TAB 음소거",
			Settings_MuteFocusTooltip = "ALT + TAB을 사용해 다른 시점으로 갔을때 음소거 합니다.",

			-- Video Services
			Service_EmbedDisabled = "신청하신 비디오는 해제되있습니다",
			Service_PurchasableContent = "신청된 비디오는 매수할 수 있는 콘텐츠와 연주가 될 수 없습니다.",
			Service_StreamOffline = "스트리밍 서비스가 오프라인입니다.",

			-- Credits
			TranslationsCredit = "번역 %s",
		},
		["no"] = {
			-- Basic information
			Name = "Norwegian", -- Native name for language
			Author = "DoleDuck", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "KINO",
			Volume = "Volum",
			Voteskips = "Har stemt for å hoppe over",
			Loading = "Lader...",
			Invalid = "[UGYLDIG]",
			NoVideoPlaying = "Ingen Video Spiller",
			Cancel = "Avbryt",
			Set = "Sett",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Denne video er forespurt av ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Ugyldig video forespørsel.",
			Theater_AlreadyQueued = "Den forespurte videoen er allerede i køen.",
			Theater_ProcessingRequest = Compile("Behandler ", ColHighlight, "%s", ColDefault, " forespørsel..."),
			Theater_RequestFailed = "Det var et problem med å behandle den forespurte videoen.",
			Theater_Voteskipped = "Den gjeldende videoen har blitt stemt bort.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " har hoppet over denne videoen."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " har tilbakestillt kinoen."),
			Theater_LostOwnership = "Du har mistet eierskapet fordi du har forlatt kinoen.",
			Theater_NotifyOwnership = "Du er nå eieren av denne kinoen.",
			Theater_OwnerLockedQueue = "Eieren av kinoen har stengt køen.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " har stengt køen."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " har åpnet køen."),
			Theater_OwnerUseOnly = "Bare eieren av kinoen kan gjøre det.",
			Theater_PublicVideoLength = "Forespørsler i offentlige kinoer har en frist på %s sekund(er).",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " har stemt for å hoppe over ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " har blitt lagt til i køen."),

			-- Warnings
			Warning_Unsupported_Line1 = "Den gjeldene banen er ikke støtter av Cinema gamemode",
			Warning_Unsupported_Line2 = "Trykk F1 for å åpne den offisielle banen i workshop",

			-- Queue
			Queue_Title = "KØ",
			Request_Video = "Spør om en video",
			Vote_Skip = "Stem for å hoppe over",
			Toggle_Fullscreen = "Veksle mellom fullskjerm",
			Refresh_Theater = "Oppdater Kino",

			-- Theater controls
			Theater_Admin = "ADMIN",
			Theater_Owner = "EIER",
			Theater_Skip = "Hopp over",
			Theater_Seek = "Søk",
			Theater_Reset = "Tilbakestill",
			Theater_ChangeName = "Bytt navn",
			Theater_QueueLock = "Lås/åpne køen",
			Theater_SeekQuery = "HH:MM:SS eller antall sekunder (f.eks. 1:30:00 eller 5400)",

			-- Theater list
			TheaterList_NowShowing = "VISER NÅ",

			-- Request Panel
			Request_History = "HISTORIE",
			Request_Clear = "Slett",
			Request_DeleteTooltip = "Fjern video fra histore",
			Request_PlayCount = "%d forespørsel(er)", -- e.g. 10 request(s)
			Request_Url = "Be om en URL",
			Request_Url_Tooltip = "Klikk for å be om en gyldig video URL.\nKnappen vil bli rød når URL'en er ugyldig",

			-- Scoreboard settings panel
			Settings_Title = "INNSTILLINGER",
			Settings_ClickActivate = "KLIKK FOR Å AKTIVERE MUSEN",
			Settings_VolumeLabel = "Volum",
			Settings_VolumeTooltip = "Bruk +/- tastene for å øke/redusere volumet.",
			Settings_HidePlayersLabel = "Skjul Spillere I Kino",
			Settings_HidePlayersTooltip = "Reduser spiller synlighet inne i kinoene.",
			Settings_MuteFocusLabel = "Skru av lyd mens du er alt-tabbet",
			Settings_MuteFocusTooltip = "Skru av kino lyden mens Garry's Mod er ute av fokus (f.eks. i alt-tab).",

			-- Video Services
			Service_EmbedDisabled = "Innholdet til den følgende videoen er slått av.",
			Service_PurchasableContent = "Den forespurte videoen er kjøpt innhold og kan ikke bli spilt av.",
			Service_StreamOffline = "Den forespurte stream er offline.",

			-- Credits
			TranslationsCredit = "Oversettelse av %s",
		},
		["en-PT"] = {
			-- Basic information
			Name = "Pirate Speak", -- Native name for language
			Author = "HawkBlock", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Loudness",
			Voteskips = "Mutinies",
			Loading = "Sailing...",
			Invalid = "[INVALID]",
			NoVideoPlaying = "No ships sailing",
			Cancel = "Abandon ship",
			Set = "Set",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Commander of this ship be ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Invalid ship request.",
			Theater_AlreadyQueued = "The requested ship already be in harbour.",
			Theater_ProcessingRequest = Compile("Processing ", ColHighlight, "%s", ColDefault, " request..."),
			Theater_RequestFailed = "The requested ship sank.",
			Theater_Voteskipped = "The ship's been taken over by rebellious crew!",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " sank the vessel."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " swabbed the poopdeck!"),
			Theater_LostOwnership = "Ye've lost command of the harbour!",
			Theater_NotifyOwnership = "Yer the captain now!",
			Theater_OwnerLockedQueue = "The captain closed the harbour.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " closed the harbour."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " opened the harbour."),
			Theater_OwnerUseOnly = "Only the captain can do that.",
			Theater_PublicVideoLength = "New ship requests may only be %s second(s) in length.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " sunk the ", ColHighlight, "(%s/%s)", ColDefault, "!"),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " sailed into harbour."),

			-- Warnings
			Warning_Unsupported_Line1 = "The current map be unsupported by the Cinema gamemode",
			Warning_Unsupported_Line2 = "Press F1 to open the official map on workshop",

			-- Queue
			Queue_Title = "Harbour (Queue)",
			Request_Video = "Add Ship (Request Video)",
			Vote_Skip = "Join Mutiny (Voteskip)",
			Toggle_Fullscreen = "Toggle Fullscreen",
			Refresh_Theater = "Swab the Poopdeck (Reset Theater)",

			-- Theater controls
			Theater_Admin = "HARBOURMASTER",
			Theater_Owner = "CAPTAIN",
			Theater_Skip = "Sink",
			Theater_Seek = "Seek",
			Theater_Reset = "Swab the Poopdeck (Reset)",
			Theater_ChangeName = "Rename Vessel",
			Theater_QueueLock = "Close the Harbour",
			Theater_SeekQuery = "HH:MM:SS or number of seconds (e.g. 1:30:00 or 5400)",

			-- Theater list
			TheaterList_NowShowing = "NOW SAILING",

			-- Request Panel
			Request_History = "Ledger",
			Request_Clear = "Erase",
			Request_DeleteTooltip = "Remove ship from Ledger",
			Request_PlayCount = "%d voyage(s)", -- e.g. 10 request(s)
			Request_Url = "Request Ship",
			Request_Url_Tooltip = "Press to request a valid video URL.\nThe button'll be red when the URL be valid",

			-- Scoreboard settings panel
			Settings_Title = "SETTINGS",
			Settings_ClickActivate = "CLICK TO COMMAND YER MOUSE",
			Settings_VolumeLabel = "Loudness",
			Settings_VolumeTooltip = "Use the +/- keys to increase/decrease volume.",
			Settings_HidePlayersLabel = "Send crew to thar quarters.",
			Settings_HidePlayersTooltip = "Reduce player visibility inside of theaters.",
			Settings_MuteFocusLabel = "Silence noises while in quarters",
			Settings_MuteFocusTooltip = "Mute theater volume while Garry's Mod be out-of-focus (e.g. you alt-tabbed).",

			-- Video Services
			Service_EmbedDisabled = "The requested ship be unfit for the open sea.",
			Service_PurchasableContent = "The requested ship be too expensive to sail.",
			Service_StreamOffline = "The requested ship be a ghost.",

			-- Credits
			TranslationsCredit = "Translations by %s",
		},
		["pl"] = {
			-- Podstawowe informacje
			Name = "Polski", -- Native name for language
			Author = "Halamix2", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Ogólne
			Cinema = "KINO",
			Volume = "Głośność",
			Voteskips = "Voteskips", --I don't know how to translate it in short, "Żądania pominięcia" is too long, plus I haven't seen this in-game
			Loading = "Ładowanie...",
			Invalid = "[NIEPRAWIDŁOWE]",
			NoVideoPlaying = "Brak odtwarzanego filmu",
			Cancel = "Anuluj",
			Set = "Ustaw",

			-- Ogłoszenia sal kinowych
			Theater_VideoRequestedBy = Compile("Obecny film został zażądany przez ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Nieprawidłowe żądanie filmu.",
			Theater_AlreadyQueued = "Żądany film jest już w kolejce.",
			Theater_ProcessingRequest = Compile("Przetwarzanie żądania ", ColHighlight, "%s", ColDefault, "..."),
			Theater_RequestFailed = "Wystąpił problem podczas przetwarzania żądanego filmu.",
			Theater_Voteskipped = "Zostało przegłosowane pominięcie obecnego filmu.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " wymusił pominięcie obecnego filmu."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " zresetował salę kinową."),
			Theater_LostOwnership = "Straciłeś posiadanie sali kinowej z powodu opuszczenia jej.",
			Theater_NotifyOwnership = "Jesteś teraz właścicielem prywatnej sali kinowej.",
			Theater_OwnerLockedQueue = "Właściciel sali kinowej zablokował kolejkę.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " zablokował kolejkę sali kinowej."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " odblokował kolejkę sali kinowej."),
			Theater_OwnerUseOnly = "Tylko właściciel sali kinowej może tego używać.",
			Theater_PublicVideoLength = "Żądania w publicznych salach kinowych są ograniczone do długości %s sekund.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " zagłosował na pominięcie ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " zostało dodane do kolejki."),

			-- Ostrzeżenia
			Warning_Unsupported_Line1 = "Obecna mapa jest niewspierana przez tryb gry Cinema",
			Warning_Unsupported_Line2 = "Naciśnij F1 aby otworzyć oficjalną mapę w workshopie",

			-- Kolejka
			Queue_Title = "KOLEJKA",
			Request_Video = "Zażądaj wideo",
			Vote_Skip = "Głosuj pominięcie",
			Toggle_Fullscreen = "Przełącz pełny ekran",
			Refresh_Theater = "Odśwież ekran kinowy",

			-- Sterowanie salą kinową
			Theater_Admin = "ADMINISTRATOR",
			Theater_Owner = "WŁAŚCICIEL",
			Theater_Skip = "Pomiń",
			Theater_Seek = "Szukaj",
			Theater_Reset = "Resetuj",
			Theater_ChangeName = "Zmień nazwę",
			Theater_QueueLock = "Przełącz blokadę kolejki",
			Theater_SeekQuery = "HH:MM:SS lub liczba w sekundach (np. 1:30:00 lub 5400)",

			-- Lista sal kinowych
			TheaterList_NowShowing = "OBECNIE GRAMY",

			-- Panel żądań
			Request_History = "HISTORIA",
			Request_Clear = "Wyczyść",
			Request_DeleteTooltip = "Usuwa filmy z historii",
			Request_PlayCount = "%d żądań", -- np. 10 żądań
			Request_Url = "Zażądaj URL",
			Request_Url_Tooltip = "Naciśnij aby zażądać prawidłowego URL wideo.\nPrzycisk będzie czerwony gdy link jest prawidłowy",

			-- Panel ustawień tablicy wyników
			Settings_Title = "USTAWIENIA",
			Settings_ClickActivate = "KLIKNIJ ABY AKTYWOWAĆ MYSZ",
			Settings_VolumeLabel = "Głośność",
			Settings_VolumeTooltip = "Użyj klawiszy +/- aby zwiększyć/zmniejszyć głośność.",
			Settings_HidePlayersLabel = "Ukryj graczy w sali kinowej",
			Settings_HidePlayersTooltip = "Zmniejsza widoczność graczy w środku sal kinowych.",
			Settings_MuteFocusLabel = "Wycisz audio podczas alt-tabowania",
			Settings_MuteFocusTooltip = "Wycisza salę kinową podczas gdy Garry's Mod jest nieaktywne (np. alt-tabowałeś).",

			-- Serwisy wideo
			Service_EmbedDisabled = "Żądany film ma wyłączone osadzanie.",
			Service_PurchasableContent = "Żądany film jest zawartością do kupienia i nie może zostać odtworzony.",
			Service_StreamOffline = "Żądany stream jest offline.",

			-- Credits
			TranslationsCredit = "Tłumaczenie przez %s",
		},
		["ru"] = {
			-- Basic information
			Name = "Russian", -- Native name for language
			Author = "Joker[Rus], berry, Alivebyte!", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Громкость",
			Voteskips = "Пропуск",
			Loading = "Загрузка...",
			Invalid = "[НЕПРАВИЛЬНО]",
			NoVideoPlaying = "Нет видео",
			Cancel = "Отмена",
			Set = "Установить",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Текущее видео поставил ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Неправильный запрос видео.",
			Theater_AlreadyQueued = "Выбранное видео уже есть в очереди.",
			Theater_ProcessingRequest = Compile("Обработка ", ColHighlight, "%s", ColDefault, " запроса..."),
			Theater_RequestFailed = "Возникла проблема во время обработки выбранного видео.",
			Theater_Voteskipped = "Это видео было пропущено из-за голосования.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " выключил текущее видео."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " перезагрузил театр."),
			Theater_LostOwnership = "Вы потеряли владения над театром, из-за выхода из театра.",
			Theater_NotifyOwnership = "Вы стали владельцем этого приватного театра.",
			Theater_OwnerLockedQueue = "Владелец театра отключил возможность вставку видео в очередь.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " закрыл возможность вставки видео."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " открыл возможность вставки видео."),
			Theater_OwnerUseOnly = "Только владелец театра может использовать это.",
			Theater_PublicVideoLength = "Максимальный лимит видео в публичном театре %s сек. в длину.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " проголосовал за пропуск ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " было добавлено в очередь."),

			-- Warnings
			Warning_Unsupported_Line1 = "Текущая карта не поддерживается игровым режимом Cinema",
			Warning_Unsupported_Line2 = "Нажмите F1, чтобы найти официальные карты в мастерской",
			-- Queue

			Queue_Title = "ОЧЕРЕДЬ",
			Request_Video = "Поставить видео",
			Vote_Skip = "Голосовать за пропуск",
			Toggle_Fullscreen = "Полноэкранный режим",
			Refresh_Theater = "Перезагрузить театр",

			-- Theater controls
			Theater_Admin = "АДМИН",
			Theater_Owner = "ВЛАДЕЛЕЦ",
			Theater_Skip = "Убрать видео",
			Theater_Seek = "Перемотать",
			Theater_Reset = "Перезагрузить",
			Theater_ChangeName = "Сменить имя",
			Theater_QueueLock = "Закрыть вставку видео",
			Theater_SeekQuery = "ЧЧ:ММ:СС или число в секундах (пример. 1:30:00 или 5400)",

			-- Theater list
			TheaterList_NowShowing = "Сейчас показывают",

			-- Request Panel
			Request_History = "ИСТОРИЯ",
			Request_Clear = "Очистить",
			Request_DeleteTooltip = "Удалить видео из истории",
			Request_PlayCount = "%d просмотра(ов)", -- e.g. 10 request(s)
			Request_Url = "Выбрать видео",
			Request_Url_Tooltip = "Нажмите сюда, чтобы добавить видео в очередь.\nКнопка будет красная, если ссылка не правильная.",

			-- Scoreboard settings panel
			Settings_Title = "НАСТРОЙКИ",
			Settings_ClickActivate = "НАЖМИТЕ, ЧТОБЫ АКТИВИРОВАТЬ МЫШКУ",
			Settings_VolumeLabel = "Громкость",
			Settings_VolumeTooltip = "Используйте +/-, чтобы увеличить/уменьшить громкость.",
			Settings_HidePlayersLabel = "Прятать игроков в театре",
			Settings_HidePlayersTooltip = "В театрах игроки станут невидимые для вас.",
			Settings_MuteFocusLabel = "Глушить звук в не игры",
			Settings_MuteFocusTooltip = "Отключение звука театра, когда вы вне игры (например: игра свернута).",
			Settings_SmoothVideoLabel = "Cглаживать воспроизведение видео",
			Settings_SmoothVideoTooltip = "Сглаживать воспроизведение видео, влияет на производительность.",

			-- Video Services
			Service_EmbedDisabled = "Запрещено вставлять выбранное видео.",
			Service_PurchasableContent = "Данное видео имеет запрещённый контент, и не может быть вставлено в очередь.",
			Service_StreamOffline = "Запрашиваемый стрим не в сети.",

			-- Credits
			TranslationsCredit = "Перевод запилили: %s",
		},
		["es-ES"] = {
			-- Basic information
			Name = "Español", -- Native name for language
			Author = "Robert Lind (ptown2)", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Volume = "Volumen",
			Voteskips = "Omitido por votos",
			Loading = "Cargando...",
			Invalid = "[INVALIDO]",
			NoVideoPlaying = "No hay videos en seguimiento",
			Cancel = "Cancelar",
			Set = "Establecer",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Video actual solicitado por ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Solicitud del video esta invalido.",
			Theater_AlreadyQueued = "El video solicitado está ya en la lista.",
			Theater_ProcessingRequest = Compile("Procesando ", ColHighlight, "%s", ColDefault, " solicitud..."),
			Theater_RequestFailed = "Hubo un problema al procesar el video solicitado.",
			Theater_Voteskipped = "El video actual fue omitido por voto.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " ha obligado a omitir el video actual."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " ha reiniciado el teatro."),
			Theater_LostOwnership = "Usted ha perdido la propiedad y poder por salir de su teatro privado.",
			Theater_NotifyOwnership = "Usted es ahora el propietario de este teatro privado.",
			Theater_OwnerLockedQueue = "El dueño de este teatro ha cerrado la lista.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " ha cerrado la lista del teatro."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " ha abierto la lista del teatro."),
			Theater_OwnerUseOnly = "Solamente el propietario de este teatro puede usar eso.",
			Theater_PublicVideoLength = "Las solicitudes en teatros públicos son limitados a %s segundo(s) largo de video.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " ha votado para omitir ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " fue añadido a la lista."),

			-- Warnings
			Warning_Unsupported_Line1 = "Este mapa no está respaldado por el modo de juego Cinema.",
			Warning_Unsupported_Line2 = "Pulse el botón F1 para ver los mapas oficiales en el Steam Workshop.",

			-- Queue
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
			Request_PlayCount = "%d solicitud(es)", -- e.g. 10 request(s)
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
		},
		["tr"] = {
			Name = "Turkish", -- Native name for language
			Author = "Arda Turkmen", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Ses",
			Voteskips = "Gecmek icin oyla",
			Loading = "Yukleniyor...",
			Invalid = "[Bilinmiyor]",
			NoVideoPlaying = "Herhangi bir video oynamiyor",
			Cancel = "Iptal",
			Set = "Ayarla",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Suanki video su kisi tarafindan acildi ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Bilinmeyen video istegi.",
			Theater_AlreadyQueued = "Belirtilen video zaten oynatiliyor.",
			Theater_ProcessingRequest = Compile("Su kisi tarafindan video isleniyor ", ColHighlight, "%s", ColDefault, ""),
			Theater_RequestFailed = "Belirtilen video ile ilgili bir problem var.",
			Theater_Voteskipped = "Suanki video oy istegiyle gecildi.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " vidoyu gecmek icin zor kullandi."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " adli oyuncu sahneyi resetledi."),
			Theater_LostOwnership = "Tiyatrodan ayrildigi icin yonetmeni kaybettin.",
			Theater_NotifyOwnership = "Su anda tiyatro baskani sensin.",
			Theater_OwnerLockedQueue = "Tiyatro sahibi odayi kitledi.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " adli kisi odayi kitledi."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " adli kisi kilidi kaldirdi."),
			Theater_OwnerUseOnly = "Sadece tiyatro sahibi bunu kullanabilir.",
			Theater_PublicVideoLength = "Bu acik tiyatrodaki videolar sadece %s saniye oynatilabilir.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " adli kisi videoyu gecmek icin oylama baslatti ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " adli kisi kuyruga girdi."),

			-- Warnings
			Warning_Unsupported_Line1 = "Suanki harita Cinema tarafindan desteklenmiyor",
			Warning_Unsupported_Line2 = "Resmi haritayi acmak icin F1 tusuna basin",

			-- Queue
			Queue_Title = "KUYRUK",
			Request_Video = "Video Ac",
			Vote_Skip = "Oylama Baslat",
			Toggle_Fullscreen = "Tam ekran yap",
			Refresh_Theater = "Tiyatroyu yenile",

			-- Theater controls
			Theater_Admin = "ADMIN",
			Theater_Owner = "SAHIP",
			Theater_Skip = "Gec",
			Theater_Seek = "Ara",
			Theater_Reset = "Yeniden baslat",
			Theater_ChangeName = "Isim degistir",
			Theater_QueueLock = "Kurugu kitle/ac",
			Theater_SeekQuery = "HH:MM:SS veya su kadar sure (e.g. 1:30:00 or 5400)",

			-- Theater list
			TheaterList_NowShowing = "SU ANDA GOSTERILIYOR",

			-- Request Panel
			Request_History = "GECMIS",
			Request_Clear = "Temizle",
			Request_DeleteTooltip = "Bu videoyu gecmisten temizle",
			Request_PlayCount = "%d talep", -- e.g. 10 talep var
			Request_Url = "URL Sec",
			Request_Url_Tooltip = "Lutfen gecerli bir URL girin.\nEger URL gecerliyse buton kirmizi yanacaktir",

			-- Scoreboard settings panel
			Settings_Title = "AYARLAR",
			Settings_ClickActivate = "MOUSEYI AKTIF ETMEK ICIN TIKLA",
			Settings_VolumeLabel = "Ses Seviyesi",
			Settings_VolumeTooltip = "Sesi yukseltmek icin +/- tuslarini kullanin.",
			Settings_HidePlayersLabel = "Tiyatrodaki oyunculari gizle",
			Settings_HidePlayersTooltip = "Tiyatro icinde oyuncularin gorunurluklerini azalt.",
			Settings_MuteFocusLabel = "Alt-tab yapildiginda sesi kapat",
			Settings_MuteFocusTooltip = "Garry's Mod kapaliyken sesi kapat (e.g. you alt-tabbed).",

			-- Video Services
			Service_EmbedDisabled = "Talep edilen videoda gomme kapalidir.",
			Service_PurchasableContent = "Talep edilen video satin alinabilir icerik icerdigi icin acilamamaktadir.",
			Service_StreamOffline = "Sectiginiz canli yayin aktif degil.",

			-- Credits
			TranslationsCredit = "Ceviri %s tarafindan yapildi",
		},
		["uk"] = {
			-- Basic information
			Name = "Ukrainian", -- Native name for language
			Author = "Joker[Rus]", -- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

			-- Common
			Cinema = "CINEMA",
			Volume = "Гучність",
			Voteskips = "Пропуск",
			Loading = "Завантаження...",
			Invalid = "[НЕПРАВИЛЬНО]",
			NoVideoPlaying = "Немае Відео",
			Cancel = "Відміна",
			Set = "Встановити",

			-- Theater Announcements
			Theater_VideoRequestedBy = Compile("Це відео поставив ", ColHighlight, "%s", ColDefault, "."),
			Theater_InvalidRequest = "Неправильний запит відео.",
			Theater_AlreadyQueued = "Выбранне відео вже е в черзі.",
			Theater_ProcessingRequest = Compile("Обробка ", ColHighlight, "%s", ColDefault, " запита..."),
			Theater_RequestFailed = "Виникла проблема під час обробки выбранного видео.",
			Theater_Voteskipped = "Це відео було пропущено із за голосування.",
			Theater_ForceSkipped = Compile(ColHighlight, "%s", ColDefault, " вимкнув це відео."),
			Theater_PlayerReset = Compile(ColHighlight, "%s", ColDefault, " перезавантажив театр."),
			Theater_LostOwnership = "Ви втратили володіння над театром із за виходу з театру.",
			Theater_NotifyOwnership = "Ви стали власником цього приватного театру.",
			Theater_OwnerLockedQueue = "Власник театру відключив можливість вставку відео в чергу.",
			Theater_LockedQueue = Compile(ColHighlight, "%s", ColDefault, " закрив можливість вставки відео."),
			Theater_UnlockedQueue = Compile(ColHighlight, "%s", ColDefault, " відкрив возможность вставки видео."),
			Theater_OwnerUseOnly = "Тільки власник театру може використовувати це.",
			Theater_PublicVideoLength = "Максимальний ліміт відео в Публічному Театрі %s секунд(и) в довжину.",
			Theater_PlayerVoteSkipped = Compile(ColHighlight, "%s", ColDefault, " проголосував за пропуск ", ColHighlight, "(%s/%s)", ColDefault, "."),
			Theater_VideoAddedToQueue = Compile(ColHighlight, "%s", ColDefault, " було додано в чергу."),

			-- Warnings
			Warning_Unsupported_Line1 = "ця карта не підтримується ігровим режимом Cinema",
			Warning_Unsupported_Line2 = "Натисніть F1 щоб знайти офіційні карти в ВоркШопе",

			-- Queue
			Queue_Title = "Черга",
			Request_Video = "Встановити Відео",
			Vote_Skip = "Голосувати За Пропуск",
			Toggle_Fullscreen = "Повноекранний Режим",
			Refresh_Theater = "Перезавантажити Театр",

			-- Theater controls
			Theater_Admin = "Адмін",
			Theater_Owner = "Власник",
			Theater_Skip = "Прибрати Відео",
			Theater_Seek = "Перемотати",
			Theater_Reset = "Перезавантажити",
			Theater_ChangeName = "змінити ім'я",
			Theater_QueueLock = "Закрити Вставку Відео",
			Theater_SeekQuery = "ЧЧ:ММ:СС або число в секундах (приклад. 1:30:00 або 5400)",

			-- Theater list
			TheaterList_NowShowing = "Зараз Показують",

			-- Request Panel
			Request_History = "Історія",
			Request_Clear = "Очистити",
			Request_DeleteTooltip = "Видалити відео з історії",
			Request_PlayCount = "%d переглядів(да)", -- e.g. 10 request(s)
			Request_Url = "Вибрати Відео",
			Request_Url_Tooltip = "Натисніть сюди щоб ​​додати відео в чергу.\nКнопка буде червона якщо ссилка не правильна.",

			-- Scoreboard settings panel
			Settings_Title = "Налаштування",
			Settings_ClickActivate = "Клік щоб активувати мишку",
			Settings_VolumeLabel = "Гучність",
			Settings_VolumeTooltip = "Використовуйте +/- кнопки щоб ​​збільшити / зменшити гучність.",
			Settings_HidePlayersLabel = "Ховати гравців у театрі",
			Settings_HidePlayersTooltip = "У театрах гравці стануть невидимі для вас.",
			Settings_MuteFocusLabel = "Глушити звук у не ігри",
			Settings_MuteFocusTooltip = "Відключення звуку театру коли ви в не ігри (наприклад. гра згорнута).",

			-- Video Services
			Service_EmbedDisabled = "Заборонено вставляти вбранне відео.",
			Service_PurchasableContent = "Дане відео має заборонений контент, і не може бути поставлено в чергу.",
			Service_StreamOffline = "Запитуваний стрім оффлайн.",

			-- Credits
			TranslationsCredit = "Переклад виконав %s",
		}
	}

	-- Insert Language ID into translation
	for id, lang in pairs(Languages) do
		Languages[id].Id = id
	end

	do
		translations = {}

		function translations:GetLanguage()
			return CurrentId
		end

		function translations:GetLanguages()
			return Languages
		end

		function translations:LanguageSupported()
			return Languages[self:GetLanguage()] and true or false
		end

		function translations:Format( key, ... )
			if not key then return "" end
			local lang = self:GetLanguage()
			local value = Languages[lang] and Languages[lang][key] or Languages[DefaultId][key]
			if not value then value = key end
			return value:format(...)
		end

		function translations:FormatChat( key, ... )
			local value = self:Format( key, ... )

			-- Parse tags
			if value:find(patterns.tag) then

				local tbl = {}

				while true do

					-- Find first tag occurance
					local start, stop = value:find(patterns.tag)

					-- Break loop if there are no more tags
					if not start then
						-- Insert remaining fragment of translation
						if value ~= "" then
							table.insert( tbl, value )
						end
						break
					end

					-- Insert beginning fragment of translation
					if start > 0 then
						local str = value:sub(0, start - 1)
						table.insert( tbl, str )
					end

					-- Extract tag
					local tag = value:sub(start, stop)

					-- Parse and insert tag object
					table.insert( tbl, parseTag(tag) )

					-- Reduce translation string past tag
					value = value:sub(stop + 1, #value)

				end

				value = tbl

			end

			return istable(value) and value or {value}
		end

	end

	cvars.AddChangeCallback("gmod_language", function(_, value_old, value_new)
		if not CLIENT then return end

		CurrentId = Languages[value_new] and value_new or DefaultId
		RunConsoleCommand("cinema_langupdate")
	end)

end
