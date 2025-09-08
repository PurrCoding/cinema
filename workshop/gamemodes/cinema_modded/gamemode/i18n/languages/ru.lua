-- Russian language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Joker[Rus], berry, Alivebyte!

return {
	-- Basic information (metadata)
	Name = "Russian",
	Author = "Joker[Rus], berry, Alivebyte!",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Громкость",
	Voteskips = "Пропуск",
	Loading = "Загрузка...",
	Invalid = "[НЕПРАВИЛЬНО]",
	NoVideoPlaying = "Нет видео",
	Cancel = "Отмена",
	Set = "Установить",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Текущее видео поставил {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Неправильный запрос видео.",
	Theater_AlreadyQueued = "Выбранное видео уже есть в очереди.",
	Theater_ProcessingRequest = "Обработка {{rgb:158,37,33}}%s{{rgb:200,200,200}} запроса...",
	Theater_RequestFailed = "Возникла проблема во время обработки выбранного видео.",
	Theater_Voteskipped = "Это видео было пропущено из-за голосования.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} выключил текущее видео.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} перезагрузил театр.",
	Theater_LostOwnership = "Вы потеряли владения над театром, из-за выхода из театра.",
	Theater_NotifyOwnership = "Вы стали владельцем этого приватного театра.",
	Theater_OwnerLockedQueue = "Владелец театра отключил возможность вставку видео в очередь.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} закрыл возможность вставки видео.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} открыл возможность вставки видео.",
	Theater_OwnerUseOnly = "Только владелец театра может использовать это.",
	Theater_PublicVideoLength = "Максимальный лимит видео в публичном театре %s сек. в длину.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} проголосовал за пропуск {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} было добавлено в очередь.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Текущая карта не поддерживается игровым режимом Cinema",
	Warning_Unsupported_Line2 = "Нажмите F1, чтобы найти официальные карты в мастерской",

	-- Queue interface
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
	Request_PlayCount = "%d просмотра(ов)",
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

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Перевод запилили: %s",

}
