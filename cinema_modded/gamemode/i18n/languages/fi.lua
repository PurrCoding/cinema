-- Suomi
-- Author: Jani

return {
	-- Basic information (metadata)
	Name = "Suomi",
	Author = "Jani",

	-- Common UI elements
	Cinema = "CINEMA",
	Volume = "Äänenvoimakkuus",
	Voteskips = "Äänestys ohittamiseen",
	Loading = "Lataa...",
	Invalid = "[VIRHEELLINEN]",
	NoVideoPlaying = "Ei videota käynnissä",
	Cancel = "Peruuta",
	Set = "Valitse",

	-- Theater Announcements
	Theater_VideoRequestedBy = "Tämänhetkistä videota on ehdottanut {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Theater_InvalidRequest = "Virheellinen videopyyntö.",
	Theater_AlreadyQueued = "Pyydetty video on jo jonossa.",
	Theater_ProcessingRequest = "Käsitellään {{rgb:158,37,33}}%s{{rgb:200,200,200}} pyyntöä...",
	Theater_RequestFailed = "Pyynnetyn videon käsittelyssä ilmeni ongelma.",
	Theater_Voteskipped = "Tämänhetkinen video on äänestetty ohitettavaksi.",
	Theater_ForceSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on pakottanut nykyisen videon ohitettavaksi.",
	Theater_PlayerReset = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on käynnistänyt teatterin uudelleen.",
	Theater_LostOwnership = "Olet menettänyt teatterin omistajuuden lähtemisen vuoksi.",
	Theater_NotifyOwnership = "Olet nyt tämän yksityisen teatterin omistaja.",
	Theater_OwnerLockedQueue = "Teatterin omistaja on lukinnut videojonon.",
	Theater_LockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on lukinnut videojonon.",
	Theater_UnlockedQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on avannut teatterin videojonon.",
	Theater_OwnerUseOnly = "Vain teatterin omistaja voi käyttää tuota.",
	Theater_PublicVideoLength = "Julkisen teatterin videopyynnöt ovat rajoitettu %s sekunnin pituuteen.",
	Theater_PlayerVoteSkipped = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on äänestänyt ohittamista {{rgb:158,37,33}}(%s/%s){{rgb:200,200,200}}.",
	Theater_VideoAddedToQueue = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on lisätty videojonoon.",

	-- Warning messages
	Warning_Unsupported_Line1 = "Nykyinen kartta ei tue Cinema-pelimuotoa.",
	Warning_Unsupported_Line2 = "Paina F1 avataksesi virallisen kartan workshopissa.",
	Dependency_Missing_Line1 = "Hups! Sinulta puuttuu jotain...",
	Dependency_Missing_Line2 = "Paina F4 avataksesi ohjevideon.",

	-- Queue interface
	Queue_Title = "VIDEOJONO",
	Request_Video = "Tee videopyyntö",
	Vote_Skip = "Äänestä ohittamista",
	Toggle_Fullscreen = "Vaihda kokoruututilaan",
	Refresh_Theater = "Lataa teatteri uudelleen",

	-- Theater controls
	Theater_Admin = "ADMIN",
	Theater_Owner = "OMISTAJA",
	Theater_Skip = "Ohita",
	Theater_Seek = "Siirry kohtaan",
	Theater_Reset = "Käynnistä uudelleen",
	Theater_ChangeName = "Vaihda nimi",
	Theater_QueueLock = "Videojonon lukko on/off",
	Theater_SeekQuery = "HH:MM:SS tai sekunnit numeroina (esim. 1:30:00 tai 5400)",
	Theater_Pause = "Keskeytä",
	Theater_Resume = "Jatka",
	Theater_PlayerPaused = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} keskeytti videon.",
	Theater_PlayerResumed = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} jatkoi videota.",

	-- Theater list
	TheaterList_NowShowing = "NYT TOISTOSSA",

	-- Request Panel
	Request_History = "HISTORIA",
	Request_Clear = "Tyhjennä",
	Request_DeleteTooltip = "Poista video historiasta",
	Request_PlayCount = "%d pyyntö(ä)",
	Request_Url = "Pyydä URL:ia toistettavaksi",
	Request_Url_Tooltip = "Paina pyytääksesi kelvollista URL:ia toistettavaksi.\nPainike on punainen, jos URL on kelvollinen.",
	Request_Filter_AllServices = "Kaikki palvelut",
	Request_Filter_SortBy_LastRequest = "Viimeisin pyyntö",
	Request_Filter_SortBy_Alphabet = "Aakkosjärjestyksessä",
	Request_Filter_SortBy_Duration = "Kesto",
	Request_Filter_SortBy_RequestCount = "Pyyntöjen määrä",
	Request_Paginator_ResultCount = "%s tulosta",
	Request_Paginator_PageOf = "Sivu %d / %d",

	-- Scoreboard settings panel
	Settings_Title = "ASETUKSET",
	Settings_ClickActivate = "KLIKKAA AKTIVOIDAKSESI HIIRI",
	Settings_VolumeLabel = "Äänenvoimakkuus",
	Settings_VolumeTooltip = "Käytä +/- näppäimiä nostaaksesi/pienentääksesi äänenvoimakkuutta.",
	Settings_HidePlayersLabel = "Älä näytä pelaajia teatterissa",
	Settings_HidePlayersTooltip = "Vähennä pelaajien näkyvyyttä teattereissa.",
	Settings_MuteFocusLabel = "Mykistä audio kun siirryt toiseen ohjelmaan(Alt+Tab)",
	Settings_MuteFocusTooltip = "Mykistä teatterin audio kun Garry's Mod ei ole päällimmäisenä.",
	Settings_SmoothVideoLabel = "Sujuva videon toisto",
	Settings_SmoothVideoTooltip = "Tekee joistakin videoista sujuvampia FPS:n kustannuksella.",

	-- Video Services
	Service_EmbedDisabled = "Pyydetty video ei ole upotettavissa.",
	Service_PurchasableContent = "Pyydetty video on ostettavaa materiaalia eikä ole toistettavissa.",
	Service_StreamOffline = "Pyydetty videostreami on offline.",

	-- Act command (special case)
	ActCommand = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} %ss",

	-- Credits
	TranslationsCredit = "Käännöksen teki %s",

	-- Theater Rentals: time & currency units (for Duration / currency markers)
	Unit_Hour    = "%s tunti",
	Unit_Hours   = "%s tuntia",
	Unit_Minute  = "%s minuutti",
	Unit_Minutes = "%s minuuttia",
	Unit_Second  = "%s sekunti",
	Unit_Seconds = "%s sekuntia",
	Currency_Points = "%s pistettä",
	Currency_DonatorPoints = "%s lahjoittajapistettä",

	-- Theater Rentals: rent lifecycle
	Rent_NotPrivate = "Tämä teatteri ei ole yksityinen eikä sitä voi vuokrata!",
	Rent_AlreadyRentedBy = "Tätä teatteria vuokraa jo {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_AlreadyRentingOther = "Vuokraat jo teatteria {{rgb:158,37,33}}%s{{rgb:200,200,200}}.",
	Rent_MinTime = "Sinun on vuokrattava vähintään %s minuutti(a).",
	Rent_MaxTime = "Et voi vuokrata yli %s minuutti(a).",
	Rent_CantAfford = "Sinulla ei ole varaa tähän vuokraan (%s)!",
	Rent_HasRented = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on vuokrannut tämän teatterin ajaksi %s.",
	Rent_ExtendNotRenting = "Sinun on jo vuokrattava tätä teatteria jatkaaksesi vuokraasi!",
	Rent_ExtendMinTime = "Sinun on jatkettava vuokraa yhteensä vähintään %s minuutti(in).",
	Rent_ExtendMaxTime = "Et voi vuokrata yli %s minuutti(a).",
	Rent_HasExtended = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on jatkanut tämän teatterin vuokraansa vielä %s.",
	Rent_RefundNotRenting = "Sinun on vuokrattava tätä teatteria hyvittääksesi sen vuokran.",
	Rent_RefundNotEnoughTime = "Vuokrassa ei ole tarpeeksi aikaa jäljellä sen hyvittämiseksi.",
	Rent_HasRefunded = "{{rgb:158,37,33}}%s{{rgb:200,200,200}} on hyvittänyt tämän teatterin vuokransa.",
	Rent_Refunded = "Sinulle hyvitettiin %s vuokrasta, joka kesti %s minuutti(a).",
	Rent_NotRented = "Tätä teatteria ei tällä hetkellä vuokrata.",
	Rent_CancelledPublic = "Admin peruutti pelaajan {{rgb:158,37,33}}%s{{rgb:200,200,200}} vuokran tästä teatterista.",
	Rent_CancelledOwner = "Vuokrasi peruutettiin ja sinulle hyvitettiin %s vuokrasta, joka kesti %s minuutti(a).",
	Rent_CancelledAdmin = "Peruutit pelaajan {{rgb:158,37,33}}%s{{rgb:200,200,200}} vuokran.",
	Rent_CancelledAdminUnknown = "Peruutit vuokran, mutta sen omistaja katkaisi yhteyden ennen kuin hänelle voitiin hyvittää.",
	Rent_ExpiredOwner = "Vuokrasi teatterissa {{rgb:158,37,33}}%s{{rgb:200,200,200}} on päättynyt.",
	Rent_ExpiredPublic = "Tämän teatterin vuokra on päättynyt!",
	Rent_VoteSkipLocked = "Tämän teatterin omistaja on lukinnut ohitusäänestykset.",
	Rent_VoteSkipUnlocked = "Tämän teatterin omistaja on avannut ohitusäänestykset.",

	-- Theater Rentals: player filter
	Rent_FilterNotPrivate = "Et voi asettaa pelaajasuodatinta teatteriin, joka ei ole yksityinen!",
	Rent_FilterNotRented = "Tämä teatteri on vuokrattava ennen kuin voit asettaa siihen pelaajasuodattimen!",
	Rent_FilterNotOwner = "Sinun on oltava tämän teatterin omistaja asettaaksesi siihen pelaajasuodattimen!",
	Rent_FilterUpdated = "Pelaajasuodatin on päivitetty.",
	Rent_FilterAdminWarn = "Admin-varoitus: Sinut on nyt suodatettu pois tästä teatterista.",
	Rent_FilterSuperWarn = "Admin-varoitus: {{rgb:158,37,33}}%s{{rgb:200,200,200}} suodatettiin pois teatterista, jossa hän on.",
	Rent_FilteredOut = "Sinut on suodatettu pois teatterista.",

	-- Theater Rentals: hooks
	Rent_CurrentlyRentingSelf = "Vuokraat tällä hetkellä tätä teatteria seuraavat %s.",
	Rent_CurrentlyRentedBy = "Tätä teatteria vuokraa tällä hetkellä {{rgb:158,37,33}}%s{{rgb:200,200,200}} seuraavat %s.",
	Rent_MustBeRented = "Tämä teatteri on vuokrattava, jotta sitä voidaan käyttää.",
	Rent_AdminFilteredWarn = "Admin-varoitus: Sinut on suodatettu pois tästä teatterista.",
	Rent_AdminEnteredFiltered = "Admin-varoitus: {{rgb:158,37,33}}%s{{rgb:200,200,200}} astui teatteriin, josta hänet on suodatettu pois.",
	Rent_NotAllowed = "Sinulla ei ole pääsyä tähän teatteriin.",
	Rent_VoteSkipDisabled = "Valitettavasti tämän teatterin omistaja on poistanut ohitusäänestykset käytöstä.",

	-- Theater Rentals: net validation
	Rent_MustBeInTheaterCancel = "Sinun on oltava teatterissa peruuttaaksesi sen vuokran.",
	Rent_MustBeInTheaterFilter = "Sinun on oltava teatterissasi asettaaksesi sen pelaajasuodattimen.",
	Rent_MustBeInTheaterSeeFilter = "Sinun on oltava teatterissa nähdäksesi sen pelaajasuodattimen.",
	Rent_NotOwnerSeeFilter = "Sinun on omistettava tämä teatteri nähdäksesi sen pelaajasuodattimen.",
	Rent_MustBeInTheaterVoteLock = "Sinun on oltava teatterissa lukitaksesi ohitusäänestyksen.",
	Rent_NotOwnerVoteLock = "Sinun on omistettava tämä teatteri muokataksesi ohitusäänestystä.",
	Rent_MustBeInTheaterRent = "Sinun on oltava teatterissa vuokrataksesi sen!",
	Rent_MustBeInTheaterRefund = "Sinun on oltava teatterissa hyvittääksesi sen vuokran!",

	-- Theater Rentals: UI
	Rent_RentTheater = "Vuokraa teatteri",
	Rent_Minutes = "Minuuttia",
	Rent_Purchase = "Osta",
	Rent_PurchaseFor = "Osta hintaan %s",
	Rent_ToggleVoteSkipLock = "Vaihda ohitusäänestyksen lukko",
	Rent_PlayerFilter = "Pelaajasuodatin",
	Rent_AddRentTime = "Lisää vuokra-aikaa",
	Rent_RefundButton = "Hyvitä vuokra",
	Rent_CancelButton = "Peruuta vuokra",
	Rent_Remaining = "Vuokraa jäljellä",
	Rent_WhitelistMode = "Sallittujen lista -tila",
	Rent_BlacklistMode = "Estettyjen lista -tila",
	Rent_Apply = "Käytä",
	Rent_Retrieving = "Haetaan...",
	Rent_Unknown = "Tuntematon",

	-- Theater Rentals: thumbnail overlay (theater_thumbnail entity)
	Rent_Open = "Avoin",
	Rent_OwnerDisconnected = "Omistaja katkaisi yhteyden",
	Rent_ThumbRemaining = "Vuokraa jäljellä: %s",
}