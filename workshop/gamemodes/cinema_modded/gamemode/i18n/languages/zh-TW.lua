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

	-- Warning messages
	Warning_Unsupported_Line1 = "目前地圖不支援Cinema模式",
	Warning_Unsupported_Line2 = "請按F1打開Steam Workship的Cinema模式官方地圖",

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

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "由 %s 翻譯",

}
