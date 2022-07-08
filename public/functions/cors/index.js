export async function onRequest(context) {
	const { request, env } = context;
	const { pathname, searchParams } = new URL(request.url);


	fetch(searchParams.get("url")); {
		return new Response('Hello');
	}
}