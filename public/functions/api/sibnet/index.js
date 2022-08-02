async function bruteForceWindows1252toUTF16(s) {

    for (var i = 0; i < globalWin1252toUTF16table.length; i++) {
        if (s.includes(globalWin1252toUTF16table[i]['win1252'])) {
            s = s.replaceAll(globalWin1252toUTF16table[i]['win1252'], globalWin1252toUTF16table[i]['utf16']);
        }
    }
    return s;
}

const globalWin1252toUTF16table = [
        { win1252:'\xe2\x82\xac', utf16:'\u20AC' },
        { win1252:'\xe2\x80\x9a', utf16:'\u201A' },
        { win1252:'\xc6\x92', utf16:'\u0192' },
        { win1252:'\xe2\x80\x9e', utf16:'\u201E' },
        { win1252:'\xe2\x80\xa6', utf16:'\u2026' },
        { win1252:'\xe2\x80\xa0', utf16:'\u2020' },
        { win1252:'\xe2\x80\xa1', utf16:'\u2021' },
        { win1252:'\xcb\x86', utf16:'\u02C6' },
        { win1252:'\xe2\x80\xb0', utf16:'\u2030' },
        { win1252:'\xc5\xa0', utf16:'\u0160' },
        { win1252:'\xe2\x80\xb9', utf16:'\u2039' },
        { win1252:'\xc5\x92', utf16:'\u0152' },
        { win1252:'\xc5\xbd', utf16:'\u017D' },
        { win1252:'\xe2\x80\x98', utf16:'\u2018' },
        { win1252:'\xe2\x80\x99', utf16:'\u2019' },
        { win1252:'\xe2\x80\x9c', utf16:'\u201C' },
        { win1252:'\xe2\x80\x9d', utf16:'\u201D' },
        { win1252:'\xe2\x80\xa2', utf16:'\u2022' },
        { win1252:'\xe2\x80\x93', utf16:'\u2013' },
        { win1252:'\xe2\x80\x94', utf16:'\u2014' },
        { win1252:'\xcb\x9c', utf16:'\u02DC' },
        { win1252:'\xe2\x84\xa2', utf16:'\u2122' },
        { win1252:'\xc5\xa1', utf16:'\u0161' },
        { win1252:'\xe2\x80\xba', utf16:'\u203A' },
        { win1252:'\xc5\x93', utf16:'\u0153' },
        { win1252:'\xc5\xbe', utf16:'\u017E' },
        { win1252:'\xc5\xb8', utf16:'\u0178' },
        { win1252:'\xc2\xa0', utf16:'\u00A0' },
        { win1252:'\xc2\xa1', utf16:'\u00A1' },
        { win1252:'\xc2\xa2', utf16:'\u00A2' },
        { win1252:'\xc2\xa3', utf16:'\u00A3' },
        { win1252:'\xc2\xa4', utf16:'\u00A4' },
        { win1252:'\xc2\xa5', utf16:'\u00A5' },
        { win1252:'\xc2\xa6', utf16:'\u00A6' },
        { win1252:'\xc2\xa7', utf16:'\u00A7' },
        { win1252:'\xc2\xa8', utf16:'\u00A8' },
        { win1252:'\xc2\xa9', utf16:'\u00A9' },
        { win1252:'\xc2\xaa', utf16:'\u00AA' },
        { win1252:'\xc2\xab', utf16:'\u00AB' },
        { win1252:'\xc2\xac', utf16:'\u00AC' },
        { win1252:'\xc2\xad', utf16:'\u00AD' },
        { win1252:'\xc2\xae', utf16:'\u00AE' },
        { win1252:'\xc2\xaf', utf16:'\u00AF' },
        { win1252:'\xc2\xb0', utf16:'\u00B0' },
        { win1252:'\xc2\xb1', utf16:'\u00B1' },
        { win1252:'\xc2\xb2', utf16:'\u00B2' },
        { win1252:'\xc2\xb3', utf16:'\u00B3' },
        { win1252:'\xc2\xb4', utf16:'\u00B4' },
        { win1252:'\xc2\xb5', utf16:'\u00B5' },
        { win1252:'\xc2\xb6', utf16:'\u00B6' },
        { win1252:'\xc2\xb7', utf16:'\u00B7' },
        { win1252:'\xc2\xb8', utf16:'\u00B8' },
        { win1252:'\xc2\xb9', utf16:'\u00B9' },
        { win1252:'\xc2\xba', utf16:'\u00BA' },
        { win1252:'\xc2\xbb', utf16:'\u00BB' },
        { win1252:'\xc2\xbc', utf16:'\u00BC' },
        { win1252:'\xc2\xbd', utf16:'\u00BD' },
        { win1252:'\xc2\xbe', utf16:'\u00BE' },
        { win1252:'\xc2\xbf', utf16:'\u00BF' },
        { win1252:'\xc3\x80', utf16:'\u00C0' },
        { win1252:'\xc3\x81', utf16:'\u00C1' },
        { win1252:'\xc3\x82', utf16:'\u00C2' },
        { win1252:'\xc3\x83', utf16:'\u00C3' },
        { win1252:'\xc3\x84', utf16:'\u00C4' },
        { win1252:'\xc3\x85', utf16:'\u00C5' },
        { win1252:'\xc3\x86', utf16:'\u00C6' },
        { win1252:'\xc3\x87', utf16:'\u00C7' },
        { win1252:'\xc3\x88', utf16:'\u00C8' },
        { win1252:'\xc3\x89', utf16:'\u00C9' },
        { win1252:'\xc3\x8a', utf16:'\u00CA' },
        { win1252:'\xc3\x8b', utf16:'\u00CB' },
        { win1252:'\xc3\x8c', utf16:'\u00CC' },
        { win1252:'\xc3\x8d', utf16:'\u00CD' },
        { win1252:'\xc3\x8e', utf16:'\u00CE' },
        { win1252:'\xc3\x8f', utf16:'\u00CF' },
        { win1252:'\xc3\x90', utf16:'\u00D0' },
        { win1252:'\xc3\x91', utf16:'\u00D1' },
        { win1252:'\xc3\x92', utf16:'\u00D2' },
        { win1252:'\xc3\x93', utf16:'\u00D3' },
        { win1252:'\xc3\x94', utf16:'\u00D4' },
        { win1252:'\xc3\x95', utf16:'\u00D5' },
        { win1252:'\xc3\x96', utf16:'\u00D6' },
        { win1252:'\xc3\x97', utf16:'\u00D7' },
        { win1252:'\xc3\x98', utf16:'\u00D8' },
        { win1252:'\xc3\x99', utf16:'\u00D9' },
        { win1252:'\xc3\x9a', utf16:'\u00DA' },
        { win1252:'\xc3\x9b', utf16:'\u00DB' },
        { win1252:'\xc3\x9c', utf16:'\u00DC' },
        { win1252:'\xc3\x9d', utf16:'\u00DD' },
        { win1252:'\xc3\x9e', utf16:'\u00DE' },
        { win1252:'\xc3\x9f', utf16:'\u00DF' },
        { win1252:'\xc3\xa0', utf16:'\u00E0' },
        { win1252:'\xc3\xa1', utf16:'\u00E1' },
        { win1252:'\xc3\xa2', utf16:'\u00E2' },
        { win1252:'\xc3\xa3', utf16:'\u00E3' },
        { win1252:'\xc3\xa4', utf16:'\u00E4' },
        { win1252:'\xc3\xa5', utf16:'\u00E5' },
        { win1252:'\xc3\xa6', utf16:'\u00E6' },
        { win1252:'\xc3\xa7', utf16:'\u00E7' },
        { win1252:'\xc3\xa8', utf16:'\u00E8' },
        { win1252:'\xc3\xa9', utf16:'\u00E9' },
        { win1252:'\xc3\xaa', utf16:'\u00EA' },
        { win1252:'\xc3\xab', utf16:'\u00EB' },
        { win1252:'\xc3\xac', utf16:'\u00EC' },
        { win1252:'\xc3\xad', utf16:'\u00ED' },
        { win1252:'\xc3\xae', utf16:'\u00EE' },
        { win1252:'\xc3\xaf', utf16:'\u00EF' },
        { win1252:'\xc3\xb0', utf16:'\u00F0' },
        { win1252:'\xc3\xb1', utf16:'\u00F1' },
        { win1252:'\xc3\xb2', utf16:'\u00F2' },
        { win1252:'\xc3\xb3', utf16:'\u00F3' },
        { win1252:'\xc3\xb4', utf16:'\u00F4' },
        { win1252:'\xc3\xb5', utf16:'\u00F5' },
        { win1252:'\xc3\xb6', utf16:'\u00F6' },
        { win1252:'\xc3\xb7', utf16:'\u00F7' },
        { win1252:'\xc3\xb8', utf16:'\u00F8' },
        { win1252:'\xc3\xb9', utf16:'\u00F9' },
        { win1252:'\xc3\xba', utf16:'\u00FA' },
        { win1252:'\xc3\xbb', utf16:'\u00FB' },
        { win1252:'\xc3\xbc', utf16:'\u00FC' },
        { win1252:'\xc3\xbd', utf16:'\u00FD' },
        { win1252:'\xc3\xbe', utf16:'\u00FE' },
        { win1252:'\xc3\xbf', utf16:'\u00FF' }
        ];

export async function onRequest(context) {
	const { request, env, params, waitUntil, next, data, } = context;

	const Query = new URL(request.url).searchParams
	const video = Query.get("v") || false

	if ( !!video && request.method == "GET" ) {
	    const init = {
	        method: 'GET',
	        headers: {
	            'content-type': 'text/html; charset=windows-1251',
	            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36', 
	        },
	    }

	    const response = await fetch("https://video.sibnet.ru/shell.php?videoid=" + video, init)

	    var meta = {}
	    const html = await response.text()

	    var durationM = html.match(/<meta property=\"og:duration\" content="([^")]*)\"\/>/);
	    if (durationM) { meta["duration"] = durationM[1]; }

	    var thumbnailM = html.match(/<meta property=\"og:image\" content="([^")]*)\"\/>/);
	    if (thumbnailM) { meta["thumbnail"] = thumbnailM[1].replaceAll('&amp;', '&'); }

	    var titleM = html.match(/<meta property=\"og:title\" content="([^")]*)\"\/>/);
	    if (titleM) { meta["embed"] = await bruteForceWindows1252toUTF16(titleM[1].replaceAll('&amp;', '&')); }

	    return new Response(JSON.stringify(meta), {
	        headers: {
	            "content-type": "application/json; charset=UTF-16"
	        }
	    })
	} else {
	    return new Response("", {status: 400})
	}
}