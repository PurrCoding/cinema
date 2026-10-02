'use strict';

const services = [
  { name: 'YouTube', icon: 'fa-brands fa-youtube', url: 'https://youtube.com/', requiresCodec: false, group: 'Video' },
  { name: 'SoundCloud', icon: 'fa-brands fa-soundcloud', url: 'https://soundcloud.com/discover', requiresCodec: false, group: 'Audio' },
  { name: 'Dailymotion', icon: 'fa-brands fa-dailymotion', url: 'https://www.dailymotion.com/', requiresCodec: true, group: 'Video' },
  { name: 'Twitch', icon: 'fa-brands fa-twitch', url: 'https://www.twitch.tv/', requiresCodec: true, group: 'Live' },
  { name: 'Rumble', icon: 'fa-solid fa-play', url: 'https://rumble.com/', requiresCodec: true, group: 'Video' },
  { name: 'Kick', icon: 'fa-brands fa-kickstarter', url: 'https://kick.com/', requiresCodec: true, group: 'Live' },
  { name: 'Bilibili', icon: 'fa-brands fa-bilibili', url: 'https://www.bilibili.com/', requiresCodec: true, group: 'Video', action: 'steam-overlay' },
  { name: 'Archive', icon: 'fa-brands fa-internet-archive', url: 'https://archive.org/details/movies', requiresCodec: true, group: 'Archive' },
  { name: 'VK Видео', icon: 'fa-brands fa-vk', url: 'https://vkvideo.ru/', requiresCodec: true, group: 'Video' },
  { name: 'Одноклассники', icon: 'fa-brands fa-odnoklassniki', url: 'https://ok.ru/video', requiresCodec: true, group: 'Video' }
];

let hasCodecSupport = false;

const supportGroups = [
  {
    title: 'Images',
    icon: 'fa-regular fa-image',
    note: 'Direct image URL. The extension is used to identify the media type.',
    items: [
      ['.jpg / .jpeg', 'https://example.com/poster.jpg'],
      ['.png', 'https://example.com/image.png'],
      ['.gif', 'https://example.com/animation.gif'],
      ['.bmp', 'https://example.com/image.bmp']
    ]
  },
  {
    title: 'Video',
    icon: 'fa-solid fa-video',
    note: 'MP4, MOV and MKV use the proprietary-video service and require GModPatchTool. WebM does not.',
    items: [
      ['.webm', 'https://example.com/video.webm'],
      ['.mp4', 'https://example.com/video.mp4'],
      ['.mov', 'https://example.com/video.mov'],
      ['.mkv', 'https://example.com/video.mkv']
    ]
  },
  {
    title: 'Audio',
    icon: 'fa-solid fa-music',
    note: 'Direct audio files are handled by the basic URL service.',
    items: [
      ['.mp3', 'https://example.com/audio.mp3'],
      ['.wav', 'https://example.com/audio.wav'],
      ['.ogg', 'https://example.com/audio.ogg'],
      ['.m4a', 'https://example.com/audio.m4a'],
      ['.aac', 'https://example.com/audio.aac'],
      ['.flac', 'https://example.com/audio.flac']
    ]
  },
  {
    title: 'Streaming',
    icon: 'fa-solid fa-tower-broadcast',
    note: 'The file extension must be visible to Cinema so it can select HLS or DASH.',
    items: [
      ['.m3u8', 'https://example.com/stream.m3u8'],
      ['.mpd', 'https://example.com/manifest.mpd']
    ]
  },
  {
    title: 'Direct URL sources',
    icon: 'fa-solid fa-link',
    note: 'These are example URLs only. Other public HTTPS URLs can work too, as long as they provide direct media playback without requiring a web page. Local files, localhost/private hosts and IP-address URLs are not supported.',
    items: [
      ['Own domain', 'https://media.example.com/video.mp4'],
      ['Discord CDN', 'https://cdn.discordapp.com/attachments/CHANNEL_ID/MESSAGE_ID/video.mp4'],
      ['Bunny CDN', 'https://your-zone.b-cdn.net/video.mp4']
    ]
  },
  {
    title: 'Supported service URLs',
    icon: 'fa-solid fa-globe',
    note: 'Share/provider URLs are matched by their service implementation.',
    items: [
      ['YouTube', 'https://www.youtube.com/watch?v=VIDEO_ID'],
      ['Twitch', 'https://www.twitch.tv/CHANNEL'],
      ['SoundCloud', 'https://soundcloud.com/artist/track'],
      ['Dailymotion', 'https://www.dailymotion.com/video/VIDEO_ID'],
      ['Rumble', 'https://rumble.com/VIDEO_PATH.html'],
      ['Kick', 'https://kick.com/CHANNEL'],
      ['Bilibili', 'https://www.bilibili.com/video/VIDEO_ID'],
      ['Archive.org', 'https://archive.org/details/ITEM_ID'],
      ['VK Video', 'https://vkvideo.ru/video-VIDEO_ID'],
      ['Одноклассники', 'https://ok.ru/video/VIDEO_ID'],
      ['Google Drive', 'https://drive.google.com/file/d/FILE_ID/view'],
      ['MEGA', 'https://mega.nz/file/FILE_ID#KEY'],
      ['Jellyfin', 'https://media.example.com/web/index.html#/details?id=ITEM_ID&serverId=SERVER_ID']
    ]
  }
];

const $ = (selector) => document.querySelector(selector);

function gmodAvailable(name) {
  return typeof gmod !== 'undefined' && typeof gmod[name] === 'function';
}

function checkCodecSupport() {
  const video = document.createElement('video');
  hasCodecSupport = video.canPlayType('video/mp4; codecs="avc1.42E01E"') === 'probably';
  return hasCodecSupport;
}

function playUISound(click) {
  if (gmodAvailable('clickSound')) gmod.clickSound(click);
}

function renderSupportContent() {
  const root = $('#support-content');
  root.innerHTML = supportGroups.map(group => `
    <section class="support-group">
      <div class="support-group-title">
        <span class="support-group-icon"><i class="${group.icon}" aria-hidden="true"></i></span>
        <div><h3>${group.title}</h3><p>${group.note}</p></div>
      </div>
      <div class="support-items">
        ${group.items.map(([label, example]) => `
          <button type="button" class="support-item" data-copy="${example}" title="${'Copy example'}">
            <span class="support-label">${label}</span>
            <code>${example}</code>
            <i class="fa-regular fa-copy" aria-hidden="true"></i>
          </button>
        `).join('')}
      </div>
    </section>
  `).join('');

  root.querySelectorAll('[data-copy]').forEach(button => {
    button.addEventListener('click', async () => {
      const value = button.dataset.copy;
      try {
        await (window.MP_COPY_TEXT ? window.MP_COPY_TEXT(value) : navigator.clipboard.writeText(value));
        showToast('Example URL copied.');
      } catch {
        $('#urlinput').value = value;
        $('#clear-btn').classList.remove('hidden');
        closeSupportPopup();
        $('#urlinput').focus();
      }
    });
  });
}

function showSupportPopup() {
  renderSupportContent();
  $('#support-modal').classList.remove('hidden');
  document.body.style.overflow = 'hidden';
}

function closeSupportPopup() {
  $('#support-modal').classList.add('hidden');
  document.body.style.overflow = '';
}

function showToast(message, type = 'success') {
  const toast = $('#toast');
  $('#toast-text').textContent = message;
  $('#toast-icon').className = type === 'error'
    ? 'fa-solid fa-circle-exclamation'
    : 'fa-solid fa-circle-check';
  toast.classList.remove('hidden');
  clearTimeout(showToast.timer);
  showToast.timer = setTimeout(() => toast.classList.add('hidden'), 2200);
}

function navigateInGmod(url) {
  window.location.href = url;
}

function openService(url) {
  if (!gmodAvailable('openUrl')) {
    showToast('Steam Overlay is unavailable.', 'error');
    return;
  }
  gmod.openUrl(url);
}

function requestUrl() {
  const input = $('#urlinput');
  const url = input.value.trim();

  if (!url) {
    showToast('Paste a media URL first.', 'error');
    input.focus();
    return;
  }

  try {
    const parsed = new URL(url);
    if (!['http:', 'https:'].includes(parsed.protocol)) throw new Error();
  } catch {
    showToast('Please enter a valid HTTP(S) URL.', 'error');
    input.focus();
    return;
  }

  if (!gmodAvailable('requestUrl')) {
    showToast('Cinema request bridge is unavailable.', 'error');
    return;
  }

  $('#submit-btn').disabled = true;
  playUISound(true);
  gmod.requestUrl(url);
  showToast('Media request sent.');
  setTimeout(() => { $('#submit-btn').disabled = false; }, 900);
}

function showCodecPopup(service) {
  $('#service-name-popup').textContent = service.name;
  $('#codec-modal').classList.remove('hidden');
  document.body.style.overflow = 'hidden';
}

function closeCodecPopup() {
  $('#codec-modal').classList.add('hidden');
  document.body.style.overflow = '';
}

function selectService(service) {
  playUISound(true);
  if (service.action === 'steam-overlay') {
    openService(service.url);
    return;
  }
  navigateInGmod(service.url);
}

function renderServices(filter = '') {
  const grid = $('#services-grid');
  const matches = services.filter(service => !(window.MP_LEGACY_GMOD === true && service.requiresCodec));

  grid.innerHTML = '';
  $('#empty-state').classList.toggle('hidden', matches.length > 0);

  matches.forEach(service => {
    const disabled = service.requiresCodec && !hasCodecSupport;
    const card = document.createElement('button');
    card.type = 'button';
    card.className = 'service-card' + (disabled ? ' disabled' : '') + (service.requiresCodec ? ' codec-required' : '');
    card.innerHTML = `
      <span class="service-icon"><i class="${service.icon}" aria-hidden="true"></i></span>
      <span class="service-meta">
        <span>
          <span class="service-name">${service.name}</span>
          ${disabled ? '<span class="service-sub">Codec needed</span>' : ''}
        </span>
        ${disabled ? '<span class="badge">CODEC</span>' : '<span class="service-arrow"><i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i></span>'}
      </span>
    `;
    card.addEventListener('mouseenter', () => playUISound(false));
    card.addEventListener('click', () => disabled ? showCodecPopup(service) : selectService(service));
    grid.appendChild(card);
  });
}

function initialize() {
  checkCodecSupport();
  renderServices();

  $('#submit-btn').addEventListener('click', requestUrl);
  $('#urlinput').addEventListener('keydown', event => {
    if (event.key === 'Enter') requestUrl();
  });
  $('#urlinput').addEventListener('input', event => {
    $('#clear-btn').classList.toggle('hidden', !event.target.value);
  });
  $('#clear-btn').addEventListener('click', () => {
    $('#urlinput').value = '';
    $('#clear-btn').classList.add('hidden');
    $('#urlinput').focus();
  });
  $('#support-info-btn').addEventListener('click', showSupportPopup);

  document.querySelectorAll('[data-action="close-support"]').forEach(el => {
    el.addEventListener('click', closeSupportPopup);
  });

  document.querySelectorAll('[data-action="close-codec"]').forEach(el => {
    el.addEventListener('click', closeCodecPopup);
  });
  $('[data-action="codec-instructions"]').addEventListener('click', () => {
    navigateInGmod('https://www.solsticegamestudios.com/fixmedia/');
    closeCodecPopup();
  });

  document.addEventListener('keydown', event => {
    if (event.key === 'Escape') {
      closeCodecPopup();
      closeSupportPopup();
    }
    if (
      document.activeElement !== $('#urlinput') &&
      !event.ctrlKey && !event.metaKey && !event.altKey &&
      event.key.length === 1
    ) $('#urlinput').focus();
  });
}

document.addEventListener('DOMContentLoaded', initialize);
window.requestUrl = requestUrl;