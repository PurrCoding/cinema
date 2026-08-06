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
	Dependency_Missing_Line1 = "Упс! У вас чего-то не хватает...",
	Dependency_Missing_Line2 = "Нажмите F4, чтобы открыть видео с инструкциями.",

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
	Theater_Pause = "Пауза",
	Theater_Resume = "Продолжить",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} поставил(а) видео на паузу.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} возобновил(а) воспроизведение видео.",

	-- Theater list
	TheaterList_NowShowing = "Сейчас показывают",

	-- Request Panel
	Request_History = "ИСТОРИЯ",
	Request_Clear = "Очистить",
	Request_DeleteTooltip = "Удалить видео из истории",
	Request_PlayCount = "%d просмотра(ов)",
	Request_Url = "Выбрать видео",
	Request_Url_Tooltip = "Нажмите сюда, чтобы добавить видео в очередь.\nКнопка будет красная, если ссылка не правильная.",
	Request_Filter_AllServices = "Все сервисы",
	Request_Filter_SortBy_LastRequest = "Последний запрос",
	Request_Filter_SortBy_Alphabet = "По алфавиту",
	Request_Filter_SortBy_Duration = "По длительности",
	Request_Filter_SortBy_RequestCount = "По количеству запросов",
	Request_Paginator_ResultCount = "%s результатов",
	Request_Paginator_PageOf = "Страница %d из %d",

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
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Перевод запилили: %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s час",
	Unit_Hours   = "%s часов",
	Unit_Minute  = "%s минута",
	Unit_Minutes = "%s минут",
	Unit_Second  = "%s секунда",
	Unit_Seconds = "%s секунд",
	Currency_Points = "%s очков",
	Currency_DonatorPoints = "%s донат-очков",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Этот театр не приватный и не может быть арендован!",
	Rent_AlreadyRentedBy = "Этот театр уже арендует {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Вы уже арендуете {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Вы должны арендовать минимум на %s минут(ы).",
	Rent_MaxTime = "Вы не можете арендовать более чем на %s минут(ы).",
	Rent_CantAfford = "У вас недостаточно средств для этой аренды (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} арендовал этот театр на %s.",
	Rent_ExtendNotRenting = "Вы уже должны арендовать этот театр, чтобы продлить аренду!",
	Rent_ExtendMinTime = "Вы должны продлить аренду в общей сложности минимум до %s минут(ы).",
	Rent_ExtendMaxTime = "Вы не можете арендовать дольше %s минут(ы).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} продлил аренду этого театра ещё на %s.",
	Rent_RefundNotRenting = "Вы должны арендовать этот театр, чтобы вернуть средства за аренду.",
	Rent_RefundNotEnoughTime = "Осталось недостаточно времени аренды, чтобы вернуть за неё средства.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} вернул средства за аренду этого театра.",
	Rent_Refunded = "Вам возвращено %s за %s минут(ы) аренды.",
	Rent_NotRented = "Этот театр сейчас не арендован.",
	Rent_CancelledPublic = "Аренда театра игроком {{rgb:158,37,33}}%s{{rgb:200,200,200}} была отменена админом.",
	Rent_CancelledOwner = "Ваша аренда была отменена, и вам возвращено %s за %s минут(ы) аренды.",
	Rent_CancelledAdmin = "Вы отменили аренду игрока {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Вы отменили аренду, но её владелец отключился до того, как ему могли вернуть средства.",
	Rent_ExpiredOwner = "Ваша аренда в {{rgb:158,37,33}}%s{{rgb:200,200,200}} закончилась.",
	Rent_ExpiredPublic = "Аренда этого театра закончилась!",
	Rent_VoteSkipLocked = "Владелец этого театра заблокировал голосования за пропуск.",
	Rent_VoteSkipUnlocked = "Владелец этого театра разблокировал голосования за пропуск.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Вы не можете установить фильтр игроков в театре, который не является приватным!",
	Rent_FilterNotRented = "Этот театр должен быть арендован, прежде чем вы сможете установить в нём фильтр игроков!",
	Rent_FilterNotOwner = "Вы должны быть владельцем этого театра, чтобы установить в нём фильтр игроков!",
	Rent_FilterUpdated = "Фильтр игроков обновлён.",
	Rent_FilterAdminWarn = "Предупреждение админа: Теперь вы отфильтрованы из этого театра.",
	Rent_FilterSuperWarn = "Предупреждение админа: {{rgb:158,37,33}}%s{{rgb:200,200,200}} был отфильтрован из театра, в котором находится.",
	Rent_FilteredOut = "Вы были отфильтрованы из театра.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Вы сейчас арендуете этот театр на следующие %s.",
	Rent_CurrentlyRentedBy = "Этот театр сейчас арендует {{rgb:158,37,33}}%s{{rgb:200,200,200}} на следующие %s.",
	Rent_MustBeRented = "Этот театр должен быть арендован, чтобы им можно было пользоваться.",
	Rent_AdminFilteredWarn = "Предупреждение админа: Вы отфильтрованы из этого театра.",
	Rent_AdminEnteredFiltered = "Предупреждение админа: {{rgb:158,37,33}}%s{{rgb:200,200,200}} вошёл в театр, из которого он отфильтрован.",
	Rent_NotAllowed = "Вам не разрешён вход в этот театр.",
	Rent_VoteSkipDisabled = "Извините, владелец этого театра отключил голосования за пропуск.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Вы должны находиться в театре, чтобы отменить его аренду.",
	Rent_MustBeInTheaterFilter = "Вы должны находиться в своём театре, чтобы установить его фильтр игроков.",
	Rent_MustBeInTheaterSeeFilter = "Вы должны находиться в театре, чтобы увидеть его фильтр игроков.",
	Rent_NotOwnerSeeFilter = "Вы должны владеть этим театром, чтобы увидеть его фильтр игроков.",
	Rent_MustBeInTheaterVoteLock = "Вы должны находиться в театре, чтобы заблокировать голосование за пропуск.",
	Rent_NotOwnerVoteLock = "Вы должны владеть этим театром, чтобы изменить голосование за пропуск.",
	Rent_MustBeInTheaterRent = "Вы должны находиться в театре, чтобы арендовать его!",
	Rent_MustBeInTheaterRefund = "Вы должны находиться в театре, чтобы вернуть средства за его аренду!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Арендовать театр",
	Rent_Minutes = "Минуты",
	Rent_Purchase = "Купить",
	Rent_PurchaseFor = "Купить за %s",
	Rent_ToggleVoteSkipLock = "Переключить блокировку голосования за пропуск",
	Rent_PlayerFilter = "Фильтр игроков",
	Rent_AddRentTime = "Добавить время аренды",
	Rent_RefundButton = "Вернуть аренду",
	Rent_CancelButton = "Отменить аренду",
	Rent_Remaining = "Осталось аренды",
	Rent_WhitelistMode = "Режим белого списка",
	Rent_BlacklistMode = "Режим чёрного списка",
	Rent_Apply = "Применить",
	Rent_Retrieving = "Получение...",
	Rent_Unknown = "Неизвестно",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Открыто",
	Rent_OwnerDisconnected = "Владелец отключился",
	Rent_ThumbRemaining = "Осталось аренды: %s",
}