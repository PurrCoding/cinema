-- Basic information
LANG.Name		= "Russian"	-- Native name for language
LANG.Id			= "ru"		-- Find corresponding ID in garrysmod/resource/localization
LANG.Author		= "Joker[Rus], berry"		-- Chain authors if necessary (e.g. "Sam, MacDGuy, Foohy")

-- Common
LANG.Cinema						= "CINEMA"
LANG.Volume						= "Громкость"
LANG.Voteskips					= "Пропуск"
LANG.Loading					= "Загрузка..."
LANG.Invalid					= "[НЕПРАВИЛЬНО]"
LANG.NoVideoPlaying				= "Нет видео"
LANG.Cancel						= "Отмена"
LANG.Set						= "Установить"

-- Theater Announcements
-- modules/theater/cl_init.lua
-- modules/theater/sh_commands.lua
-- modules/theater/sh_theater.lua
LANG.Theater_VideoRequestedBy 		= C("Текущее видео поставил ",ColHighlight,"%s",ColDefault,".")
LANG.Theater_InvalidRequest 		= "Неправильный запрос видео."
LANG.Theater_AlreadyQueued 			= "Выбранное видео уже есть в очереди."
LANG.Theater_ProcessingRequest 		= C("Обработка ",ColHighlight,"%s",ColDefault," запроса...")
LANG.Theater_RequestFailed 			= "Возникла проблема во время обработки выбранного видео."
LANG.Theater_Voteskipped 			= "Это видео было пропущено из-за голосования."
LANG.Theater_ForceSkipped 			= C(ColHighlight,"%s",ColDefault," выключил текущее видео.")
LANG.Theater_PlayerReset 			= C(ColHighlight,"%s",ColDefault," перезагрузил театр.")
LANG.Theater_LostOwnership 			= "Вы потеряли владения над театром, из-за выхода из театра."
LANG.Theater_NotifyOwnership 		= "Вы стали владельцем этого приватного театра."
LANG.Theater_OwnerLockedQueue 		= "Владелец театра отключил возможность вставку видео в очередь."
LANG.Theater_LockedQueue 			= C(ColHighlight,"%s",ColDefault," закрыл возможность вставки видео.")
LANG.Theater_UnlockedQueue 			= C(ColHighlight,"%s",ColDefault," открыл возможность вставки видео.")
LANG.Theater_OwnerUseOnly 			= "Только владелец театра может использовать это."
LANG.Theater_PublicVideoLength 		= "Максимальный лимит видео в публичном театре %s сек. в длину."
LANG.Theater_PlayerVoteSkipped 		= C(ColHighlight,"%s",ColDefault," проголосовал за пропуск ",ColHighlight,"(%s/%s)",ColDefault,".")
LANG.Theater_VideoAddedToQueue 		= C(ColHighlight,"%s",ColDefault," было добавлено в очередь.")

-- Warnings
-- cl_init.lua
LANG.Warning_Unsupported_Line1	= "Текущая карта не поддерживается игровым режимом Cinema"
LANG.Warning_Unsupported_Line2	= "Нажмите F1, чтобы найти официальные карты в мастерской"

-- Queue
-- modules/scoreboard/cl_queue.lua
LANG.Queue_Title				= "ОЧЕРЕДЬ"
LANG.Request_Video 				= "Поставить видео"
LANG.Vote_Skip 					= "Голосовать за пропуск"
LANG.Toggle_Fullscreen 			= "Полноэкранный режим"
LANG.Refresh_Theater			= "Перезагрузить театр"

-- Theater controls
-- modules/scoreboard/cl_admin.lua
LANG.Theater_Admin				= "АДМИН"
LANG.Theater_Owner				= "ВЛАДЕЛЕЦ"
LANG.Theater_Skip				= "Убрать видео"
LANG.Theater_Seek				= "Перемотать"
LANG.Theater_Reset				= "Перезагрузить"
LANG.Theater_ChangeName			= "Сменить имя"
LANG.Theater_QueueLock			= "Закрыть вставку видео"
LANG.Theater_SeekQuery			= "ЧЧ:ММ:СС или число в секундах (пример. 1:30:00 или 5400)"

-- Theater list
-- modules/scoreboard/cl_theaterlist.lua
LANG.TheaterList_NowShowing		= "Сейчас показывают"

-- Request Panel
-- modules/scoreboard/cl_request.lua
LANG.Request_History			= "ИСТОРИЯ"
LANG.Request_Clear				= "Очистить"
LANG.Request_DeleteTooltip		= "Удалить видео из истории"
LANG.Request_PlayCount			= "%d просмотра(ов)" -- e.g. 10 request(s)
LANG.Request_Url				= "Выбрать видео"
LANG.Request_Url_Tooltip		= "Нажмите сюда, чтобы добавить видео в очередь.\nКнопка будет красная, если ссылка не правильная."

-- Scoreboard settings panel
-- modules/scoreboard/cl_settings.lua
LANG.Settings_Title				= "НАСТРОЙКИ"
LANG.Settings_ClickActivate		= "НАЖМИТЕ, ЧТОБЫ АКТИВИРОВАТЬ МЫШКУ"
LANG.Settings_VolumeLabel		= "Громкость"
LANG.Settings_VolumeTooltip		= "Используйте +/-, чтобы увеличить/уменьшить громкость."
LANG.Settings_HDLabel			= "Проигрывать видео в HD"
LANG.Settings_HDTooltip			= "Включить воспроизведение видео в высоком качестве, если оно доступно."
LANG.Settings_HidePlayersLabel	= "Прятать игроков в театре"
LANG.Settings_HidePlayersTooltip = "В театрах игроки станут невидимые для вас."
LANG.Settings_MuteFocusLabel	= "Глушить звук в не игры"
LANG.Settings_MuteFocusTooltip	= "Отключение звука театра, когда вы вне игры (например: игра свернута)."

-- Video Services
LANG.Service_EmbedDisabled 		= "Запрещено вставлять выбранное видео."
LANG.Service_PurchasableContent = "Данное видео имеет запрещённый контент, и не может быть вставлено в очередь."
LANG.Service_StreamOffline 		= "Запрашиваемый стрим не в сети."

-- Version 1.1
LANG.TranslationsCredit = "Перевод запилили: %s"
