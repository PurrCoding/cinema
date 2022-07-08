export async function onRequest(context) {
	const { request, env } = context;
	const { pathname, searchParams } = new URL(request.url);

	// Respond to the requesting caller with the response of the proxied resource.
	return env.ASSETS.fetch(searchParams.get("url"));
}