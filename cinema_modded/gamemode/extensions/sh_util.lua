-- Common functions that are used in Cinema.

module("util", package.seeall)

MEDIA_ERR = { -- https://developer.mozilla.org/en-US/docs/Web/API/MediaError
	[1] = "The user canceled the media.", -- MEDIA_ERR_ABORTED
	[2] = "A network error occurred while fetching the media.", -- MEDIA_ERR_NETWORK
	[3] = "An error occurred while decoding the media.", -- MEDIA_ERR_DECODE
	[4] = "The media source is not supported.", -- MEDIA_ERR_SRC_NOT_SUPPORTED
	[5] = "An unknown error occurred.", -- MEDIA_ERR_UNKOWN
}

-- Helper function for converting ISO 8601 time strings; this is the formatting
-- http://en.wikipedia.org/wiki/ISO_8601#Durations
function ISO_8601ToSeconds(str)
	local number = tonumber(str)
	if number then return number end

	str = str:lower()

	local h = str:match("(%d+)h") or 0
	local m = str:match("(%d+)m") or 0
	local s = str:match("(%d+)s") or 0
	return h * (60 * 60) + m * 60 + s
end

function SecondsToISO_8601(seconds)
	local t = string.FormattedTime( seconds )

	return (t.h and t.h .. "h" or "") .. (t.m and t.m .. "m" or "") .. (t.s and t.s .. "s" or "")
end

-- Helper function for converting HH:MM:SS time strings
local hhmmss = "(%d+):(%d+):(%d+)"
local mmss = "(%d+):(%d+)"
function ConvertTimeToSeconds(time)
	local hr, min, sec = string.match(time, hhmmss)

	-- Not in HH:MM:SS, try MM:SS
	if not hr then
		min, sec = string.match(time, mmss)
		if not min then return end -- Not in MM:SS, give up
		hr = 0
	end

	return tonumber(hr) * 3600 +
		tonumber(min) * 60 +
		tonumber(sec)
end

-- Get the value for an attribute from a html element
function ParseElementAttribute( element, attribute )
	if not element then return end
	-- Find the desired attribute
	local output = element:match( attribute .. "%s-=%s-%b\"\"" )
	if not output then return end
	-- Remove the 'attribute=' part
	output = output:gsub( attribute .. "%s-=%s-", "" )
	-- Trim the quotes around the value string
	return output:sub( 2, -2 )
end

-- Get the contents of a html element by removing tags
-- Used as fallback for when title cannot be found
function ParseElementContent( element )
	if not element then return end
	-- Trim start
	local output = element:gsub( "^%s-<%w->%s-", "" )
	-- Trim end
	return output:gsub( "%s-</%w->%s-$", "" )
end


local countrys = {
	DM="Dominica",IO="British Indian Ocean Territory",
	FM="Micronesia, Federated States of",AM="Armenia",
	JO="Jordan",CM="Cameroon",
	BM="Bermuda",FO="Faroe Islands",
	AO="Angola",DO="Dominican Republic",
	BO="Bolivia, Plurinational State of",TK="Tokelau",
	ZM="Zambia",CO="Colombia",
	TM="Turkmenistan",RS="Serbia",
	MS="Montserrat",PS="Palestine, State of",
	PM="Saint Pierre and Miquelon",SM="San Marino",
	MM="Myanmar",WS="Samoa",
	TO="Tonga",BQ="Bonaire, Sint Eustatius and Saba",
	RO="Romania",MO="Macao",
	GQ="Equatorial Guinea",SO="Somalia",
	AQ="Antarctica",BS="Bahamas",
	TW="Taiwan, Province of China",AS="American Samoa",
	MW="Malawi",IQ="Iraq",
	ZW="Zimbabwe",ES="Spain",
	GU="Guam",YE="Yemen",
	AU="Australia",IS="Iceland",
	LS="Lesotho",SZ="Swaziland",
	ZA="South Africa",LU="Luxembourg",
	AW="Aruba",NU="Niue",
	GW="Guinea-Bissau",BW="Botswana",
	VI="Virgin Islands, U.S.",BH="Bahrain",
	CW="Curaçao",PY="Paraguay",
	VE="Venezuela, Bolivarian Republic of",KY="Cayman Islands",
	VU="Vanuatu",UZ="Uzbekistan",LY="Libya",
	UY="Uruguay",KW="Kuwait",
	UM="United States Minor Outlying Islands",US="United States",
	CY="Cyprus",BY="Belarus",PH="Philippines",
	AE="United Arab Emirates",GY="Guyana",
	UA="Ukraine",BB="Barbados",UG="Uganda",
	TV="Tuvalu",TC="Turks and Caicos Islands",
	PR="Puerto Rico",GB="United Kingdom",
	PN="Pitcairn",GD="Grenada",
	TG="Togo",AD="Andorra",
	SH="Saint Helena, Ascension and Tristan da Cunha",
	CD="Congo, the Democratic Republic of the",
	TH="Thailand",TZ="Tanzania, United Republic of",
	LB="Lebanon",TJ="Tajikistan",
	AF="Afghanistan",ID="Indonesia",
	GF="French Guiana",SY="Syrian Arab Republic",
	SS="South Sudan",BF="Burkina Faso",
	CF="Central African Republic",SE="Sweden",
	KH="Cambodia",NF="Norfolk Island",
	EH="Western Sahara",SD="Sudan",
	VC="Saint Vincent and the Grenadines",MD="Moldova, Republic of",
	SR="Suriname",LK="Sri Lanka",CH="Switzerland",
	GS="South Georgia and the South Sandwich Islands",WF="Wallis and Futuna",
	TF="French Southern Territories",GH="Ghana",SB="Solomon Islands",
	SI="Slovenia",PF="French Polynesia",SK="Slovakia",
	SX="Sint Maarten (Dutch part)",BJ="Benin",IL="Israel",
	NL="Netherlands",SG="Singapore",FJ="Fiji",
	RU="Russian Federation",DJ="Djibouti",GL="Greenland",
	IN="India",AL="Albania",SC="Seychelles",
	CL="Chile",SN="Senegal",SA="Saudi Arabia",
	BL="Saint Barthélemy",HN="Honduras",BI="Burundi",
	SJ="Svalbard and Jan Mayen",GN="Guinea",MF="Saint Martin (French part)",
	LC="Saint Lucia",BN="Brunei Darussalam",CN="China",
	KN="Saint Kitts and Nevis",TL="Timor-Leste",MR="Mauritania",
	RW="Rwanda",SL="Sierra Leone",PL="Poland",ML="Mali",
	EE="Estonia",QA="Qatar",TR="Turkey",VN="Viet Nam",
	TT="Trinidad and Tobago",TN="Tunisia",GP="Guadeloupe",
	ST="Sao Tome and Principe",PT="Portugal",MT="Malta",
	KP="Korea, Democratic People's Republic of",PG="Papua New Guinea",
	BR="Brazil",JP="Japan",GG="Guernsey",
	AR="Argentina",FR="France",GR="Greece",
	SV="El Salvador",ER="Eritrea",PW="Palau",
	KR="Korea, Republic of",HR="Croatia",
	IR="Iran, Islamic Republic of",NR="Nauru",
	PK="Pakistan",LR="Liberia",HU="Hungary",
	LT="Lithuania",IT="Italy",MX="Mexico",
	NO="Norway",HT="Haiti",BV="Bouvet Island",
	CV="Cape Verde",MP="Northern Mariana Islands",BD="Bangladesh",
	MZ="Mozambique",TD="Chad",LV="Latvia",NI="Nicaragua",
	NZ="New Zealand",AT="Austria",NP="Nepal",CX="Christmas Island",
	MV="Maldives",MK="Macedonia, the Former Yugoslav Republic of",KZ="Kazakhstan",
	ME="Montenegro",MN="Mongolia",AX="Åland Islands",
	FK="Falkland Islands (Malvinas)",CA="Canada",BA="Bosnia and Herzegovina",
	BZ="Belize",CZ="Czech Republic",GA="Gabon",AZ="Azerbaijan",
	YT="Mayotte",MU="Mauritius",DZ="Algeria",MQ="Martinique",
	CC="Cocos (Keeling) Islands",LA="Lao People's Democratic Republic",MH="Marshall Islands",
	NA="Namibia",MY="Malaysia",PA="Panama",
	DE="Germany",GE="Georgia",MA="Morocco",
	NC="New Caledonia",DK="Denmark",VA="Holy See (Vatican City State)",
	BE="Belgium",BT="Bhutan",MC="Monaco",AG="Antigua and Barbuda",
	NE="Niger",IE="Ireland",BG="Bulgaria",KE="Kenya",JE="Jersey",
	CG="Congo",NG="Nigeria",GM="Gambia",KI="Kiribati",CU="Cuba",
	PE="Peru",LI="Liechtenstein",RE="Réunion",KG="Kyrgyzstan",
	VG="Virgin Islands, British",EG="Egypt",CI="Côte d'Ivoire",HK="Hong Kong",
	ET="Ethiopia",MG="Madagascar",GI="Gibraltar",FI="Finland",AI="Anguilla",
	EC="Ecuador",GT="Guatemala",OM="Oman",CK="Cook Islands",IM="Isle of Man",
	HM="Heard Island and McDonald Islands",KM="Comoros",JM="Jamaica",CR="Costa Rica"
}

function getCountryName(letter)
	return (letter and countrys[letter] and countrys[letter]) or "Unkown"
end