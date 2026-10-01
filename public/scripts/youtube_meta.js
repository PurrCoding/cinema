// ─── Debug helpers ────────────────────────────────────────────────────────
const STATE_NAMES = {
	"-1": "UNSTARTED",
	"0": "ENDED",
	"1": "PLAYING",
	"2": "PAUSED",
	"3": "BUFFERING",
	"5": "CUED"
};

let currentVideoId = "";
let requestStart = performance.now();

function dbg(msg) {
	const elapsed = (performance.now() - requestStart).toFixed(1);
	console.log("[YT-META] [" + currentVideoId + " +" + elapsed + "ms] " + msg);
}

function stateName(code) {
	return (STATE_NAMES[String(code)] || "UNKNOWN") + "(" + code + ")";
}

function getParameter(name) {
	const hash = window.location.hash.substring(1);
	if (hash) {
		const hashParams = new URLSearchParams(hash);
		const hashValue = hashParams.get(name);
		if (hashValue) return hashValue;
	}
	const urlParams = new URLSearchParams(window.location.search);
	if (urlParams.get(name)) return urlParams.get(name);
	return null;
}

dbg("Hash: '" + window.location.hash + "' | Search: '" + window.location.search + "'");
dbg("Injecting IFrame API script from https://www.youtube.com/iframe_api");

const tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
tag.onload = function() {
	dbg("IFrame API script loaded successfully.");
};
tag.onerror = function() {
	dbg("ERROR: IFrame API script failed to load (network error or blocked).");
	console.log("ERROR:Failed to load YouTube IFrame API");
};
document.head.appendChild(tag);

let player = null;
let metadataExtracted = false;
let safetyTimeout = null;

function extractAndSend(trigger) {
	if (metadataExtracted) return;
	metadataExtracted = true;

	if (safetyTimeout) {
		clearTimeout(safetyTimeout);
		safetyTimeout = null;
	}

	dbg("extractAndSend() triggered by: " + trigger);

	const videoData = player.getVideoData();
	const playerState = player.getPlayerState();
	const duration = player.getDuration();

	const isPlayable = playerState === YT.PlayerState.PLAYING ||
		playerState === YT.PlayerState.BUFFERING ||
		playerState === YT.PlayerState.CUED;
	const isLive = isPlayable && videoData.isLive;
	const isNormalVideo = isPlayable && duration > 0 && !videoData.isLive;

	const safeDuration = Math.round(duration) || 0;
	player.pauseVideo();

	const metadata = {
		title: videoData.title,
		isLive: isLive,
		duration: safeDuration,
		debug: {
			playerState,
			videoType: isLive ? "live" : (isNormalVideo ? "normal" : "unknown"),
			videoData
		}
	};

	dbg("Emitting METADATA: " + JSON.stringify(metadata));
	console.log("METADATA:" + JSON.stringify(metadata));
}

function onYouTubeIframeAPIReady() {
	const rawVid = getParameter('v');
	const vid = (rawVid && /^[a-zA-Z0-9_-]{11}$/.test(rawVid))
		? rawVid
		: 'dQw4w9WgXcQ';
	createPlayer(vid);
}

function createPlayer(videoId) {
	currentVideoId = videoId;
	requestStart = performance.now();
	metadataExtracted = false;

	if (safetyTimeout) {
		clearTimeout(safetyTimeout);
		safetyTimeout = null;
	}

	if (player && typeof player.destroy === 'function') {
		player.destroy();
		player = null;
		document.getElementById('player-container').innerHTML = '';
	}

	const defaultPlayerVars = {
		controls: 0,
		rel: 0,
		loop: 0,
		disablekb: 1,
		enablejsapi: 1,
		muted: 1,
		cc_load_policy: 0,
		iv_load_policy: 3,
		autoplay: 1
	};

	player = new YT.Player('player-container', {
		height: '100%',
		width: '100%',
		videoId: videoId,
		playerVars: defaultPlayerVars,
		host: 'https://www.youtube-nocookie.com',
		events: {
			onReady: () => {
				player.playVideo();
				player.setVolume(0);
				safetyTimeout = setTimeout(() => {
					extractAndSend("safety-timeout-8s");
				}, 8000);
			},
			onStateChange: (event) => {
				const state = event.data;
				if (state === YT.PlayerState.BUFFERING || state === YT.PlayerState.PLAYING) {
					setTimeout(() => extractAndSend("onStateChange-" + stateName(state)), 100);
				}
			},
			onError: (event) => {
				console.log("ERROR:YouTube player error code " + event.data);
			}
		}
	});
}

if (window.YT && window.YT.Player && !player) {
	if (document.readyState === 'complete') {
		onYouTubeIframeAPIReady();
	} else {
		window.addEventListener('load', onYouTubeIframeAPIReady);
	}
}
