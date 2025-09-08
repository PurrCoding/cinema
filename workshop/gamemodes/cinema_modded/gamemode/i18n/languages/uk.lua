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

	-- Theater list
	TheaterList_NowShowing = "Зараз Показують",

	-- Request Panel
	Request_History = "Історія",
	Request_Clear = "Очистити",
	Request_DeleteTooltip = "Видалити відео з історії",
	Request_PlayCount = "%d переглядів(да)",
	Request_Url = "Вибрати Відео",
	Request_Url_Tooltip = "Натисніть сюди щоб ​​додати відео в чергу.\nКнопка буде червона якщо ссилка не правильна.",

	-- Scoreboard settings panel
	Settings_Title = "Налаштування",
	Settings_ClickActivate = "Клік щоб активувати мишку",
	Settings_VolumeLabel = "Гучність",
	Settings_VolumeTooltip = "Використовуйте +/- кнопки щоб ​​збільшити / зменшити гучність.",
	Settings_HidePlayersLabel = "Ховати гравців у театрі",
	Settings_HidePlayersTooltip = "У театрах гравці стануть невидимі для вас.",
	Settings_MuteFocusLabel = "Глушити звук у не ігри",
	Settings_MuteFocusTooltip = "Відключення звуку театру коли ви в не ігри (наприклад. гра згорнута).",

	-- Video Services
	Service_EmbedDisabled = "Заборонено вставляти вбранне відео.",
	Service_PurchasableContent = "Дане відео має заборонений контент, і не може бути поставлено в чергу.",
	Service_StreamOffline = "Запитуваний стрім оффлайн.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Переклад виконав %s",

}
