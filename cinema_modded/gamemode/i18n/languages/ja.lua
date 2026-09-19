-- 日本語
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
	Dependency_Missing_Line1 = "おっと！何かが足りないようです...",
	Dependency_Missing_Line2 = "F4を押すと説明動画を開きます。",

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
	Theater_Pause = "一時停止",
	Theater_Resume = "再開",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} が動画を一時停止しました。",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} が動画を再開しました。",

	-- Theater list
	TheaterList_NowShowing = "上映中",

	-- Request Panel
	Request_History = "履歴",
	Request_Clear = "クリア",
	Request_DeleteTooltip = "履歴から削除する",
	Request_PlayCount = "リクエスト回数：%d",
	Request_Url = "リクエストURL",
	Request_Url_Tooltip = "URLが有効な時にリクエストを押します。\nこのボタンが赤い時はリクエスト可能な動画です。",
	Request_Filter_AllServices = "すべてのサービス",
	Request_Filter_SortBy_LastRequest = "最終リクエスト",
	Request_Filter_SortBy_Alphabet = "アルファベット順",
	Request_Filter_SortBy_Duration = "再生時間",
	Request_Filter_SortBy_RequestCount = "リクエスト回数",
	Request_Paginator_ResultCount = "%s 件の結果",
	Request_Paginator_PageOf = "%d / %d ページ",

	-- Scoreboard settings panel
	Settings_Title = "設定",
	Settings_ClickActivate = "マウスをアクティブにするにはクリックします。",
	Settings_VolumeLabel = "音量",
	Settings_VolumeTooltip = "+/-キーで音量の上げ/下げが可能です。",
	Settings_HidePlayersLabel = "プレイヤーを非表示",
	Settings_HidePlayersTooltip = "theater内にいるプレイヤーを非表示にします。",
	Settings_MuteFocusLabel = "ウィンドウ切り替え時、ミュートにする",
	Settings_MuteFocusTooltip = "Garry's Modから別ウィンドウに切り替えた時にミュートします。(Alt+Tabを押した時など)",
	Settings_SmoothVideoLabel = "スムーズな動画再生",
	Settings_SmoothVideoTooltip = "FPSを犠牲にして、一部の動画をより滑らかに再生します。",

	-- Video Services
	Service_EmbedDisabled = "リクエストされた動画は埋め込みを無効にしています。",
	Service_PurchasableContent = "リクエストされた動画は有料の動画なので再生できません。",
	Service_StreamOffline = "リクエストされたストリームはオフラインです。",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "翻訳者：%s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s 時間",
	Unit_Hours   = "%s 時間",
	Unit_Minute  = "%s 分",
	Unit_Minutes = "%s 分",
	Unit_Second  = "%s 秒",
	Unit_Seconds = "%s 秒",
	Currency_Points = "%s ポイント",
	Currency_DonatorPoints = "%s ドナーポイント",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "このtheaterはPrivateではないため、レンタルできません！",
	Rent_AlreadyRentedBy = "このtheaterは既に{{rgb:158,37,33}}%s{{rgb:200,200,200}}がレンタルしています。",
	Rent_AlreadyRentingOther = "あなたは既に{{rgb:158,37,33}}%s{{rgb:200,200,200}}をレンタルしています。",
	Rent_MinTime = "少なくとも%s分間レンタルする必要があります。",
	Rent_MaxTime = "%s分を超えてレンタルすることはできません。",
	Rent_CantAfford = "そのレンタル料金を支払えません (%s)！",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}がこのtheaterを%s間レンタルしました。",
	Rent_ExtendNotRenting = "レンタルを延長するには、既にこのtheaterをレンタルしている必要があります！",
	Rent_ExtendMinTime = "レンタルを合計で少なくとも%s分まで延長する必要があります。",
	Rent_ExtendMaxTime = "%s分を超えてレンタルすることはできません。",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}がこのtheaterのレンタルをさらに%s延長しました。",
	Rent_RefundNotRenting = "レンタルを払い戻すには、このtheaterをレンタルしている必要があります。",
	Rent_RefundNotEnoughTime = "払い戻すにはレンタルの残り時間が足りません。",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}がこのtheaterのレンタルを払い戻しました。",
	Rent_Refunded = "%s分間のレンタル料金として%sが払い戻されました。",
	Rent_NotRented = "このtheaterは現在レンタルされていません。",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}のこのtheaterのレンタルが管理者によりキャンセルされました。",
	Rent_CancelledOwner = "あなたのレンタルがキャンセルされ、%s分間のレンタル料金として%sが払い戻されました。",
	Rent_CancelledAdmin = "あなたは{{rgb:158,37,33}}%s{{rgb:200,200,200}}のレンタルをキャンセルしました。",
	Rent_CancelledAdminUnknown = "レンタルをキャンセルしましたが、オーナーが払い戻し前に切断しました。",
	Rent_ExpiredOwner = "{{rgb:158,37,33}}%s{{rgb:200,200,200}}でのあなたのレンタルが終了しました。",
	Rent_ExpiredPublic = "このtheaterのレンタルが終了しました！",
	Rent_VoteSkipLocked = "このtheaterのオーナーがスキップ投票をロックしました。",
	Rent_VoteSkipUnlocked = "このtheaterのオーナーがスキップ投票のロックを解除しました。",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Privateではないtheaterにプレイヤーフィルターを設定することはできません！",
	Rent_FilterNotRented = "プレイヤーフィルターを設定する前に、このtheaterをレンタルする必要があります！",
	Rent_FilterNotOwner = "プレイヤーフィルターを設定するには、このtheaterのオーナーである必要があります！",
	Rent_FilterUpdated = "プレイヤーフィルターが更新されました。",
	Rent_FilterAdminWarn = "管理者警告：あなたは現在このtheaterからフィルターされています。",
	Rent_FilterSuperWarn = "管理者警告：{{rgb:158,37,33}}%s{{rgb:200,200,200}}が滞在中のtheaterからフィルターされました。",
	Rent_FilteredOut = "あなたはtheaterからフィルターされました。",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "あなたは現在このtheaterを次の%s間レンタルしています。",
	Rent_CurrentlyRentedBy = "このtheaterは現在{{rgb:158,37,33}}%s{{rgb:200,200,200}}が次の%s間レンタルしています。",
	Rent_MustBeRented = "このtheaterを使用するにはレンタルする必要があります。",
	Rent_AdminFilteredWarn = "管理者警告：あなたはこのtheaterからフィルターされています。",
	Rent_AdminEnteredFiltered = "管理者警告：{{rgb:158,37,33}}%s{{rgb:200,200,200}}がフィルターされているtheaterに入りました。",
	Rent_NotAllowed = "あなたはこのtheaterへの入場を許可されていません。",
	Rent_VoteSkipDisabled = "申し訳ありませんが、このtheaterのオーナーがスキップ投票を無効にしています。",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "レンタルをキャンセルするには、theater内にいる必要があります。",
	Rent_MustBeInTheaterFilter = "プレイヤーフィルターを設定するには、あなたのtheater内にいる必要があります。",
	Rent_MustBeInTheaterSeeFilter = "プレイヤーフィルターを確認するには、theater内にいる必要があります。",
	Rent_NotOwnerSeeFilter = "プレイヤーフィルターを確認するには、このtheaterのオーナーである必要があります。",
	Rent_MustBeInTheaterVoteLock = "スキップ投票をロックするには、theater内にいる必要があります。",
	Rent_NotOwnerVoteLock = "スキップ投票を変更するには、このtheaterのオーナーである必要があります。",
	Rent_MustBeInTheaterRent = "レンタルするには、theater内にいる必要があります！",
	Rent_MustBeInTheaterRefund = "レンタルを払い戻すには、theater内にいる必要があります！",

	-- Theater Rentals: UI
	Rent_RentTheater = "theaterをレンタル",
	Rent_Minutes = "分",
	Rent_Purchase = "購入",
	Rent_PurchaseFor = "%sで購入",
	Rent_ToggleVoteSkipLock = "スキップ投票ロックの切り替え",
	Rent_PlayerFilter = "プレイヤーフィルター",
	Rent_AddRentTime = "レンタル時間を追加",
	Rent_RefundButton = "レンタルを払い戻す",
	Rent_CancelButton = "レンタルをキャンセル",
	Rent_Remaining = "レンタル残り時間",
	Rent_WhitelistMode = "ホワイトリストモード",
	Rent_BlacklistMode = "ブラックリストモード",
	Rent_Apply = "適用",
	Rent_Retrieving = "取得中...",
	Rent_Unknown = "不明",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "オープン",
	Rent_OwnerDisconnected = "オーナー切断済み",
	Rent_ThumbRemaining = "レンタル残り時間: %s",
}