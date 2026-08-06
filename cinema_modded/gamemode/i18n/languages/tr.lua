-- Turkish
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
	Dependency_Missing_Line1 = "Hoppala! Bir seyler eksik...",
	Dependency_Missing_Line2 = "Talimat videosunu acmak icin F4 tusuna basin.",

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
	Theater_Pause = "Duraklat",
	Theater_Resume = "Devam Et",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} videoyu duraklattı.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} videoyu devam ettirdi.",

	-- Theater list
	TheaterList_NowShowing = "SU ANDA GOSTERILIYOR",

	-- Request Panel
	Request_History = "GECMIS",
	Request_Clear = "Temizle",
	Request_DeleteTooltip = "Bu videoyu gecmisten temizle",
	Request_PlayCount = "%d talep",
	Request_Url = "URL Sec",
	Request_Url_Tooltip = "Lutfen gecerli bir URL girin.\nEger URL gecerliyse buton kirmizi yanacaktir",
	Request_Filter_AllServices = "Tum servisler",
	Request_Filter_SortBy_LastRequest = "Son talep",
	Request_Filter_SortBy_Alphabet = "Alfabetik",
	Request_Filter_SortBy_Duration = "Sure",
	Request_Filter_SortBy_RequestCount = "Talep sayisi",
	Request_Paginator_ResultCount = "%s sonuc",
	Request_Paginator_PageOf = "Sayfa %d / %d",

	-- Scoreboard settings panel
	Settings_Title = "AYARLAR",
	Settings_ClickActivate = "MOUSEYI AKTIF ETMEK ICIN TIKLA",
	Settings_VolumeLabel = "Ses Seviyesi",
	Settings_VolumeTooltip = "Sesi yukseltmek icin +/- tuslarini kullanin.",
	Settings_HidePlayersLabel = "Tiyatrodaki oyunculari gizle",
	Settings_HidePlayersTooltip = "Tiyatro icinde oyuncularin gorunurluklerini azalt.",
	Settings_MuteFocusLabel = "Alt-tab yapildiginda sesi kapat",
	Settings_MuteFocusTooltip = "Garry's Mod kapaliyken sesi kapat (e.g. you alt-tabbed).",
	Settings_SmoothVideoLabel = "Akici video oynatimi",
	Settings_SmoothVideoTooltip = "Bazi videolari FPS pahasina daha akici hale getirir.",

	-- Video Services
	Service_EmbedDisabled = "Talep edilen videoda gomme kapalidir.",
	Service_PurchasableContent = "Talep edilen video satin alinabilir icerik icerdigi icin acilamamaktadir.",
	Service_StreamOffline = "Sectiginiz canli yayin aktif degil.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Ceviri %s tarafindan yapildi",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s saat",
	Unit_Hours   = "%s saat",
	Unit_Minute  = "%s dakika",
	Unit_Minutes = "%s dakika",
	Unit_Second  = "%s saniye",
	Unit_Seconds = "%s saniye",
	Currency_Points = "%s Puan",
	Currency_DonatorPoints = "%s Bagisci Puani",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Bu tiyatro ozel degil ve kiralanamaz!",
	Rent_AlreadyRentedBy = "Bu tiyatro su anda {{rgb:158,37,33}}%s{{rgb:200,200,200}} tarafindan kiralaniyor.",
	Rent_AlreadyRentingOther = "Zaten {{rgb:158,37,33}}%s{{rgb:200,200,200}} kiraliyorsunuz.",
	Rent_MinTime = "En az %s dakika kiralamalisiniz.",
	Rent_MaxTime = "En fazla %s dakika kiralayabilirsiniz.",
	Rent_CantAfford = "Bu kirayi karsilayamazsiniz (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} bu tiyatroyu %s sureligine kiraladi.",
	Rent_ExtendNotRenting = "Kiranizi uzatmak icin bu tiyatroyu zaten kiraliyor olmalisiniz!",
	Rent_ExtendMinTime = "Kirayi toplamda en az %s dakika olacak sekilde uzatmalisiniz.",
	Rent_ExtendMaxTime = "%s dakikanin otesine kiralayamazsiniz.",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} bu tiyatro kirasini %s daha uzatti.",
	Rent_RefundNotRenting = "Kirayi iade etmek icin bu tiyatroyu kiraliyor olmalisiniz.",
	Rent_RefundNotEnoughTime = "Kirayi iade etmek icin yeterli sure kalmadi.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} bu tiyatro kirasini iade etti.",
	Rent_Refunded = "%s dakikalik kira icin size %s iade edildi.",
	Rent_NotRented = "Bu tiyatro su anda kiralanmiyor.",
	Rent_CancelledPublic = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli kisinin bu tiyatro kirasi bir admin tarafindan iptal edildi.",
	Rent_CancelledOwner = "Kiraniz iptal edildi ve %s dakikalik kira icin size %s iade edildi.",
	Rent_CancelledAdmin = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} adli kisinin kirasini iptal ettiniz.",
	Rent_CancelledAdminUnknown = "Kirayi iptal ettiniz, ancak sahibi iade edilemeden once baglantiyi kesti.",
	Rent_ExpiredOwner = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} icindeki kiraniz sona erdi.",
	Rent_ExpiredPublic = "Bu tiyatronun kirasi sona erdi!",
	Rent_VoteSkipLocked = "Bu tiyatronun sahibi gecme oylamalarini kitledi.",
	Rent_VoteSkipUnlocked = "Bu tiyatronun sahibi gecme oylamalarinin kilidini acti.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Ozel olmayan bir tiyatroda oyuncu filtresi ayarlayamazsiniz!",
	Rent_FilterNotRented = "Oyuncu filtresi ayarlayabilmeniz icin bu tiyatronun once kiralanmasi gerekir!",
	Rent_FilterNotOwner = "Bir oyuncu filtresi ayarlamak icin bu tiyatronun sahibi olmalisiniz!",
	Rent_FilterUpdated = "Oyuncu filtresi guncellendi.",
	Rent_FilterAdminWarn = "Admin Uyarisi: Artik bu tiyatrodan filtrelendiniz.",
	Rent_FilterSuperWarn = "Admin Uyarisi: {{rgb:158,37,33}}%s{{rgb:200,200,200}} icinde bulundugu bir tiyatrodan filtrelendi.",
	Rent_FilteredOut = "Tiyatrodan filtrelendiniz.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Su anda bu tiyatroyu onumuzdeki %s sureligine kiraliyorsunuz.",
	Rent_CurrentlyRentedBy = "Bu tiyatro su anda {{rgb:158,37,33}}%s{{rgb:200,200,200}} tarafindan onumuzdeki %s sureligine kiralaniyor.",
	Rent_MustBeRented = "Bu tiyatronun kullanilabilmesi icin kiralanmasi gerekir.",
	Rent_AdminFilteredWarn = "Admin Uyarisi: Bu tiyatrodan filtrelendiniz.",
	Rent_AdminEnteredFiltered = "Admin Uyarisi: {{rgb:158,37,33}}%s{{rgb:200,200,200}} filtrelendigi bir tiyatroya girdi.",
	Rent_NotAllowed = "Bu tiyatroya girmenize izin verilmiyor.",
	Rent_VoteSkipDisabled = "Uzgunuz, bu tiyatronun sahibi gecme oylamalarini devre disi birakti.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Kirasini iptal etmek icin bir tiyatroda olmalisiniz.",
	Rent_MustBeInTheaterFilter = "Oyuncu filtresini ayarlamak icin kendi tiyatronuzda olmalisiniz.",
	Rent_MustBeInTheaterSeeFilter = "Oyuncu filtresini gormek icin bir tiyatroda olmalisiniz.",
	Rent_NotOwnerSeeFilter = "Oyuncu filtresini gormek icin bu tiyatronun sahibi olmalisiniz.",
	Rent_MustBeInTheaterVoteLock = "Gecme oylamasini kitlemek icin bir tiyatroda olmalisiniz.",
	Rent_NotOwnerVoteLock = "Gecme oylamasini degistirmek icin bu tiyatronun sahibi olmalisiniz.",
	Rent_MustBeInTheaterRent = "Kiralamak icin bir tiyatroda olmalisiniz!",
	Rent_MustBeInTheaterRefund = "Kirasini iade etmek icin bir tiyatroda olmalisiniz!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Tiyatro Kirala",
	Rent_Minutes = "Dakika",
	Rent_Purchase = "Satin Al",
	Rent_PurchaseFor = "%s karsiliginda satin al",
	Rent_ToggleVoteSkipLock = "Gecme Oylamasi Kilidini Ac/Kapat",
	Rent_PlayerFilter = "Oyuncu Filtresi",
	Rent_AddRentTime = "Kira Suresi Ekle",
	Rent_RefundButton = "Kirayi Iade Et",
	Rent_CancelButton = "Kirayi Iptal Et",
	Rent_Remaining = "Kalan Kira",
	Rent_WhitelistMode = "Beyaz Liste Modu",
	Rent_BlacklistMode = "Kara Liste Modu",
	Rent_Apply = "Uygula",
	Rent_Retrieving = "Aliniyor...",
	Rent_Unknown = "Bilinmiyor",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Acik",
	Rent_OwnerDisconnected = "Sahip Baglantiyi Kesti",
	Rent_ThumbRemaining = "Kalan Kira: %s",
}