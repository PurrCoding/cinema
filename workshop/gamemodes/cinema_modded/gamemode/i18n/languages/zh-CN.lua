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

	-- Credits
	TranslationsCredit = "%s 翻译",

}
