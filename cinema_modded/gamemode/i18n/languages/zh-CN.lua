-- 简体中文 language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: 初雪OriginalSnow

return {
	-- Basic information (metadata)
	Name = "简体中文",
	Author = "初雪OriginalSnow",

	-- Common UI elements
	Cinema = "电影院",
	Volume = "音量",
	Voteskips = "投票跳过",
	Loading = "加载中...",
	Invalid = "[无效]",
	NoVideoPlaying = "当前没有视频播放",
	Cancel = "取消",
	Set = "设置",

	-- Theater Announcements
	Theater_VideoRequestedBy = "当前的视频由 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 点播",
	Theater_InvalidRequest = "你的点播无效",
	Theater_AlreadyQueued = "你的点播已经在排队列表中",
	Theater_ProcessingRequest = "正在处理 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 的点播...",
	Theater_RequestFailed = "视频点播时出了一点小问题...",
	Theater_Voteskipped = "该视频已被投票跳过",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已强制跳过当前视频",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 重置了当前影院",
	Theater_LostOwnership = "由于你离开了影院，你已失去该影院的所有权",
	Theater_NotifyOwnership = "你现在是该私人影院的拥有者了",
	Theater_OwnerLockedQueue = "影院拥有者锁定了该影院的视频点播",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已经锁定了该影院的点播权限",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已经解锁了该影院的点播权限",
	Theater_OwnerUseOnly = "只有影院拥有者才能使用.",
	Theater_PublicVideoLength = "公共影院只能点播 %s 秒内的视频",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 投票跳过： {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已点播",
	Theater_Pause = "暂停",
	Theater_Resume = "继续",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 暂停了视频。",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 继续播放了视频。",

	-- Warning messages
	Warning_Unsupported_Line1 = "当前地图不支持Cinema模式",
	Warning_Unsupported_Line2 = "按下 F1 来打开创意工坊的 Cinema 官方地图",
	Dependency_Missing_Line1 = "哎呀！你好像丢失了某些东西...",
	Dependency_Missing_Line2 = "按下 F4 来打开介绍视频",

	-- Queue interface
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

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "%s 翻译",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s 小时",
	Unit_Hours   = "%s 小时",
	Unit_Minute  = "%s 分钟",
	Unit_Minutes = "%s 分钟",
	Unit_Second  = "%s 秒",
	Unit_Seconds = "%s 秒",
	Currency_Points = "%s 积分",
	Currency_DonatorPoints = "%s 捐赠积分",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "该影院不是私人影院，无法租用！",
	Rent_AlreadyRentedBy = "该影院已被 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 租用。",
	Rent_AlreadyRentingOther = "你已经在租用 {{rgb:158,37,33}}%s{{rgb:200,200,200}}。",
	Rent_MinTime = "你至少需要租用 %s 分钟。",
	Rent_MaxTime = "你租用的时间不能超过 %s 分钟。",
	Rent_CantAfford = "你无法支付该租金 (%s)！",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已租用该影院 %s。",
	Rent_ExtendNotRenting = "你必须正在租用该影院才能延长租期！",
	Rent_ExtendMinTime = "你延长后的租期总计至少需要 %s 分钟。",
	Rent_ExtendMaxTime = "你的租期不能超过 %s 分钟。",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已将该影院的租期延长了 %s。",
	Rent_RefundNotRenting = "你必须正在租用该影院才能退还租金。",
	Rent_RefundNotEnoughTime = "租期剩余时间不足，无法退还。",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 已退还该影院的租金。",
	Rent_Refunded = "你已获得 %s 的退款，对应 %s 分钟的租期。",
	Rent_NotRented = "该影院当前未被租用。",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 对该影院的租用已被管理员取消。",
	Rent_CancelledOwner = "你的租用已被取消，你已获得 %s 的退款，对应 %s 分钟的租期。",
	Rent_CancelledAdmin = "你已取消 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 的租用。",
	Rent_CancelledAdminUnknown = "你已取消该租用，但其拥有者在退款前已断开连接。",
	Rent_ExpiredOwner = "你在 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 的租期已到期。",
	Rent_ExpiredPublic = "该影院的租期已到期！",
	Rent_VoteSkipLocked = "该影院的拥有者已锁定投票跳过。",
	Rent_VoteSkipUnlocked = "该影院的拥有者已解锁投票跳过。",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "你无法在非私人影院上设置玩家过滤器！",
	Rent_FilterNotRented = "必须先租用该影院，才能设置玩家过滤器！",
	Rent_FilterNotOwner = "你必须是该影院的拥有者才能设置玩家过滤器！",
	Rent_FilterUpdated = "玩家过滤器已更新。",
	Rent_FilterAdminWarn = "管理员警告：你现在已被该影院过滤。",
	Rent_FilterSuperWarn = "管理员警告：{{rgb:158,37,33}}%s{{rgb:200,200,200}} 在其所在的影院中被过滤。",
	Rent_FilteredOut = "你已被该影院过滤。",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "你当前正在租用该影院，剩余时间为 %s。",
	Rent_CurrentlyRentedBy = "该影院当前由 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 租用，剩余时间为 %s。",
	Rent_MustBeRented = "该影院必须被租用后才能使用。",
	Rent_AdminFilteredWarn = "管理员警告：你已被该影院过滤。",
	Rent_AdminEnteredFiltered = "管理员警告：{{rgb:158,37,33}}%s{{rgb:200,200,200}} 进入了一个已将其过滤的影院。",
	Rent_NotAllowed = "你不被允许进入该影院。",
	Rent_VoteSkipDisabled = "抱歉，该影院的拥有者已禁用投票跳过。",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "你必须在影院内才能取消其租用。",
	Rent_MustBeInTheaterFilter = "你必须在你的影院内才能设置其玩家过滤器。",
	Rent_MustBeInTheaterSeeFilter = "你必须在影院内才能查看其玩家过滤器。",
	Rent_NotOwnerSeeFilter = "你必须是该影院的拥有者才能查看其玩家过滤器。",
	Rent_MustBeInTheaterVoteLock = "你必须在影院内才能锁定投票跳过。",
	Rent_NotOwnerVoteLock = "你必须是该影院的拥有者才能修改投票跳过。",
	Rent_MustBeInTheaterRent = "你必须在影院内才能租用它！",
	Rent_MustBeInTheaterRefund = "你必须在影院内才能退还其租金！",

	-- Theater Rentals: UI
	Rent_RentTheater = "租用影院",
	Rent_Minutes = "分钟",
	Rent_Purchase = "购买",
	Rent_PurchaseFor = "以 %s 购买",
	Rent_ToggleVoteSkipLock = "切换投票跳过锁定",
	Rent_PlayerFilter = "玩家过滤器",
	Rent_AddRentTime = "增加租用时间",
	Rent_RefundButton = "退还租金",
	Rent_CancelButton = "取消租用",
	Rent_Remaining = "剩余租期",
	Rent_WhitelistMode = "白名单模式",
	Rent_BlacklistMode = "黑名单模式",
	Rent_Apply = "应用",
	Rent_Retrieving = "获取中...",
	Rent_Unknown = "未知",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "开放",
	Rent_OwnerDisconnected = "拥有者已断开连接",
	Rent_ThumbRemaining = "剩余租期: %s",
}