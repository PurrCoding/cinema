-- 한국어 language file for Cinema gamemode
-- Converted from monolithic i18n.lua
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

	-- Theater list
	TheaterList_NowShowing = "지금 재생 중",

	-- Request Panel
	Request_History = "최근 기록",
	Request_Clear = "초기화",
	Request_DeleteTooltip = "비디오를 최근 기록에서 삭제합니다.",
	Request_PlayCount = "%d 개 신청됨",
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

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "번역 %s",

}
