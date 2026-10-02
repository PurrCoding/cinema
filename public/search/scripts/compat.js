'use strict';

(function () {
  var ua = navigator.userAgent || '';
  var legacyGmod = /GMod\/13/i.test(ua) && /Chrome\/86\./i.test(ua);

  window.MP_LEGACY_GMOD = legacyGmod;

  if (legacyGmod) {
    var root = document.documentElement;
    root.className += (root.className ? ' ' : '') + 'legacy-gmod';
  }

  var fa = document.createElement('link');
  fa.rel = 'stylesheet';
  fa.href = legacyGmod
    ? 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.7.2/css/all.min.css'
    : 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.3.1/css/all.min.css';
  document.head.appendChild(fa);
})();