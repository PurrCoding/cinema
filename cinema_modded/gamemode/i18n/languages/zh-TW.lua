-- Chinese 台灣正體 language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Poheart

return {
	-- Basic information (metadata)
	Name = "Chinese 台灣正體",
	Author = "Poheart",

	-- Common UI elements
	Cinema = "電影院",
	Volume = "音量",
	Voteskips = "投票跳過",
	Loading = "載入中...",
	Invalid = "[無效]",
	NoVideoPlaying = "沒有影片播放中",
	Cancel = "取消",
	Set = "設定",

	-- Theater Announcements
	Theater_VideoRequestedBy = "目前的影片由 {{rgb:158,37,33}}%s{{rgb:200,200,200}}提出.",
	Theater_InvalidRequest = "無效的影片請求.",
	Theater_AlreadyQueued = "所請求的影片已經在佇列中.",
	Theater_ProcessingRequest = "正在處理 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 的請求...",
	Theater_RequestFailed = "處理所請求的影片時出現了問題.",
	Theater_Voteskipped = "目前的的影片已經被投票跳過.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已強制跳過目前的影片.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已重設影院.",
	Theater_LostOwnership = "由於你已經離開影院,你失去了影院的擁有權.",
	Theater_NotifyOwnership = "你現在是本私人影院的擁有者.",
	Theater_OwnerLockedQueue = "影院擁有者已鎖定了本影院的影片佇列.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已鎖定了本影院的影片佇列.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已解鎖了本影院的影片佇列.",
	Theater_OwnerUseOnly = "只有影院擁有者才能使用.",
	Theater_PublicVideoLength = "公眾影院的影片請求只能播放 %s 秒內的長度",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已投票跳過目前的影片 {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已加入到佇列.",
	Theater_Pause = "暫停",
	Theater_Resume = "繼續",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 暫停了影片。",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 繼續播放了影片。",

	-- Warning messages
	Warning_Unsupported_Line1 = "目前地圖不支援Cinema模式",
	Warning_Unsupported_Line2 = "請按F1打開Steam Workship的Cinema模式官方地圖",
	Dependency_Missing_Line1 = "糟糕！你似乎缺少了某些東西...",
	Dependency_Missing_Line2 = "請按 F4 開啟說明影片。",

	-- Queue interface
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
	Request_PlayCount = "%d 個請求",
	Request_Url = "請求網址",
	Request_Url_Tooltip = "按下請求一個有效的視頻網址.\n按鈕將會變成紅色當您提供一個有效的URL",
	Request_Filter_AllServices = "所有服務",
	Request_Filter_SortBy_LastRequest = "最後請求",
	Request_Filter_SortBy_Alphabet = "按字母排序",
	Request_Filter_SortBy_Duration = "時長",
	Request_Filter_SortBy_RequestCount = "請求次數",
	Request_Paginator_ResultCount = "%s 個結果",
	Request_Paginator_PageOf = "第 %d 頁，共 %d 頁",

	-- Scoreboard settings panel
	Settings_Title = "設定",
	Settings_ClickActivate = "按一下顯示你的鼠標",
	Settings_VolumeLabel = "音量",
	Settings_VolumeTooltip = "利用 +/- 鍵以 增加/減小 音量.",
	Settings_HidePlayersLabel = "隱藏影院內其他玩家",
	Settings_HidePlayersTooltip = "減低影院內的玩家可見性.",
	Settings_MuteFocusLabel = "當Alt-Tab時靜音",
	Settings_MuteFocusTooltip = "當你Alt-tab 切換窗口時靜音影院內播放的視頻.",
	Settings_SmoothVideoLabel = "平滑影片播放",
	Settings_SmoothVideoTooltip = "以犧牲 FPS 為代價使部分影片播放更流暢。",

	-- Video Services
	Service_EmbedDisabled = "所請求的影片禁用了嵌入式播放的使用.",
	Service_PurchasableContent = "所請求的影片是可購買內容因此不能被播放.",
	Service_StreamOffline = "所請求的直播已離線.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "由 %s 翻譯",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s 小時",
	Unit_Hours   = "%s 小時",
	Unit_Minute  = "%s 分鐘",
	Unit_Minutes = "%s 分鐘",
	Unit_Second  = "%s 秒",
	Unit_Seconds = "%s 秒",
	Currency_Points = "%s 點數",
	Currency_DonatorPoints = "%s 贊助點數",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "此影院並非私人影院，無法租用！",
	Rent_AlreadyRentedBy = "此影院已由 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 租用。",
	Rent_AlreadyRentingOther = "你已經在租用 {{rgb:158,37,33}}%s{{rgb:200,200,200}}。",
	Rent_MinTime = "你至少必須租用 %s 分鐘。",
	Rent_MaxTime = "你租用的時間不能超過 %s 分鐘。",
	Rent_CantAfford = "你無法負擔該租金 (%s)！",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已租用此影院 %s。",
	Rent_ExtendNotRenting = "你必須先租用此影院才能延長租期！",
	Rent_ExtendMinTime = "你延長後的租期總計至少必須達到 %s 分鐘。",
	Rent_ExtendMaxTime = "你的租期不能超過 %s 分鐘。",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已將此影院的租期再延長了 %s。",
	Rent_RefundNotRenting = "你必須正在租用此影院才能退還其租金。",
	Rent_RefundNotEnoughTime = "租期剩餘的時間不足以退款。",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已退還此影院的租金。",
	Rent_Refunded = "你已因 %s 分鐘的租期獲得 %s 的退款。",
	Rent_NotRented = "此影院目前並未被租用。",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 對此影院的租用已被管理員取消。",
	Rent_CancelledOwner = "你的租用已被取消，並已因 %s 分鐘的租期獲得 %s 的退款。",
	Rent_CancelledAdmin = "你已取消 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 的租用。",
	Rent_CancelledAdminUnknown = "你已取消該租用，但其擁有者在能夠退款前已斷開連接。",
	Rent_ExpiredOwner = "你在 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 的租期已用盡。",
	Rent_ExpiredPublic = "此影院的租期已用盡！",
	Rent_VoteSkipLocked = "此影院的擁有者已鎖定投票跳過。",
	Rent_VoteSkipUnlocked = "此影院的擁有者已解鎖投票跳過。",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "你無法在非私人影院上設定玩家過濾器！",
	Rent_FilterNotRented = "此影院必須先被租用，你才能在其上設定玩家過濾器！",
	Rent_FilterNotOwner = "你必須是此影院的擁有者才能在其上設定玩家過濾器！",
	Rent_FilterUpdated = "玩家過濾器已更新。",
	Rent_FilterAdminWarn = "管理員警告：你現在已被此影院過濾。",
	Rent_FilterSuperWarn = "管理員警告：{{rgb:158,37,33}}%s{{rgb:200,200,200}} 在其所在的影院中被過濾。",
	Rent_FilteredOut = "你已被此影院過濾。",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "你目前正在租用此影院，剩餘時間為 %s。",
	Rent_CurrentlyRentedBy = "此影院目前由 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 租用，剩餘時間為 %s。",
	Rent_MustBeRented = "此影院必須被租用後才能使用。",
	Rent_AdminFilteredWarn = "管理員警告：你已被此影院過濾。",
	Rent_AdminEnteredFiltered = "管理員警告：{{rgb:158,37,33}}%s{{rgb:200,200,200}} 進入了一個已將其過濾的影院。",
	Rent_NotAllowed = "你不被允許進入此影院。",
	Rent_VoteSkipDisabled = "抱歉，此影院的擁有者已停用投票跳過。",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "你必須在影院內才能取消其租用。",
	Rent_MustBeInTheaterFilter = "你必須在你的影院內才能設定其玩家過濾器。",
	Rent_MustBeInTheaterSeeFilter = "你必須在影院內才能查看其玩家過濾器。",
	Rent_NotOwnerSeeFilter = "你必須是此影院的擁有者才能查看其玩家過濾器。",
	Rent_MustBeInTheaterVoteLock = "你必須在影院內才能鎖定投票跳過。",
	Rent_NotOwnerVoteLock = "你必須是此影院的擁有者才能修改投票跳過。",
	Rent_MustBeInTheaterRent = "你必須在影院內才能租用它！",
	Rent_MustBeInTheaterRefund = "你必須在影院內才能退還其租金！",

	-- Theater Rentals: UI
	Rent_RentTheater = "租用影院",
	Rent_Minutes = "分鐘",
	Rent_Purchase = "購買",
	Rent_PurchaseFor = "以 %s 購買",
	Rent_ToggleVoteSkipLock = "切換投票跳過鎖定",
	Rent_PlayerFilter = "玩家過濾器",
	Rent_AddRentTime = "增加租用時間",
	Rent_RefundButton = "退還租金",
	Rent_CancelButton = "取消租用",
	Rent_Remaining = "剩餘租期",
	Rent_WhitelistMode = "白名單模式",
	Rent_BlacklistMode = "黑名單模式",
	Rent_Apply = "套用",
	Rent_Retrieving = "獲取中...",
	Rent_Unknown = "未知",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "開放",
	Rent_OwnerDisconnected = "擁有者已斷開連接",
	Rent_ThumbRemaining = "剩餘租期: %s",
}