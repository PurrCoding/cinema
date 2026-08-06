-- 한국어
-- Author: ChiNo

return {
	-- Basic information (metadata)
	Name = "한국어",
	Author = "ChiNo",

	-- Common UI elements
	Cinema = "시네마",
	Volume = "음량",
	Voteskips = "투표 건너뛰기",
	Loading = "불러오는 중...",
	Invalid = "[인식 불가능]",
	NoVideoPlaying = "재생 중인 비디오 없음",
	Cancel = "취소",
	Set = "확인",

	-- Theater Announcements
	Theater_VideoRequestedBy = "현재 비디오를 신청한 플레이어는 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 입니다.",
	Theater_InvalidRequest = "인식 불가능한 비디오 정보.",
	Theater_AlreadyQueued = "선택하신 비디오는 이미 대기 열에 있습니다.",
	Theater_ProcessingRequest = "스트리밍 서비스 {{rgb:158,37,33}}%s{{rgb:200,200,200}}를 불러오는 중...",
	Theater_RequestFailed = "선택하신 비디오를 불러오는 중 문제가 생겼습니다.",
	Theater_Voteskipped = "현재 재생 중이었던 비디오는 투표로 인해 건너뛰어졌습니다.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 강제로 건너뛰기 하였습니다.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 극장을 초기화하였습니다.",
	Theater_LostOwnership = "극장을 떠나서 가지고 있던 주인 권한을 잃으셨습니다.",
	Theater_NotifyOwnership = "당신은 이 개인 극장의 주인 권한을 얻으셨습니다.",
	Theater_OwnerLockedQueue = "극장의 주인이 대기 열을 잠갔습니다.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 대기 열을 잠갔습니다.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 대기 열을 잠금 해제하였습니다.",
	Theater_OwnerUseOnly = "오로지 주인만이 이것을 사용할 수 있습니다.",
	Theater_PublicVideoLength = "공용 극장은 %s 초의 길이 제한이 있습니다.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 건너뛰기 투표를 하였습니다. {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 비디오가 대기열에 추가되었습니다.",

	-- Warning messages
	Warning_Unsupported_Line1 = "선택하신 맵은 시네마 게임 모드에 호환되지 않습니다.",
	Warning_Unsupported_Line2 = "F1을 눌러 시네마 공식 맵을 창작 마당에서 확인하세요.",
	Dependency_Missing_Line1 = "이런! 무언가가 빠졌습니다...",
	Dependency_Missing_Line2 = "F4를 눌러 설명 영상을 확인하세요.",

	-- Queue interface
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
	Theater_Pause = "일시정지",
	Theater_Resume = "재생",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 영상을 일시정지했습니다.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 영상을 다시 재생했습니다.",

	-- Theater list
	TheaterList_NowShowing = "지금 재생 중",

	-- Request Panel
	Request_History = "최근 기록",
	Request_Clear = "초기화",
	Request_DeleteTooltip = "비디오를 최근 기록에서 삭제합니다.",
	Request_PlayCount = "%d 개 신청됨",
	Request_Url = "URL 요청",
	Request_Url_Tooltip = "올바른 URL을 요청하십시오.\n버튼 색깔이 빨간색일때 올바른 URL입니다.",
	Request_Filter_AllServices = "모든 서비스",
	Request_Filter_SortBy_LastRequest = "최근 신청",
	Request_Filter_SortBy_Alphabet = "가나다순",
	Request_Filter_SortBy_Duration = "재생 시간",
	Request_Filter_SortBy_RequestCount = "신청 횟수",
	Request_Paginator_ResultCount = "%s 개 결과",
	Request_Paginator_PageOf = "%d / %d 페이지",

	-- Scoreboard settings panel
	Settings_Title = "설정",
	Settings_ClickActivate = "마우스를 클릭하여 활성화합니다.",
	Settings_VolumeLabel = "음량",
	Settings_VolumeTooltip = "+/- 키를 사용해 음량을 올리거나 내리세요.",
	Settings_HidePlayersLabel = "극장에서 다른 플레이어 숨김",
	Settings_HidePlayersTooltip = "다른 플레이어들을 숨겨서 안 보이게 합니다.",
	Settings_MuteFocusLabel = "ALT + TAB 음소거",
	Settings_MuteFocusTooltip = "ALT + TAB을 사용해 다른 시점으로 갔을때 음소거 합니다.",
	Settings_SmoothVideoLabel = "부드러운 비디오 재생",
	Settings_SmoothVideoTooltip = "FPS를 희생해 일부 비디오를 더 부드럽게 재생합니다.",

	-- Video Services
	Service_EmbedDisabled = "신청하신 비디오는 해제되있습니다",
	Service_PurchasableContent = "신청된 비디오는 매수할 수 있는 콘텐츠와 연주가 될 수 없습니다.",
	Service_StreamOffline = "스트리밍 서비스가 오프라인입니다.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "번역 %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s 시간",
	Unit_Hours   = "%s 시간",
	Unit_Minute  = "%s 분",
	Unit_Minutes = "%s 분",
	Unit_Second  = "%s 초",
	Unit_Seconds = "%s 초",
	Currency_Points = "%s 포인트",
	Currency_DonatorPoints = "%s 후원자 포인트",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "이 극장은 개인 극장이 아니므로 대여할 수 없습니다!",
	Rent_AlreadyRentedBy = "이 극장은 이미 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 대여 중입니다.",
	Rent_AlreadyRentingOther = "당신은 이미 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 을(를) 대여 중입니다.",
	Rent_MinTime = "최소 %s 분 이상 대여해야 합니다.",
	Rent_MaxTime = "%s 분을 초과하여 대여할 수 없습니다.",
	Rent_CantAfford = "그 대여 비용을 지불할 수 없습니다 (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 이 극장을 %s 동안 대여했습니다.",
	Rent_ExtendNotRenting = "대여를 연장하려면 이미 이 극장을 대여 중이어야 합니다!",
	Rent_ExtendMinTime = "대여를 최소 총 %s 분까지 연장해야 합니다.",
	Rent_ExtendMaxTime = "%s 분을 초과하여 대여할 수 없습니다.",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 이 극장의 대여를 %s 만큼 추가로 연장했습니다.",
	Rent_RefundNotRenting = "대여를 환불하려면 이 극장을 대여 중이어야 합니다.",
	Rent_RefundNotEnoughTime = "환불하기에는 대여 시간이 충분히 남아 있지 않습니다.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 이 극장의 대여를 환불했습니다.",
	Rent_Refunded = "%s 분의 대여에 대해 %s 을(를) 환불받았습니다.",
	Rent_NotRented = "이 극장은 현재 대여 중이 아닙니다.",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 님의 이 극장 대여가 관리자에 의해 취소되었습니다.",
	Rent_CancelledOwner = "대여가 취소되었으며 %s 분의 대여에 대해 %s 을(를) 환불받았습니다.",
	Rent_CancelledAdmin = "당신은 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 님의 대여를 취소했습니다.",
	Rent_CancelledAdminUnknown = "대여를 취소했으나, 주인이 환불받기 전에 접속을 종료했습니다.",
	Rent_ExpiredOwner = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} 에서의 대여가 만료되었습니다.",
	Rent_ExpiredPublic = "이 극장의 대여가 만료되었습니다!",
	Rent_VoteSkipLocked = "이 극장의 주인이 건너뛰기 투표를 잠갔습니다.",
	Rent_VoteSkipUnlocked = "이 극장의 주인이 건너뛰기 투표를 잠금 해제했습니다.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "개인 극장이 아닌 극장에는 플레이어 필터를 설정할 수 없습니다!",
	Rent_FilterNotRented = "플레이어 필터를 설정하기 전에 이 극장을 먼저 대여해야 합니다!",
	Rent_FilterNotOwner = "플레이어 필터를 설정하려면 이 극장의 주인이어야 합니다!",
	Rent_FilterUpdated = "플레이어 필터가 업데이트되었습니다.",
	Rent_FilterAdminWarn = "관리자 경고: 이제 이 극장에서 필터링되었습니다.",
	Rent_FilterSuperWarn = "관리자 경고: {{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 자신이 있던 극장에서 필터링되었습니다.",
	Rent_FilteredOut = "당신은 극장에서 필터링되었습니다.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "당신은 현재 이 극장을 앞으로 %s 동안 대여 중입니다.",
	Rent_CurrentlyRentedBy = "이 극장은 현재 {{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 앞으로 %s 동안 대여 중입니다.",
	Rent_MustBeRented = "이 극장을 사용하려면 대여해야 합니다.",
	Rent_AdminFilteredWarn = "관리자 경고: 당신은 이 극장에서 필터링되었습니다.",
	Rent_AdminEnteredFiltered = "관리자 경고: {{rgb:158,37,33}}%s{{rgb:200,200,200}} 님이 자신이 필터링된 극장에 입장했습니다.",
	Rent_NotAllowed = "당신은 이 극장에 입장할 수 없습니다.",
	Rent_VoteSkipDisabled = "죄송합니다, 이 극장의 주인이 건너뛰기 투표를 비활성화했습니다.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "대여를 취소하려면 극장 안에 있어야 합니다.",
	Rent_MustBeInTheaterFilter = "플레이어 필터를 설정하려면 당신의 극장 안에 있어야 합니다.",
	Rent_MustBeInTheaterSeeFilter = "플레이어 필터를 보려면 극장 안에 있어야 합니다.",
	Rent_NotOwnerSeeFilter = "플레이어 필터를 보려면 이 극장의 주인이어야 합니다.",
	Rent_MustBeInTheaterVoteLock = "건너뛰기 투표를 잠그려면 극장 안에 있어야 합니다.",
	Rent_NotOwnerVoteLock = "건너뛰기 투표를 수정하려면 이 극장의 주인이어야 합니다.",
	Rent_MustBeInTheaterRent = "극장을 대여하려면 극장 안에 있어야 합니다!",
	Rent_MustBeInTheaterRefund = "대여를 환불하려면 극장 안에 있어야 합니다!",

	-- Theater Rentals: UI
	Rent_RentTheater = "극장 대여",
	Rent_Minutes = "분",
	Rent_Purchase = "구매",
	Rent_PurchaseFor = "%s 에 구매",
	Rent_ToggleVoteSkipLock = "건너뛰기 투표 잠금 전환",
	Rent_PlayerFilter = "플레이어 필터",
	Rent_AddRentTime = "대여 시간 추가",
	Rent_RefundButton = "대여 환불",
	Rent_CancelButton = "대여 취소",
	Rent_Remaining = "남은 대여 시간",
	Rent_WhitelistMode = "화이트리스트 모드",
	Rent_BlacklistMode = "블랙리스트 모드",
	Rent_Apply = "적용",
	Rent_Retrieving = "불러오는 중...",
	Rent_Unknown = "알 수 없음",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "열림",
	Rent_OwnerDisconnected = "주인 접속 종료됨",
	Rent_ThumbRemaining = "남은 대여 시간: %s",
}