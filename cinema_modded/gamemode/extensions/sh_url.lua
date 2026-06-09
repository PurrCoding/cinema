-----------------------------------------------------------------------------
-- URI Parsing, Composition and Relative URL Resolution
--
-- Originally based on LuaSocket toolkit by Diego Nehab
-- RCS ID: $Id: url.lua,v 1.38 2006/04/03 04:45:42 diego Exp $
--
-- Extended for Media Player:
-- - Structured query/fragment parsing with URL decoding
-- - Security: protocol whitelisting, XSS prevention, path traversal blocking
-- - HTML entity encoding/decoding with Unicode support
--
-- https://github.com/PurrCoding/cinema
-----------------------------------------------------------------------------

local isstring, istable, tostring, tonumber = isstring, istable, tostring, tonumber
local pairs, ipairs = pairs, ipairs
local string_gsub = string.gsub
local string_format = string.format
local string_byte = string.byte
local string_char = string.char
local string_lower = string.lower
local string_match = string.match
local string_gmatch = string.gmatch
local string_sub = string.sub
local string_GetFileFromFilename = string.GetFileFromFilename
local string_GetExtensionFromFilename = string.GetExtensionFromFilename
local table_insert = table.insert
local table_concat = table.concat
module("url")

-----------------------------------------------------------------------------
-- Security limits
-----------------------------------------------------------------------------
local ALLOWED_PROTOCOLS = {
	["http"] = true,
	["https"] = true
}

local MAX_URL_LENGTH = 2048
local MAX_PARAM_LENGTH = 1024
local MAX_PATH_DEPTH = 25

-----------------------------------------------------------------------------
-- HTML entity table
-----------------------------------------------------------------------------
local entities = {
	-- Core (& must be encoded first / decoded last — see htmlentities / htmlentities_decode)
	['&'] = '&amp;',
	[' ']='&nbsp;',   ['"']='&quot;',   ["'"]='&#39;',    ['<']='&lt;',     ['>']='&gt;',

	-- Latin-1 Supplement (U+00A1–U+00FF)
	['¡']='&iexcl;',  ['¢']='&cent;',   ['£']='&pound;',  ['¤']='&curren;', ['¥']='&yen;',    ['¦']='&brvbar;',
	['§']='&sect;',   ['¨']='&uml;',    ['©']='&copy;',   ['ª']='&ordf;',   ['«']='&laquo;',  ['¬']='&not;',
	['­']='&shy;',    ['®']='&reg;',    ['¯']='&macr;',   ['°']='&deg;',    ['±']='&plusmn;', ['²']='&sup2;',
	['³']='&sup3;',   ['´']='&acute;',  ['µ']='&micro;',  ['¶']='&para;',   ['·']='&middot;', ['¸']='&cedil;',
	['¹']='&sup1;',   ['º']='&ordm;',   ['»']='&raquo;',  ['¼']='&frac14;', ['½']='&frac12;', ['¾']='&frac34;',
	['¿']='&iquest;',
	['À']='&Agrave;', ['Á']='&Aacute;', ['Â']='&Acirc;',  ['Ã']='&Atilde;', ['Ä']='&Auml;',   ['Å']='&Aring;',
	['Æ']='&AElig;',  ['Ç']='&Ccedil;', ['È']='&Egrave;', ['É']='&Eacute;', ['Ê']='&Ecirc;',  ['Ë']='&Euml;',
	['Ì']='&Igrave;', ['Í']='&Iacute;', ['Î']='&Icirc;',  ['Ï']='&Iuml;',   ['Ð']='&ETH;',    ['Ñ']='&Ntilde;',
	['Ò']='&Ograve;', ['Ó']='&Oacute;', ['Ô']='&Ocirc;',  ['Õ']='&Otilde;', ['Ö']='&Ouml;',   ['×']='&times;',
	['Ø']='&Oslash;', ['Ù']='&Ugrave;', ['Ú']='&Uacute;', ['Û']='&Ucirc;',  ['Ü']='&Uuml;',   ['Ý']='&Yacute;',
	['Þ']='&THORN;',  ['ß']='&szlig;',
	['à']='&agrave;', ['á']='&aacute;', ['â']='&acirc;',  ['ã']='&atilde;', ['ä']='&auml;',   ['å']='&aring;',
	['æ']='&aelig;',  ['ç']='&ccedil;', ['è']='&egrave;', ['é']='&eacute;', ['ê']='&ecirc;',  ['ë']='&euml;',
	['ì']='&igrave;', ['í']='&iacute;', ['î']='&icirc;',  ['ï']='&iuml;',   ['ð']='&eth;',    ['ñ']='&ntilde;',
	['ò']='&ograve;', ['ó']='&oacute;', ['ô']='&ocirc;',  ['õ']='&otilde;', ['ö']='&ouml;',   ['÷']='&divide;',
	['ø']='&oslash;', ['ù']='&ugrave;', ['ú']='&uacute;', ['û']='&ucirc;',  ['ü']='&uuml;',   ['ý']='&yacute;',
	['þ']='&thorn;',  ['ÿ']='&yuml;',

	-- Latin Extended-A (U+0100–U+017F) — Polish, Czech, Slovak, Croatian, Hungarian, Turkish, etc.
	['Ā']='&#256;',   ['ā']='&#257;',   ['Ă']='&#258;',   ['ă']='&#259;',   ['Ą']='&#260;',   ['ą']='&#261;',
	['Ć']='&#262;',   ['ć']='&#263;',   ['Č']='&#268;',   ['č']='&#269;',   ['Ď']='&#270;',   ['ď']='&#271;',
	['Đ']='&#272;',   ['đ']='&#273;',   ['Ě']='&#282;',   ['ě']='&#283;',   ['Ę']='&#280;',   ['ę']='&#281;',
	['Ğ']='&#286;',   ['ğ']='&#287;',   ['İ']='&#304;',   ['ı']='&#305;',   ['Ł']='&#321;',   ['ł']='&#322;',
	['Ń']='&#323;',   ['ń']='&#324;',   ['Ň']='&#327;',   ['ň']='&#328;',   ['Ő']='&#336;',   ['ő']='&#337;',
	['Œ']='&OElig;',  ['œ']='&oelig;',  ['Ř']='&#344;',   ['ř']='&#345;',   ['Ś']='&#346;',   ['ś']='&#347;',
	['Š']='&Scaron;', ['š']='&scaron;', ['Ş']='&#350;',   ['ş']='&#351;',   ['Ť']='&#356;',   ['ť']='&#357;',
	['Ű']='&#368;',   ['ű']='&#369;',   ['Ů']='&#366;',   ['ů']='&#367;',   ['Ÿ']='&Yuml;',   ['Ź']='&#377;',
	['ź']='&#378;',   ['Ž']='&Zcaron;', ['ž']='&zcaron;', ['Ż']='&#379;',   ['ż']='&#380;',

	-- Greek (U+0391–U+03C9)
	['Α']='&Alpha;',   ['Β']='&Beta;',    ['Γ']='&Gamma;',   ['Δ']='&Delta;',   ['Ε']='&Epsilon;', ['Ζ']='&Zeta;',
	['Η']='&Eta;',     ['Θ']='&Theta;',   ['Ι']='&Iota;',    ['Κ']='&Kappa;',   ['Λ']='&Lambda;',  ['Μ']='&Mu;',
	['Ν']='&Nu;',      ['Ξ']='&Xi;',      ['Ο']='&Omicron;', ['Π']='&Pi;',      ['Ρ']='&Rho;',     ['Σ']='&Sigma;',
	['Τ']='&Tau;',     ['Υ']='&Upsilon;', ['Φ']='&Phi;',     ['Χ']='&Chi;',     ['Ψ']='&Psi;',     ['Ω']='&Omega;',
	['α']='&alpha;',   ['β']='&beta;',    ['γ']='&gamma;',   ['δ']='&delta;',   ['ε']='&epsilon;', ['ζ']='&zeta;',
	['η']='&eta;',     ['θ']='&theta;',   ['ι']='&iota;',    ['κ']='&kappa;',   ['λ']='&lambda;',  ['μ']='&mu;',
	['ν']='&nu;',      ['ξ']='&xi;',      ['ο']='&omicron;', ['π']='&pi;',      ['ρ']='&rho;',     ['σ']='&sigma;',
	['τ']='&tau;',     ['υ']='&upsilon;', ['φ']='&phi;',     ['χ']='&chi;',     ['ψ']='&psi;',     ['ω']='&omega;',

	-- Cyrillic Basic (U+0410–U+044F) — Russian, Bulgarian
	['А']='&#1040;', ['Б']='&#1041;', ['В']='&#1042;', ['Г']='&#1043;', ['Д']='&#1044;', ['Е']='&#1045;',
	['Ж']='&#1046;', ['З']='&#1047;', ['И']='&#1048;', ['Й']='&#1049;', ['К']='&#1050;', ['Л']='&#1051;',
	['М']='&#1052;', ['Н']='&#1053;', ['О']='&#1054;', ['П']='&#1055;', ['Р']='&#1056;', ['С']='&#1057;',
	['Т']='&#1058;', ['У']='&#1059;', ['Ф']='&#1060;', ['Х']='&#1061;', ['Ц']='&#1062;', ['Ч']='&#1063;',
	['Ш']='&#1064;', ['Щ']='&#1065;', ['Ъ']='&#1066;', ['Ы']='&#1067;', ['Ь']='&#1068;', ['Э']='&#1069;',
	['Ю']='&#1070;', ['Я']='&#1071;',
	['а']='&#1072;', ['б']='&#1073;', ['в']='&#1074;', ['г']='&#1075;', ['д']='&#1076;', ['е']='&#1077;',
	['ж']='&#1078;', ['з']='&#1079;', ['и']='&#1080;', ['й']='&#1081;', ['к']='&#1082;', ['л']='&#1083;',
	['м']='&#1084;', ['н']='&#1085;', ['о']='&#1086;', ['п']='&#1087;', ['р']='&#1088;', ['с']='&#1089;',
	['т']='&#1090;', ['у']='&#1091;', ['ф']='&#1092;', ['х']='&#1093;', ['ц']='&#1094;', ['ч']='&#1095;',
	['ш']='&#1096;', ['щ']='&#1097;', ['ъ']='&#1098;', ['ы']='&#1099;', ['ь']='&#1100;', ['э']='&#1101;',
	['ю']='&#1102;', ['я']='&#1103;',

	-- Cyrillic Extended — Ukrainian (Є І Ї Ґ), Belarusian (Ў), Serbian/Macedonian (Ђ Љ Њ Ћ Џ), Russian (Ё)
	['Ё']='&#1025;', ['ё']='&#1105;', ['Є']='&#1028;', ['є']='&#1108;', ['І']='&#1030;', ['і']='&#1110;',
	['Ї']='&#1031;', ['ї']='&#1111;', ['Ґ']='&#1168;', ['ґ']='&#1169;', ['Ў']='&#1038;', ['ў']='&#1118;',
	['Ђ']='&#1026;', ['ђ']='&#1106;', ['Љ']='&#1033;', ['љ']='&#1113;', ['Њ']='&#1034;', ['њ']='&#1114;',
	['Ћ']='&#1035;', ['ћ']='&#1115;', ['Џ']='&#1039;', ['џ']='&#1119;',

	-- Arabic (U+0621–U+064A) — basic consonants
	['ء']='&#1569;', ['آ']='&#1570;', ['أ']='&#1571;', ['ؤ']='&#1572;', ['إ']='&#1573;', ['ئ']='&#1574;',
	['ا']='&#1575;', ['ب']='&#1576;', ['ة']='&#1577;', ['ت']='&#1578;', ['ث']='&#1579;', ['ج']='&#1580;',
	['ح']='&#1581;', ['خ']='&#1582;', ['د']='&#1583;', ['ذ']='&#1584;', ['ر']='&#1585;', ['ز']='&#1586;',
	['س']='&#1587;', ['ش']='&#1588;', ['ص']='&#1589;', ['ض']='&#1590;', ['ط']='&#1591;', ['ظ']='&#1592;',
	['ع']='&#1593;', ['غ']='&#1594;', ['ف']='&#1601;', ['ق']='&#1602;', ['ك']='&#1603;', ['ل']='&#1604;',
	['م']='&#1605;', ['ن']='&#1606;', ['ه']='&#1607;', ['و']='&#1608;', ['ى']='&#1609;', ['ي']='&#1610;',

	-- Hebrew (U+05D0–U+05EA) — letters including final forms
	['א']='&#1488;', ['ב']='&#1489;', ['ג']='&#1490;', ['ד']='&#1491;', ['ה']='&#1492;', ['ו']='&#1493;',
	['ז']='&#1494;', ['ח']='&#1495;', ['ט']='&#1496;', ['י']='&#1497;', ['ך']='&#1498;', ['כ']='&#1499;',
	['ל']='&#1500;', ['ם']='&#1501;', ['מ']='&#1502;', ['ן']='&#1503;', ['נ']='&#1504;', ['ס']='&#1505;',
	['ע']='&#1506;', ['ף']='&#1507;', ['פ']='&#1508;', ['ץ']='&#1509;', ['צ']='&#1510;', ['ק']='&#1511;',
	['ר']='&#1512;', ['ש']='&#1513;', ['ת']='&#1514;',

	-- Devanagari (U+0900–U+096F) — Hindi/Sanskrit vowels, consonants, matras, digits
	['ँ']='&#2305;', ['ं']='&#2306;', ['ः']='&#2307;',
	['अ']='&#2309;', ['आ']='&#2310;', ['इ']='&#2311;', ['ई']='&#2312;', ['उ']='&#2313;', ['ऊ']='&#2314;',
	['ऋ']='&#2315;', ['ए']='&#2319;', ['ऐ']='&#2320;', ['ओ']='&#2323;', ['औ']='&#2324;',
	['क']='&#2325;', ['ख']='&#2326;', ['ग']='&#2327;', ['घ']='&#2328;', ['ङ']='&#2329;', ['च']='&#2330;',
	['छ']='&#2331;', ['ज']='&#2332;', ['झ']='&#2333;', ['ञ']='&#2334;', ['ट']='&#2335;', ['ठ']='&#2336;',
	['ड']='&#2337;', ['ढ']='&#2338;', ['ण']='&#2339;', ['त']='&#2340;', ['थ']='&#2341;', ['द']='&#2342;',
	['ध']='&#2343;', ['न']='&#2344;', ['प']='&#2346;', ['फ']='&#2347;', ['ब']='&#2348;', ['भ']='&#2349;',
	['म']='&#2350;', ['य']='&#2351;', ['र']='&#2352;', ['ल']='&#2354;', ['व']='&#2357;', ['श']='&#2358;',
	['ष']='&#2359;', ['स']='&#2360;', ['ह']='&#2361;',
	['ा']='&#2366;', ['ि']='&#2367;', ['ी']='&#2368;', ['ु']='&#2369;', ['ू']='&#2370;',
	['े']='&#2375;', ['ै']='&#2376;', ['ो']='&#2379;', ['ौ']='&#2380;', ['्']='&#2381;',
	['०']='&#2406;', ['१']='&#2407;', ['२']='&#2408;', ['३']='&#2409;', ['४']='&#2410;',
	['५']='&#2411;', ['६']='&#2412;', ['७']='&#2413;', ['८']='&#2414;', ['९']='&#2415;',

	-- Hiragana (U+3041–U+3096)
	['ぁ']='&#12353;',['あ']='&#12354;',['ぃ']='&#12355;',['い']='&#12356;',['ぅ']='&#12357;',['う']='&#12358;',['ぇ']='&#12359;',['え']='&#12360;',
	['ぉ']='&#12361;',['お']='&#12362;',['か']='&#12363;',['が']='&#12364;',['き']='&#12365;',['ぎ']='&#12366;',['く']='&#12367;',['ぐ']='&#12368;',
	['け']='&#12369;',['げ']='&#12370;',['こ']='&#12371;',['ご']='&#12372;',['さ']='&#12373;',['ざ']='&#12374;',['し']='&#12375;',['じ']='&#12376;',
	['す']='&#12377;',['ず']='&#12378;',['せ']='&#12379;',['ぜ']='&#12380;',['そ']='&#12381;',['ぞ']='&#12382;',['た']='&#12383;',['だ']='&#12384;',
	['ち']='&#12385;',['ぢ']='&#12386;',['っ']='&#12387;',['つ']='&#12388;',['づ']='&#12389;',['て']='&#12390;',['で']='&#12391;',['と']='&#12392;',
	['ど']='&#12393;',['な']='&#12394;',['に']='&#12395;',['ぬ']='&#12396;',['ね']='&#12397;',['の']='&#12398;',['は']='&#12399;',['ば']='&#12400;',
	['ぱ']='&#12401;',['ひ']='&#12402;',['び']='&#12403;',['ぴ']='&#12404;',['ふ']='&#12405;',['ぶ']='&#12406;',['ぷ']='&#12407;',['へ']='&#12408;',
	['べ']='&#12409;',['ぺ']='&#12410;',['ほ']='&#12411;',['ぼ']='&#12412;',['ぽ']='&#12413;',['ま']='&#12414;',['み']='&#12415;',['む']='&#12416;',
	['め']='&#12417;',['も']='&#12418;',['ゃ']='&#12419;',['や']='&#12420;',['ゅ']='&#12421;',['ゆ']='&#12422;',['ょ']='&#12423;',['よ']='&#12424;',
	['ら']='&#12425;',['り']='&#12426;',['る']='&#12427;',['れ']='&#12428;',['ろ']='&#12429;',['ゎ']='&#12430;',['わ']='&#12431;',['ゐ']='&#12432;',
	['ゑ']='&#12433;',['を']='&#12434;',['ん']='&#12435;',['ゔ']='&#12436;',['ゕ']='&#12437;',['ゖ']='&#12438;',

	-- Katakana (U+30A1–U+30F6)
	['ァ']='&#12449;',['ア']='&#12450;',['ィ']='&#12451;',['イ']='&#12452;',['ゥ']='&#12453;',['ウ']='&#12454;',['ェ']='&#12455;',['エ']='&#12456;',
	['ォ']='&#12457;',['オ']='&#12458;',['カ']='&#12459;',['ガ']='&#12460;',['キ']='&#12461;',['ギ']='&#12462;',['ク']='&#12463;',['グ']='&#12464;',
	['ケ']='&#12465;',['ゲ']='&#12466;',['コ']='&#12467;',['ゴ']='&#12468;',['サ']='&#12469;',['ザ']='&#12470;',['シ']='&#12471;',['ジ']='&#12472;',
	['ス']='&#12473;',['ズ']='&#12474;',['セ']='&#12475;',['ゼ']='&#12476;',['ソ']='&#12477;',['ゾ']='&#12478;',['タ']='&#12479;',['ダ']='&#12480;',
	['チ']='&#12481;',['ヂ']='&#12482;',['ッ']='&#12483;',['ツ']='&#12484;',['ヅ']='&#12485;',['テ']='&#12486;',['デ']='&#12487;',['ト']='&#12488;',
	['ド']='&#12489;',['ナ']='&#12490;',['ニ']='&#12491;',['ヌ']='&#12492;',['ネ']='&#12493;',['ノ']='&#12494;',['ハ']='&#12495;',['バ']='&#12496;',
	['パ']='&#12497;',['ヒ']='&#12498;',['ビ']='&#12499;',['ピ']='&#12500;',['フ']='&#12501;',['ブ']='&#12502;',['プ']='&#12503;',['ヘ']='&#12504;',
	['ベ']='&#12505;',['ペ']='&#12506;',['ホ']='&#12507;',['ボ']='&#12508;',['ポ']='&#12509;',['マ']='&#12510;',['ミ']='&#12511;',['ム']='&#12512;',
	['メ']='&#12513;',['モ']='&#12514;',['ャ']='&#12515;',['ヤ']='&#12516;',['ュ']='&#12517;',['ユ']='&#12518;',['ョ']='&#12519;',['ヨ']='&#12520;',
	['ラ']='&#12521;',['リ']='&#12522;',['ル']='&#12523;',['レ']='&#12524;',['ロ']='&#12525;',['ヮ']='&#12526;',['ワ']='&#12527;',['ヰ']='&#12528;',
	['ヱ']='&#12529;',['ヲ']='&#12530;',['ン']='&#12531;',['ヴ']='&#12532;',['ヵ']='&#12533;',['ヶ']='&#12534;',

	-- Thai (U+0E01–U+0E5B) — consonants, vowels, tone marks, digits
	['ก']='&#3585;', ['ข']='&#3586;', ['ค']='&#3588;', ['ง']='&#3591;', ['จ']='&#3592;', ['ช']='&#3594;',
	['ซ']='&#3595;', ['ญ']='&#3597;', ['ด']='&#3604;', ['ต']='&#3605;', ['ถ']='&#3606;', ['ท']='&#3607;',
	['น']='&#3609;', ['บ']='&#3610;', ['ป']='&#3611;', ['ผ']='&#3612;', ['ฝ']='&#3613;', ['พ']='&#3614;',
	['ฟ']='&#3615;', ['ภ']='&#3616;', ['ม']='&#3617;', ['ย']='&#3618;', ['ร']='&#3619;', ['ล']='&#3621;',
	['ว']='&#3623;', ['ส']='&#3626;', ['ห']='&#3627;', ['อ']='&#3629;', ['ฮ']='&#3630;',
	['ะ']='&#3632;', ['า']='&#3634;', ['ิ']='&#3636;', ['ี']='&#3637;', ['ึ']='&#3638;', ['ื']='&#3639;',
	['ุ']='&#3640;', ['ู']='&#3641;', ['เ']='&#3648;', ['แ']='&#3649;', ['โ']='&#3650;', ['ใ']='&#3651;',
	['ไ']='&#3652;', ['ๆ']='&#3654;', ['็']='&#3655;', ['่']='&#3656;', ['้']='&#3657;', ['๊']='&#3658;',
	['๋']='&#3659;', ['์']='&#3660;',
	['๐']='&#3664;', ['๑']='&#3665;', ['๒']='&#3666;', ['๓']='&#3667;', ['๔']='&#3668;',
	['๕']='&#3669;', ['๖']='&#3670;', ['๗']='&#3671;', ['๘']='&#3672;', ['๙']='&#3673;',

	-- Typography & punctuation
	['‚']='&sbquo;',  ['„']='&bdquo;',  ['\xe2\x80\x98']='&lsquo;', ['\xe2\x80\x99']='&rsquo;',
	['\xe2\x80\x9c']='&ldquo;', ['\xe2\x80\x9d']='&rdquo;',
	['…']='&hellip;', ['–']='&ndash;',  ['—']='&mdash;',  ['•']='&bull;',
	['†']='&dagger;', ['‡']='&Dagger;', ['‰']='&permil;', ['′']='&prime;',
	['″']='&Prime;',  ['‾']='&oline;',  ['⁄']='&frasl;',  ['‖']='&Vert;',
	['‹']='&lsaquo;', ['›']='&rsaquo;',

	-- Math & science
	['∀']='&forall;', ['∂']='&part;',   ['∃']='&exist;',  ['∅']='&empty;',  ['∇']='&nabla;',  ['∈']='&isin;',
	['∉']='&notin;',  ['∋']='&ni;',     ['∏']='&prod;',   ['∑']='&sum;',    ['∗']='&lowast;', ['√']='&radic;',
	['∝']='&prop;',   ['∞']='&infin;',  ['∠']='&ang;',    ['∧']='&and;',    ['∨']='&or;',     ['∩']='&cap;',
	['∪']='&cup;',    ['∫']='&int;',    ['∴']='&there4;', ['∼']='&sim;',    ['≅']='&cong;',   ['≈']='&asymp;',
	['≠']='&ne;',     ['≡']='&equiv;',  ['≤']='&le;',     ['≥']='&ge;',     ['⊂']='&sub;',    ['⊃']='&sup;',
	['⊆']='&sube;',   ['⊇']='&supe;',   ['⊕']='&oplus;',  ['⊗']='&otimes;', ['⊥']='&perp;',   ['⋅']='&sdot;',
	['⌈']='&lceil;',  ['⌉']='&rceil;',  ['⌊']='&lfloor;', ['⌋']='&rfloor;',

	-- Arrows
	['←']='&larr;',  ['→']='&rarr;',  ['↑']='&uarr;',  ['↓']='&darr;',  ['↔']='&harr;',  ['↕']='&#8597;',
	['↩']='&#8617;', ['↪']='&#8618;', ['⇐']='&lArr;',  ['⇒']='&rArr;',  ['⇔']='&hArr;',  ['⇑']='&uArr;',
	['⇓']='&dArr;',

	-- Currency
	['€']='&euro;',  ['₿']='&#8383;', ['₹']='&#8377;', ['₩']='&#8361;', ['₪']='&#8362;', ['₫']='&#8363;',
	['₭']='&#8365;', ['₮']='&#8366;', ['₱']='&#8369;', ['₲']='&#8370;', ['₴']='&#8372;', ['₵']='&#8373;',
	['₸']='&#8376;', ['₺']='&#8378;', ['₼']='&#8380;', ['₽']='&#8381;',

	-- Misc & media-relevant symbols
	['™']='&trade;',  ['№']='&#8470;', ['℗']='&#8471;', ['℠']='&#8480;', ['℃']='&#8451;', ['℉']='&#8457;',
	['♠']='&spades;', ['♣']='&clubs;', ['♥']='&hearts;', ['♦']='&diams;',
	['♩']='&#9833;',  ['♪']='&#9834;', ['♫']='&#9835;', ['♬']='&#9836;',
	['▶']='&#9654;',  ['◀']='&#9664;', ['▲']='&#9650;', ['▼']='&#9660;',
	['⏸']='&#9208;',  ['⏹']='&#9209;', ['⏺']='&#9210;',
	['★']='&#9733;',  ['☆']='&#9734;', ['✓']='&#10003;',['✗']='&#10007;',
	['☎']='&#9742;',  ['✉']='&#9993;',
}

-- Strip all control characters (0-31 and 127) from a string.
local function removeControlChars(str)
	return (string_gsub(str, "%c", ""))
end

-- Encode a string to HTML entities.
-- & is encoded first to avoid double-encoding subsequent replacements.
function htmlentities(s)
	if not s or not isstring(s) then return s or "" end

	s = string_gsub(s, '&', '&amp;')
	for k, v in pairs(entities) do
		if k ~= '&' then
			s = string_gsub(s, k, v)
		end
	end

	return s
end

-- Decode HTML entities back to characters.
-- &amp; is decoded last to avoid double-decoding (e.g. &amp;lt; -> &lt; not <).
function htmlentities_decode(s)
	if not s or not isstring(s) then return s or "" end

	for k, v in pairs(entities) do
		if k ~= '&' then
			s = string_gsub(s, v, k)
		end
	end
	s = string_gsub(s, '&amp;', '&')

	return s
end

-- Escape the minimal set of characters needed to prevent XSS via HTML injection.
-- & is encoded first to avoid double-encoding subsequent replacements.
function htmlentities_secure(s)
	if not s or not isstring(s) then return s or "" end

	s = string_gsub(s, '&', '&amp;')
	s = string_gsub(s, '<', '&lt;')
	s = string_gsub(s, '>', '&gt;')
	s = string_gsub(s, '"', '&quot;')
	s = string_gsub(s, "'", '&#39;')
	s = string_gsub(s, '/', '&#47;')
	s = string_gsub(s, '\\', '&#92;')

	return s
end

-- Percent-encode all non-alphanumeric characters in a string.
function escape(s)
	if not s or not isstring(s) then return s or "" end

	return string_gsub(s, "([^A-Za-z0-9_])", function(c)
		return string_format("%%%02x", string_byte(c))
	end)
end

-- Build a lookup set from an array.
local function make_set(t)
	local s = {}
	for _, v in ipairs(t) do
		s[v] = 1
	end
	return s
end

-- Characters that are safe unescaped inside a path segment (RFC 2396).
local segment_set = make_set { "-", "_", ".", "!", "~", "*", "'", "(", ")", ":", "@", "&", "=", "+", "$", "," }

local function protect_segment(s)
	return string_gsub(s, "([^A-Za-z0-9_])", function(c)
		if segment_set[c] then
			return c
		else
			return string_format("%%%02x", string_byte(c))
		end
	end)
end

-- Decode a percent-encoded string.
function unescape(s)
	if not s or not isstring(s) then return s or "" end

	return string_gsub(s, "%%(%x%x)", function(hex)
		local num = tonumber(hex, 16)
		if num and num >= 0 and num <= 255 then
			return string_char(num)
		else
			return "%" .. hex
		end
	end)
end

-- Returns true if the scheme is in the allowed protocol whitelist.
function isAllowedProtocol(scheme)
	if not scheme or not isstring(scheme) then return false end
	return ALLOWED_PROTOCOLS[string_lower(scheme)] or false
end

-- Sanitize a key/value parameter pair.
-- Returns nil, nil if either contains dangerous patterns (XSS, injection, etc.).
function sanitizeParam(key, value)
	if not key or not value then return nil, nil end

	key                      = tostring(key):sub(1, MAX_PARAM_LENGTH)
	value                    = tostring(value):sub(1, MAX_PARAM_LENGTH)

	local dangerous_patterns = {
		"<script[^>]*>",
		"javascript:",
		"vbscript:",
		"data:",
		"on%w+%s*=",
		"expression%s*%(",
		"<%s*iframe",
		"<%s*object",
		"<%s*embed",
		"<%s*link",
		"<%s*meta"
	}

	for _, pattern in ipairs(dangerous_patterns) do
		if string_match(string_lower(value), pattern) or
			string_match(string_lower(key), pattern) then
			return nil, nil
		end
	end

	key   = removeControlChars(key)
	value = removeControlChars(value)

	return key, value
end

-- Sanitize a URL path.
-- Rejects paths with traversal sequences, excessive depth, or dangerous extensions.
-- Returns nil if the path is rejected, otherwise returns the cleaned path string.
function sanitizePath(path)
	if not path or not isstring(path) then return "/" end

	path = removeControlChars(path)
	path = string_gsub(path, "\\", "/")

	local dangerous_sequences = {
		"%.%./", "%.%.\\", "/%.%./", "\\%.%.\\", "%.%.%.", "/%.%.", "\\%.%."
	}

	for _, sequence in ipairs(dangerous_sequences) do
		path = string_gsub(path, sequence, "/")
	end

	local segments = {}
	for segment in string_gmatch(path, "[^/]+") do
		if segment ~= "" and segment ~= "." then
			if segment == ".." then return nil end
			table_insert(segments, segment)
		end
	end

	if #segments > MAX_PATH_DEPTH then return nil end

	local clean_path = "/" .. table_concat(segments, "/")

	local dangerous_extensions = {
		"%.php$", "%.asp$", "%.jsp$", "%.cgi$", "%.pl$",
		"%.py$", "%.sh$", "%.bat$", "%.cmd$"
	}

	for _, ext_pattern in ipairs(dangerous_extensions) do
		if string_match(string_lower(clean_path), ext_pattern) then
			return nil
		end
	end

	return clean_path
end

-- Validate and sanitize a full URL string.
-- Checks length, strips whitespace/control chars, validates protocol and path.
-- Returns the cleaned URL string, or nil if rejected.
function sanitizeURL(url_string)
	if not url_string or not isstring(url_string) then return nil end
	if #url_string > MAX_URL_LENGTH then return nil end

	url_string = string_gsub(url_string, "^%s+", "")
	url_string = string_gsub(url_string, "%s+$", "")
	url_string = removeControlChars(url_string)

	local parsed = parse(url_string)
	if not parsed then return nil end

	if parsed.scheme and not isAllowedProtocol(parsed.scheme) then return nil end

	if parsed.path then
		local clean_path = sanitizePath(parsed.path)
		if not clean_path then return nil end
		parsed.path = clean_path
	end

	return build(parsed)
end

-- Resolve a relative path against a base path.
local function absolute_path(base_path, relative_path)
	if string_sub(relative_path, 1, 1) == "/" then return relative_path end
	local path = string_gsub(base_path, "[^/]*$", "")
	path = path .. relative_path

	path = string_gsub(path, "([^/]*%./)", function(s)
		if s ~= "./" then return s else return "" end
	end)

	path = string_gsub(path, "/%.$", "/")
	local reduced

	while reduced ~= path do
		reduced = path
		path = string_gsub(reduced, "([^/]*/%.%./)", function(s)
			if s ~= "../../" then return "" else return s end
		end)
	end

	path = string_gsub(reduced, "([^/]*/%.%.)$", function(s)
		if s ~= "../.." then return "" else return s end
	end)

	return path
end

-- Parse a URL string into a table of components (RFC 2396).
-- Returns: { scheme, authority, host, port, user, password, path, file, params, query, fragment }
function parse(url, default)
	local parsed = {}

	for i, v in pairs(default or parsed) do
		parsed[i] = v
	end

	if not url or url == "" then return nil, "invalid url" end

	url = string_gsub(url, "#(.*)$", function(f)
		parsed.fragment = f
		return ""
	end)

	url = string_gsub(url, "^([%w][%w%+%-%.]*)%://", function(s)
		parsed.scheme = string_lower(s)
		return ""
	end)

	url = string_gsub(url, "^([^/%?]*)", function(n)
		parsed.authority = n
		return ""
	end)

	url = string_gsub(url, "%?(.*)", function(q)
		parsed.query = q
		return ""
	end)

	url = string_gsub(url, "%;(.*)", function(p)
		parsed.params = p
		return ""
	end)

	if url ~= "" then
		parsed.path = url
		if string_GetFileFromFilename(url) then
			parsed.file = {
				name = string_GetFileFromFilename(url),
				ext  = string_GetExtensionFromFilename(url)
			}
		end
	else
		parsed.path = "/"
	end

	local authority = parsed.authority
	if not authority then return parsed end

	authority = string_gsub(authority, "^([^@]*)@", function(u)
		parsed.userinfo = u
		return ""
	end)

	authority = string_gsub(authority, ":([^:]*)$", function(p)
		local port_num = tonumber(p)
		if port_num and port_num >= 1 and port_num <= 65535 then
			parsed.port = p
		end
		return ""
	end)

	if authority ~= "" then
		parsed.host = string_lower(authority)
	end

	local userinfo = parsed.userinfo
	if not userinfo then return parsed end

	userinfo = string_gsub(userinfo, ":([^:]*)$", function(p)
		parsed.password = p
		return ""
	end)

	parsed.user = userinfo

	return parsed
end

-- Split "key=value" on the first '=' only, so "key=a=b" -> key="key", value="a=b".
local function split_key_value(pair)
	local key, value = string_match(pair, "^([^=]*)=?(.*)$")
	return key, value or ""
end

-- Parse a query string ("k1=v1&k2=v2") into a sanitized key/value table.
-- Parameters that fail sanitization are silently dropped.
local function parse_query_string(query_string)
	local params = {}
	for pair in string_gmatch(query_string, "[^&]+") do
		local key, value = split_key_value(pair)
		if key and key ~= "" then
			key                          = unescape(key)
			value                        = unescape(value)
			local clean_key, clean_value = sanitizeParam(key, value)
			if clean_key and clean_value then
				params[clean_key] = clean_value
			end
		end
	end
	return params
end

-- Like parse(), but also sanitizes the URL and returns structured query/fragment tables.
--
-- query  -> { key = "value", ... }
-- fragment hash_type values:
--   "anchor"           -> fragment.anchor  (e.g. #section1)
--   "route"            -> fragment.route   (e.g. #/users/profile)
--   "route_with_params"-> fragment.route + fragment.params
--   "parameters"       -> fragment.params  (e.g. #key=val&key2=val2)
--   "content"          -> fragment.content (anything else)
--
-- Returns nil if the URL fails security validation.
function parse2(url, default)
	local clean_url = sanitizeURL(url)
	if not clean_url then return nil end

	local parsed = parse(clean_url, default)
	if not parsed then return end

	if parsed.scheme and not isAllowedProtocol(parsed.scheme) then return nil end

	if parsed.query then
		parsed.query = parse_query_string(parsed.query)
	end

	if parsed.fragment then
		local fragment = parsed.fragment
		parsed.fragment = {
			raw       = htmlentities_secure(fragment),
			params    = {},
			hash_type = "unknown"
		}

		local route_part, query_part = string_match(fragment, "^([^%?]*)%?(.*)$")

		if route_part and query_part then
			local clean_route = sanitizePath(route_part)
			if clean_route then
				parsed.fragment.hash_type = "route_with_params"
				parsed.fragment.route     = clean_route
				parsed.fragment.params    = parse_query_string(query_part)
			else
				parsed.fragment.hash_type = "content"
				parsed.fragment.content   = htmlentities_secure(fragment)
				return parsed
			end
		elseif string_match(fragment, "^[%w%-_]+$") then
			parsed.fragment.hash_type = "anchor"
			parsed.fragment.anchor    = htmlentities_secure(fragment)
		elseif string_match(fragment, "[&=]") then
			parsed.fragment.hash_type = "parameters"
			parsed.fragment.params    = parse_query_string(fragment)
		elseif string_match(fragment, "^/") then
			local clean_route = sanitizePath(fragment)
			if clean_route then
				parsed.fragment.hash_type = "route"
				parsed.fragment.route     = clean_route
			else
				parsed.fragment.hash_type = "content"
				parsed.fragment.content   = htmlentities_secure(fragment)
			end
		else
			parsed.fragment.hash_type = "content"
			parsed.fragment.content   = htmlentities_secure(fragment)
		end
	end

	return parsed
end

-- Rebuild a URL string from a parsed component table.
-- Handles both string query/fragment (from parse) and table forms (from parse2).
function build(parsed)
	local url = (parsed.path or ""):gsub("[^/]+", unescape)
	url = url:gsub("[^/]*", protect_segment)

	if parsed.params then
		url = url .. ";" .. parsed.params
	end

	if parsed.query then
		if istable(parsed.query) then
			local parts = {}
			for k, v in pairs(parsed.query) do
				table_insert(parts, escape(tostring(k)) .. "=" .. escape(tostring(v)))
			end
			if #parts > 0 then
				url = url .. "?" .. table_concat(parts, "&")
			end
		else
			url = url .. "?" .. tostring(parsed.query)
		end
	end

	local authority = parsed.authority

	if parsed.host then
		authority = parsed.host

		if parsed.port then
			authority = authority .. ":" .. parsed.port
		end

		local userinfo = parsed.userinfo

		if parsed.user then
			userinfo = parsed.user
			if parsed.password then
				userinfo = userinfo .. ":" .. parsed.password
			end
		end

		if userinfo then
			authority = userinfo .. "@" .. authority
		end
	end

	if authority then
		url = "//" .. authority .. url
	end

	if parsed.scheme then
		url = parsed.scheme .. ":" .. url
	end

	if parsed.fragment then
		if istable(parsed.fragment) then
			url = url .. "#" .. (parsed.fragment.raw or "")
		else
			url = url .. "#" .. tostring(parsed.fragment)
		end
	end

	url = string_gsub(url, "%?$", "")
	url = string_gsub(url, "/$", "")

	return url
end

-- Compose an absolute URL from a base URL and a relative URL (RFC 2396).
function absolute(base_url, relative_url)
	local base_parsed
	if istable(base_url) then
		base_parsed = base_url
		base_url = build(base_parsed)
	else
		base_parsed = parse(base_url)
	end

	local relative_parsed = parse(relative_url)
	if not base_parsed then return relative_url end
	if not relative_parsed then return base_url end
	if relative_parsed.scheme then return relative_url end

	relative_parsed.scheme = base_parsed.scheme
	if not relative_parsed.authority then
		relative_parsed.authority = base_parsed.authority
		if not relative_parsed.path then
			relative_parsed.path = base_parsed.path
			if not relative_parsed.params then
				relative_parsed.params = base_parsed.params
				if not relative_parsed.query then
					relative_parsed.query = base_parsed.query
				end
			end
		else
			relative_parsed.path = absolute_path(base_parsed.path or "", relative_parsed.path)
		end
	end

	return build(relative_parsed)
end

-- Break a path string into an unescaped segment list.
function parse_path(path)
	local parsed = {}
	path = path or ""

	string_gsub(path, "([^/]*)", function(s)
		table_insert(parsed, s)
	end)

	for i = 1, #parsed do
		parsed[i] = unescape(parsed[i])
	end

	if string_sub(path, 1, 1) == "/" then parsed.is_absolute = 1 end
	if string_sub(path, -1, -1) == "/" then parsed.is_directory = 1 end

	return parsed
end

-- Build a path string from a segment list produced by parse_path.
-- Pass unsafe=true to skip percent-encoding of segments.
function build_path(parsed, unsafe)
	local path = ""
	local escape_fn = unsafe and function(x) return x end or protect_segment
	local n = #parsed

	for i = 1, n - 1 do
		if parsed[i] ~= "" or parsed[i + 1] == "" then
			path = path .. escape_fn(parsed[i])
			if i < n - 1 or parsed[i + 1] ~= "" then
				path = path .. "/"
			end
		end
	end

	if n > 0 then
		path = path .. escape_fn(parsed[n])
		if parsed.is_directory then path = path .. "/" end
	end

	if parsed.is_absolute then path = "/" .. path end

	return path
end

-----------------------------------------------------------------------------
-- Helper functions
-----------------------------------------------------------------------------

-- Return the value of a query parameter from a parse2 result, or nil.
function getQueryParam(parsed_url, param_name)
	if not parsed_url or not parsed_url.query then return nil end
	if istable(parsed_url.query) then return parsed_url.query[param_name] end
	return nil
end

-- Return the value of a fragment parameter from a parse2 result, or nil.
function getFragmentParam(parsed_url, param_name)
	if not parsed_url or not parsed_url.fragment then return nil end
	if istable(parsed_url.fragment) and parsed_url.fragment.params then
		return parsed_url.fragment.params[param_name]
	end
	return nil
end

-- Return true if the fragment's hash_type matches the given string.
function hasHashType(parsed_url, hash_type)
	if not parsed_url or not parsed_url.fragment then return false end
	if istable(parsed_url.fragment) then
		return parsed_url.fragment.hash_type == hash_type
	end
	return false
end

-- Return true if the parsed URL has the named query parameter.
function hasQueryParam(parsed_url, param_name)
	if not parsed_url or not parsed_url.query then return false end
	if istable(parsed_url.query) then return parsed_url.query[param_name] ~= nil end
	return false
end

-- Return true if the URL string has a valid scheme and host.
function isValidURL(url_string)
	if not url_string or url_string == "" then return false end
	local parsed = parse(url_string)
	return parsed ~= nil and parsed.scheme ~= nil and parsed.host ~= nil
end

-- Normalize a parsed URL in-place: lowercase host, strip default ports, ensure path.
function normalizeURL(parsed_url)
	if not parsed_url then return nil end

	if parsed_url.host then
		parsed_url.host = string_lower(parsed_url.host)
	end

	if parsed_url.port then
		if (parsed_url.scheme == "http" and parsed_url.port == "80") or
			(parsed_url.scheme == "https" and parsed_url.port == "443") then
			parsed_url.port = nil
		end
	end

	if not parsed_url.path or parsed_url.path == "" then
		parsed_url.path = "/"
	end

	return parsed_url
end

-- Like getQueryParam but validates the param name and HTML-escapes the value.
function getQueryParamSecure(parsed_url, param_name)
	if not parsed_url or not parsed_url.query or not param_name then return nil end

	local clean_name, _ = sanitizeParam(param_name, "dummy")
	if not clean_name then return nil end

	if istable(parsed_url.query) then
		local value = parsed_url.query[clean_name]
		return value and htmlentities_secure(value) or nil
	end

	return nil
end

-- Like getFragmentParam but validates the param name and HTML-escapes the value.
function getFragmentParamSecure(parsed_url, param_name)
	if not parsed_url or not parsed_url.fragment or not param_name then return nil end

	local clean_name, _ = sanitizeParam(param_name, "dummy")
	if not clean_name then return nil end

	if istable(parsed_url.fragment) and parsed_url.fragment.params then
		local value = parsed_url.fragment.params[clean_name]
		return value and htmlentities_secure(value) or nil
	end

	return nil
end
