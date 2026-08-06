-- Ukrainian language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Joker[Rus]

return {
	-- Basic information (metadata)
	Name = "Ukrainian",
	Author = "Joker[Rus]",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Гучність",
	Voteskips = "Пропуск",
	Loading = "Завантаження...",
	Invalid = "[НЕПРАВИЛЬНО]",
	NoVideoPlaying = "Немае Відео",
	Cancel = "Відміна",
	Set = "Встановити",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Це відео поставив {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Неправильний запит відео.",
	Theater_AlreadyQueued = "Выбранне відео вже е в черзі.",
	Theater_ProcessingRequest = "Обробка {{rgb:158,37,33}}%s{{rgb:200,200,200}} запита...",
	Theater_RequestFailed = "Виникла проблема під час обробки выбранного видео.",
	Theater_Voteskipped = "Це відео було пропущено із за голосування.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} вимкнув це відео.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} перезавантажив театр.",
	Theater_LostOwnership = "Ви втратили володіння над театром із за виходу з театру.",
	Theater_NotifyOwnership = "Ви стали власником цього приватного театру.",
	Theater_OwnerLockedQueue = "Власник театру відключив можливість вставку відео в чергу.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} закрив можливість вставки відео.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} відкрив возможность вставки видео.",
	Theater_OwnerUseOnly = "Тільки власник театру може використовувати це.",
	Theater_PublicVideoLength = "Максимальний ліміт відео в Публічному Театрі %s секунд(и) в довжину.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} проголосував за пропуск {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} було додано в чергу.",

	-- Warning messages
	Warning_Unsupported_Line1 = "ця карта не підтримується ігровим режимом Cinema",
	Warning_Unsupported_Line2 = "Натисніть F1 щоб знайти офіційні карти в ВоркШопе",
	Dependency_Missing_Line1 = "Ой! Вам чогось не вистачає...",
	Dependency_Missing_Line2 = "Натисніть F4, щоб відкрити відео з інструкціями.",

	-- Queue interface
	Queue_Title = "Черга",
	Request_Video = "Встановити Відео",
	Vote_Skip = "Голосувати За Пропуск",
	Toggle_Fullscreen = "Повноекранний Режим",
	Refresh_Theater = "Перезавантажити Театр",

	-- Theater controls
	Theater_Admin = "Адмін",
	Theater_Owner = "Власник",
	Theater_Skip = "Прибрати Відео",
	Theater_Seek = "Перемотати",
	Theater_Reset = "Перезавантажити",
	Theater_ChangeName = "змінити ім'я",
	Theater_QueueLock = "Закрити Вставку Відео",
	Theater_SeekQuery = "ЧЧ:ММ:СС або число в секундах (приклад. 1:30:00 або 5400)",
	Theater_Pause = "Пауза",
	Theater_Resume = "Продовжити",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} поставив(ла) відео на паузу.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} відновив(ла) відтворення відео.",

	-- Theater list
	TheaterList_NowShowing = "Зараз Показують",

	-- Request Panel
	Request_History = "Історія",
	Request_Clear = "Очистити",
	Request_DeleteTooltip = "Видалити відео з історії",
	Request_PlayCount = "%d переглядів(да)",
	Request_Url = "Вибрати Відео",
	Request_Url_Tooltip = "Натисніть сюди щоб ​​додати відео в чергу.\nКнопка буде червона якщо ссилка не правильна.",
	Request_Filter_AllServices = "Усі сервіси",
	Request_Filter_SortBy_LastRequest = "Останній запит",
	Request_Filter_SortBy_Alphabet = "За алфавітом",
	Request_Filter_SortBy_Duration = "Тривалість",
	Request_Filter_SortBy_RequestCount = "Кількість запитів",
	Request_Paginator_ResultCount = "%s результатів",
	Request_Paginator_PageOf = "Сторінка %d з %d",

	-- Scoreboard settings panel
	Settings_Title = "Налаштування",
	Settings_ClickActivate = "Клік щоб активувати мишку",
	Settings_VolumeLabel = "Гучність",
	Settings_VolumeTooltip = "Використовуйте +/- кнопки щоб ​​збільшити / зменшити гучність.",
	Settings_HidePlayersLabel = "Ховати гравців у театрі",
	Settings_HidePlayersTooltip = "У театрах гравці стануть невидимі для вас.",
	Settings_MuteFocusLabel = "Глушити звук у не ігри",
	Settings_MuteFocusTooltip = "Відключення звуку театру коли ви в не ігри (наприклад. гра згорнута).",
	Settings_SmoothVideoLabel = "Плавне відтворення відео",
	Settings_SmoothVideoTooltip = "Робить деякі відео плавнішими за рахунок FPS.",

	-- Video Services
	Service_EmbedDisabled = "Заборонено вставляти вбранне відео.",
	Service_PurchasableContent = "Дане відео має заборонений контент, і не може бути поставлено в чергу.",
	Service_StreamOffline = "Запитуваний стрім оффлайн.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Переклад виконав %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s година",
	Unit_Hours   = "%s годин",
	Unit_Minute  = "%s хвилина",
	Unit_Minutes = "%s хвилин",
	Unit_Second  = "%s секунда",
	Unit_Seconds = "%s секунд",
	Currency_Points = "%s Балів",
	Currency_DonatorPoints = "%s Донат-Балів",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Цей театр не приватний і не може бути орендований!",
	Rent_AlreadyRentedBy = "Цей театр вже орендує {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Ви вже орендуєте {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Ви повинні орендувати щонайменше на %s хвилин(и).",
	Rent_MaxTime = "Ви не можете орендувати більш ніж на %s хвилин(и).",
	Rent_CantAfford = "Ви не можете дозволити собі цю оренду (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} орендував цей театр на %s.",
	Rent_ExtendNotRenting = "Ви вже повинні орендувати цей театр, щоб продовжити оренду!",
	Rent_ExtendMinTime = "Ви повинні продовжити оренду щонайменше до %s хвилин(и) загалом.",
	Rent_ExtendMaxTime = "Ви не можете орендувати понад %s хвилин(и).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} продовжив оренду цього театру ще на %s.",
	Rent_RefundNotRenting = "Ви повинні орендувати цей театр, щоб повернути кошти за оренду.",
	Rent_RefundNotEnoughTime = "Залишилося недостатньо часу оренди, щоб повернути кошти за неї.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} повернув кошти за оренду цього театру.",
	Rent_Refunded = "Вам повернуто %s за %s хвилин(и) оренди.",
	Rent_NotRented = "Цей театр наразі не орендований.",
	Rent_CancelledPublic = "Оренду цього театру гравцем {{rgb:158,37,33}}%s{{rgb:200,200,200}} було скасовано адміністратором.",
	Rent_CancelledOwner = "Вашу оренду було скасовано, і вам повернуто %s за %s хвилин(и) оренди.",
	Rent_CancelledAdmin = "Ви скасували оренду гравця {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_CancelledAdminUnknown = "Ви скасували оренду, але її власник відключився до того, як йому змогли повернути кошти.",
	Rent_ExpiredOwner = "Ваша оренда в {{rgb:158,37,33}}%s{{rgb:200,200,200}} закінчилася.",
	Rent_ExpiredPublic = "Оренда цього театру закінчилася!",
	Rent_VoteSkipLocked = "Власник цього театру заблокував голосування за пропуск.",
	Rent_VoteSkipUnlocked = "Власник цього театру розблокував голосування за пропуск.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Ви не можете встановити фільтр гравців у театрі, який не є приватним!",
	Rent_FilterNotRented = "Цей театр повинен бути орендований, перш ніж ви зможете встановити в ньому фільтр гравців!",
	Rent_FilterNotOwner = "Ви повинні бути власником цього театру, щоб встановити в ньому фільтр гравців!",
	Rent_FilterUpdated = "Фільтр гравців оновлено.",
	Rent_FilterAdminWarn = "Попередження для адміністратора: Тепер ви відфільтровані з цього театру.",
	Rent_FilterSuperWarn = "Попередження для адміністратора: {{rgb:158,37,33}}%s{{rgb:200,200,200}} було відфільтровано з театру, в якому він перебуває.",
	Rent_FilteredOut = "Вас було відфільтровано з театру.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Ви наразі орендуєте цей театр на наступні %s.",
	Rent_CurrentlyRentedBy = "Цей театр наразі орендує {{rgb:158,37,33}}%s{{rgb:200,200,200}} на наступні %s.",
	Rent_MustBeRented = "Цей театр повинен бути орендований, щоб його можна було використовувати.",
	Rent_AdminFilteredWarn = "Попередження для адміністратора: Ви відфільтровані з цього театру.",
	Rent_AdminEnteredFiltered = "Попередження для адміністратора: {{rgb:158,37,33}}%s{{rgb:200,200,200}} увійшов до театру, з якого його відфільтровано.",
	Rent_NotAllowed = "Вам не дозволено перебувати в цьому театрі.",
	Rent_VoteSkipDisabled = "Вибачте, власник цього театру вимкнув голосування за пропуск.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Ви повинні перебувати в театрі, щоб скасувати його оренду.",
	Rent_MustBeInTheaterFilter = "Ви повинні перебувати у своєму театрі, щоб встановити його фільтр гравців.",
	Rent_MustBeInTheaterSeeFilter = "Ви повинні перебувати в театрі, щоб побачити його фільтр гравців.",
	Rent_NotOwnerSeeFilter = "Ви повинні володіти цим театром, щоб побачити його фільтр гравців.",
	Rent_MustBeInTheaterVoteLock = "Ви повинні перебувати в театрі, щоб заблокувати голосування за пропуск.",
	Rent_NotOwnerVoteLock = "Ви повинні володіти цим театром, щоб змінити голосування за пропуск.",
	Rent_MustBeInTheaterRent = "Ви повинні перебувати в театрі, щоб орендувати його!",
	Rent_MustBeInTheaterRefund = "Ви повинні перебувати в театрі, щоб повернути кошти за його оренду!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Орендувати театр",
	Rent_Minutes = "Хвилини",
	Rent_Purchase = "Придбати",
	Rent_PurchaseFor = "Придбати за %s",
	Rent_ToggleVoteSkipLock = "Перемкнути блокування голосування за пропуск",
	Rent_PlayerFilter = "Фільтр гравців",
	Rent_AddRentTime = "Додати час оренди",
	Rent_RefundButton = "Повернути кошти за оренду",
	Rent_CancelButton = "Скасувати оренду",
	Rent_Remaining = "Залишилося оренди",
	Rent_WhitelistMode = "Режим білого списку",
	Rent_BlacklistMode = "Режим чорного списку",
	Rent_Apply = "Застосувати",
	Rent_Retrieving = "Отримання...",
	Rent_Unknown = "Невідомо",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Відкрито",
	Rent_OwnerDisconnected = "Власник відключився",
	Rent_ThumbRemaining = "Залишилося оренди: %s",
}