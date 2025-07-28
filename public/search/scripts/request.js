'use strict';

// Service definitions with dependency requirements
const services = [
	{ name: 'YouTube', icon: 'youtube', url: 'https://youtube.com/', action: 'select', requiresCodec: false },
	{ name: 'TikTok', icon: 'tiktok', url: 'https://tiktok.com/', action: 'select', requiresCodec: true },
	{ name: 'SoundCloud', icon: 'soundcloud', url: 'https://soundcloud.com/discover', action: 'select', requiresCodec: false },
	{ name: 'Dailymotion', icon: 'dailymotion', url: 'https://www.dailymotion.com/', action: 'select', requiresCodec: true },
	{ name: 'Twitch', icon: 'twitch', url: 'https://www.twitch.tv/', action: 'select', requiresCodec: true },
	{ name: 'Rumble', icon: 'rumble', url: 'https://rumble.com/', action: 'select', requiresCodec: true },
	{ name: 'DLive', icon: 'dlive', url: 'https://dlive.tv/', action: 'select', requiresCodec: true },
	{ name: 'Kick', icon: 'kick', url: 'https://kick.com/', action: 'select', requiresCodec: true },
	{ name: 'Bilibili', icon: 'bilibili', url: 'https://www.bilibili.tv/', action: 'open', requiresCodec: true },
	{ name: 'Archive', icon: 'archive', url: 'https://archive.org/details/movies', action: 'select', requiresCodec: true },
	{ name: 'VKontakte', icon: 'vk', url: 'https://vk.com/video', action: 'select', requiresCodec: true },
	{ name: 'Sibnet', icon: 'sibnet', url: 'https://video.sibnet.ru/rub/anime/', action: 'select', requiresCodec: true },
	{ name: 'OK', icon: 'ok', url: 'https://ok.ru/video', action: 'select', requiresCodec: true },
	{ name: 'Rutube', icon: 'rutube', url: 'https://rutube.ru/', action: 'open', requiresCodec: true }
];

// Simplified codec checking (removed x86-64 requirement)
let hasCodecSupport = false;

function checkCodecSupport() {
	return new Promise((resolve) => {
		const video = document.createElement('video');
		const support = video.canPlayType('video/mp4; codecs="avc1.42E01E"') === "probably";
		hasCodecSupport = support;
		resolve({ hasCodecSupport: support });
	});
}

// Initialize services grid with codec-based disabling
async function initializeServices() {
	const grid = document.getElementById('services-grid');
	const codecCheck = await checkCodecSupport();

	services.forEach(service => {
		const card = document.createElement('div');
		card.className = 'service-card';
		card.dataset.href = service.url;
		card.dataset.action = service.action;
		card.dataset.serviceName = service.name;

		// Disable service if it requires codec and codec is not available
		const isDisabled = service.requiresCodec && !codecCheck.hasCodecSupport;

		if (isDisabled) {
			card.classList.add('service-disabled');
			// Add click handler for popup instead of title attribute
			card.addEventListener('click', (e) => {
				e.preventDefault();
				showCodecPopup(service.name);
			});
		} else {
			card.addEventListener('click', () => selectService(card));
			card.addEventListener('mouseenter', hoverService);
		}

		card.innerHTML = `
			<div class="service-icon logo-${service.icon}"></div>
			<div class="service-name">${service.name}</div>
			${isDisabled ? '<div class="disabled-overlay">Codec Required</div>' : ''}
		`;

		grid.appendChild(card);
	});
}

// Show codec requirements popup
function showCodecPopup(serviceName) {
	const popup = document.getElementById('codec-popup');
	const serviceNameElement = document.getElementById('service-name-popup');

	serviceNameElement.textContent = serviceName;
	popup.classList.remove('hidden');

	// Prevent body scroll when popup is open
	document.body.style.overflow = 'hidden';
}

// Close codec popup
function closeCodecPopup() {
	const popup = document.getElementById('codec-popup');
	popup.classList.add('hidden');

	// Restore body scroll
	document.body.style.overflow = '';
}

// Open codec fix instructions
function openCodecInstructions() {
	const url = 'https://www.solsticegamestudios.com/fixmedia/';

	if (typeof gmod !== 'undefined' && gmod.openUrl) {
		gmod.openUrl(url);
	} else {
		window.open(url, '_blank');
	}
	closeCodecPopup();
}

// Simplified service selection (no codec warning, just block disabled services)
function selectService(elem) {
	if (elem.classList.contains('service-disabled')) {
		return; // Do nothing for disabled services
	}

	playUISound(true);

	const href = elem.dataset.href;
	const action = elem.dataset.action;

	if (action === 'open') {
		openService(elem);
	} else {
		window.location.href = href;
	}
}

function openService(elem) {
	const href = elem.dataset.href;
	if (typeof gmod !== 'undefined' && gmod.openUrl) {
		gmod.openUrl(href);
	} else {
		window.open(href, '_blank');
	}
}

// Enhanced URL request with codec checking
async function requestUrl() {
	const elem = document.getElementById('urlinput');
	const url = elem.value.trim();
	const statusIndicator = document.getElementById('status-indicator');
	const statusText = document.getElementById('status-text');
	const submitBtn = document.getElementById('submit-btn');

	if (url.length === 0) return;

	// Show loading state
	statusIndicator.classList.remove('hidden');
	statusText.textContent = 'Validating URL...';
	submitBtn.disabled = true;

	/* Needs further implementation
	try {
		// Basic URL validation
		new URL(url);

		// Check if URL requires codec support
		const requiresCodec = url.includes('youtube') || url.includes('bilibili') || url.includes('dailymotion');

		if (requiresCodec && !hasCodecSupport) {
			statusText.textContent = 'URL requires CEF Codec Fix';
			setTimeout(() => {
				statusIndicator.classList.add('hidden');
			}, 3000);
			return;
		}

		statusText.textContent = 'Requesting video...';

		// Call GMod function or fallback
		if (typeof gmod !== 'undefined' && gmod.requestUrl) {
			gmod.requestUrl(url);
		} else {
			console.log('Would request URL:', url);
		}

		statusText.textContent = 'Request sent!';
		setTimeout(() => {
			statusIndicator.classList.add('hidden');
		}, 2000);

	} catch (error) {
		statusText.textContent = 'Invalid URL format';
		setTimeout(() => {
			statusIndicator.classList.add('hidden');
		}, 3000);
	} finally {
		submitBtn.disabled = false;
	}
	*/

	// This will do for now..
	statusText.textContent = 'Request sent!';
	setTimeout(() => {
		statusIndicator.classList.add('hidden');
	}, 2000);

	if (typeof gmod !== 'undefined' && gmod.requestUrl) {
		gmod.requestUrl(url);
	}
}

function onUrlKeyDown(event) {
	const key = event.keyCode || event.which;
	if (key === 13) {
		requestUrl();
	}
}

function playUISound(click) {
	if (typeof gmod !== 'undefined' && gmod.clickSound) {
		gmod.clickSound(click);
	}
}

function hoverService() {
	playUISound(false);
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
	initializeServices();
});

// Global functions for compatibility
window.requestUrl = requestUrl;
window.selectService = selectService;
window.openService = openService;
window.hoverService = hoverService;