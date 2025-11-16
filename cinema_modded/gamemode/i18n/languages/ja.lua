-- 日本語 language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: f122apg

return {
	-- Basic information (metadata)
	Name = "日本語",
	Author = "f122apg",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "音量",
	Voteskips = "スキップの投票数",
	Loading = "読み込み中...",
	Invalid = "【無効】",
	NoVideoPlaying = "再生中の動画はありません。",
	Cancel = "キャンセル",
	Set = "セット",

	-- Theater Announcements
	Theater_VideoRequestedBy = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}は動画をリクエストしました。",
	Theater_InvalidRequest = "無効なリクエスト",
	Theater_AlreadyQueued = "この動画は既にキューに存在しています。",
	Theater_ProcessingRequest = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}はリクエスト処理中です。",
	Theater_RequestFailed = "リクエスト処理が失敗しました。",
	Theater_Voteskipped = "この動画は投票により、スキップされました。",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}は動画を強制的にスキップしました。",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}はtheaterをリセットしました。",
	Theater_LostOwnership = "あなたはPrivate theaterを抜けた為、オーナー権限が失われました。",
	Theater_NotifyOwnership = "あなたはPrivate theaterのオーナーになりました。",
	Theater_OwnerLockedQueue = "オーナーがキューにロックをかけました。",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} はキューにロックをかけました。",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} はキューのロックを解除しました。",
	Theater_OwnerUseOnly = "オーナーだけが使用できます。",
	Theater_PublicVideoLength = "Public theaterは%s秒に1度リクエストできます。",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}は{{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}をスキップ投票しました。",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}はキューを追加しました。",

	-- Warning messages
	Warning_Unsupported_Line1 = "このマップはCinema gamemodeに対応していません。",
	Warning_Unsupported_Line2 = "F1を押すとワークショップにある公式のマップを開きます。",

	-- Queue interface
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
	Request_PlayCount = "リクエスト回数：%d",
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

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "翻訳者：%s",

}
