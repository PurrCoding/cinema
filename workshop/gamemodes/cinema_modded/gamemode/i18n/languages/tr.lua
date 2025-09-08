-- Turkish language file for Cinema gamemode
-- Converted from monolithic i18n.lua
-- Author: Arda Turkmen

return {
	-- Basic information (metadata)
	Name = "Turkish",
	Author = "Arda Turkmen",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Ses",
	Voteskips = "Gecmek icin oyla",
	Loading = "Yukleniyor...",
	Invalid = "[Bilinmiyor]",
	NoVideoPlaying = "Herhangi bir video oynamiyor",
	Cancel = "Iptal",
	Set = "Ayarla",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Suanki video su kisi tarafindan acildi {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Bilinmeyen video istegi.",
	Theater_AlreadyQueued = "Belirtilen video zaten oynatiliyor.",
	Theater_ProcessingRequest = "Su kisi tarafindan video isleniyor {{rgb:158,37,33}}%s{{rgb:200,200,200}}",
	Theater_RequestFailed = "Belirtilen video ile ilgili bir problem var.",
	Theater_Voteskipped = "Suanki video oy istegiyle gecildi.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} vidoyu gecmek icin zor kullandi.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli oyuncu sahneyi resetledi.",
	Theater_LostOwnership = "Tiyatrodan ayrildigi icin yonetmeni kaybettin.",
	Theater_NotifyOwnership = "Su anda tiyatro baskani sensin.",
	Theater_OwnerLockedQueue = "Tiyatro sahibi odayi kitledi.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli kisi odayi kitledi.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli kisi kilidi kaldirdi.",
	Theater_OwnerUseOnly = "Sadece tiyatro sahibi bunu kullanabilir.",
	Theater_PublicVideoLength = "Bu acik tiyatrodaki videolar sadece %s saniye oynatilabilir.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli kisi videoyu gecmek icin oylama baslatti {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli kisi kuyruga girdi.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Suanki harita Cinema tarafindan desteklenmiyor",
	Warning_Unsupported_Line2 = "Resmi haritayi acmak icin F1 tusuna basin",

	-- Queue interface
	Queue_Title = "KUYRUK",
	Request_Video = "Video Ac",
	Vote_Skip = "Oylama Baslat",
	Toggle_Fullscreen = "Tam ekran yap",
	Refresh_Theater = "Tiyatroyu yenile",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "SAHIP",
	Theater_Skip = "Gec",
	Theater_Seek = "Ara",
	Theater_Reset = "Yeniden baslat",
	Theater_ChangeName = "Isim degistir",
	Theater_QueueLock = "Kurugu kitle/ac",
	Theater_SeekQuery = "HH:MM:SS veya su kadar sure (e.g. 1:30:00 or 5400)",

	-- Theater list
	TheaterList_NowShowing = "SU ANDA GOSTERILIYOR",

	-- Request Panel
	Request_History = "GECMIS",
	Request_Clear = "Temizle",
	Request_DeleteTooltip = "Bu videoyu gecmisten temizle",
	Request_PlayCount = "%d talep",
	Request_Url = "URL Sec",
	Request_Url_Tooltip = "Lutfen gecerli bir URL girin.\nEger URL gecerliyse buton kirmizi yanacaktir",

	-- Scoreboard settings panel
	Settings_Title = "AYARLAR",
	Settings_ClickActivate = "MOUSEYI AKTIF ETMEK ICIN TIKLA",
	Settings_VolumeLabel = "Ses Seviyesi",
	Settings_VolumeTooltip = "Sesi yukseltmek icin +/- tuslarini kullanin.",
	Settings_HidePlayersLabel = "Tiyatrodaki oyunculari gizle",
	Settings_HidePlayersTooltip = "Tiyatro icinde oyuncularin gorunurluklerini azalt.",
	Settings_MuteFocusLabel = "Alt-tab yapildiginda sesi kapat",
	Settings_MuteFocusTooltip = "Garry's Mod kapaliyken sesi kapat (e.g. you alt-tabbed).",

	-- Video Services
	Service_EmbedDisabled = "Talep edilen videoda gomme kapalidir.",
	Service_PurchasableContent = "Talep edilen video satin alinabilir icerik icerdigi icin acilamamaktadir.",
	Service_StreamOffline = "Sectiginiz canli yayin aktif degil.",

	-- Act command (special case)

	-- Credits
	TranslationsCredit = "Ceviri %s tarafindan yapildi",

}
