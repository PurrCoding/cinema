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
	    if (titleM) { meta["embed"] = titleM[1].replaceAll('&amp;', '&'); }

	    return new Response(JSON.stringify(meta), {
	        headers: {
	            "content-type": "application/json; charset=windows-1251"
	        }
	    })
	} else {
	    return new Response("", {status: 400})
	}
}