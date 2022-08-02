async function handleRequest(request) {
	const Query = new URL(request.url).searchParams
	const video = Query.get("v") || false

    const init = {
        method: 'GET',
        headers: {
            'content-type': 'text/html; charset=UTF-8',
            'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36', 
        },
    }

    const response = await fetch("https://vk.com/video?z=" + video, init)

    var meta = {}
    const html = await response.text()

    var durationM = html.match(/<meta property=\"og:video:duration\" content="([^")]*)\"\/>/);
    if (durationM) { meta["duration"] = durationM[1]; }

    var thumbnailM = html.match(/<meta property=\"og:image:secure_url\" content="([^")]*)\"\/>/);
    if (thumbnailM) { meta["thumbnail"] = thumbnailM[1].replaceAll('&amp;', '&'); }

    var embedM = html.match(/<meta property=\"og:video\" content="([^")]*)\"\/>/);
    if (embedM) { meta["embed"] = embedM[1].replaceAll('&amp;', '&'); }

    return new Response(JSON.stringify(meta), {
        headers: {
            "content-type": "application/json; charset=UTF-8"
        }
    })
}

export async function onRequestGet(request) {
	return handleRequest(request);
}