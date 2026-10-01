// Get parameter from hash first, then fall back to query parameters
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

const tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
tag.onerror = function () {
	console.log("ERROR:Failed to load YouTube IFrame API");
};
document.head.appendChild(tag);

let player = null;

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

const startPaused = getParameter('paused') === '1';

function onYouTubeIframeAPIReady() {
	const rawVid = getParameter('v');
	const vid = (rawVid && /^[a-zA-Z0-9_-]{11}$/.test(rawVid))
		? rawVid
		: 'dQw4w9WgXcQ';

	const startTime = Math.max(0, parseFloat(getParameter('t')) || 0);

	if (startPaused) {
		defaultPlayerVars.autoplay = 0;
	}

	createPlayer(vid, startTime);
}

function createPlayer(videoId, startTime) {
	if (player && typeof player.destroy === 'function') {
		player.destroy();
		player = null;
		document.getElementById('player-container').innerHTML = '';
	}

	player = new YT.Player('player-container', {
		height: '100%',
		width: '100%',
		videoId: videoId,
		playerVars: {
			...defaultPlayerVars,
			start: Math.floor(startTime)
		},
		host: 'https://www.youtube-nocookie.com',
		events: {
			onReady: () => {
			wrapper._ready = true;

			if (startTime > 0) {
				player.seekTo(startTime, true);
			}

			if (startPaused || wrapper._desiredPaused) {
				player.pauseVideo();
			}

			window.cinema_controller = wrapper;
			exTheater.controllerReady();
		},
			onStateChange: (e) => {
			if (e.data === YT.PlayerState.PLAYING) {
				wrapper._paused = false;
			} else if (e.data === YT.PlayerState.PAUSED ||
				e.data === YT.PlayerState.ENDED) {
				wrapper._paused = true;
			}

			if (e.data === YT.PlayerState.PLAYING ||
				e.data === YT.PlayerState.BUFFERING) {
				player.unloadModule('captions');
			}
		},
			onApiChange: () => {
			try { player.unloadModule('captions'); } catch (e) {}
			try { player.unloadModule('cc'); } catch (e) {}
			try { player.setOption('captions', 'track', {}); } catch (e) {}
			try { player.setOption('cc', 'track', {}); } catch (e) {}
		}
	}
	});

	const wrapper = {
		_ready: false,
		_paused: true,
		_desiredPaused: false,
		play() {
			this._desiredPaused = false;
			this._paused = false;
			if (this._ready) player.playVideo();
		},
		pause() {
			this._desiredPaused = true;
			this._paused = true;
			if (this._ready) player.pauseVideo();
		},
		get currentTime() {
			return this._ready ? player.getCurrentTime() : 0;
		},
		set currentTime(time) {
			if (this._ready) player.seekTo(time, true);
		},
		get volume() {
			return this._ready ? player.getVolume() / 100 : 1;
		},
		set volume(v) {
			if (this._ready) {
				if (player.isMuted()) player.unMute();
				player.setVolume(v * 100);
			}
		},
		get paused() {
			return this._paused;
		}
	};
}

if (window.YT && window.YT.Player && !player) {
	if (document.readyState === 'complete') {
		onYouTubeIframeAPIReady();
	} else {
		window.addEventListener('load', onYouTubeIframeAPIReady);
	}
}
