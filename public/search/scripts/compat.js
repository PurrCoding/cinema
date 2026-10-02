'use strict';

(function () {
  var ua = navigator.userAgent || '';
  var legacyGmod = /GMod\/13/i.test(ua) && /Chrome\/86\./i.test(ua);

  window.MP_LEGACY_GMOD = legacyGmod;

  if (legacyGmod) {
    var root = document.documentElement;
    root.className += (root.className ? ' ' : '') + 'legacy-gmod';
  }

  function copyTextFallback(value) {
    return new Promise(function (resolve, reject) {
      var textarea = document.createElement('textarea');
      textarea.value = value;
      textarea.setAttribute('readonly', '');
      textarea.style.position = 'fixed';
      textarea.style.left = '-9999px';
      textarea.style.top = '0';
      document.body.appendChild(textarea);

      textarea.focus();
      textarea.select();

      var copied = false;
      try {
        copied = document.execCommand('copy');
      } catch (error) {
        copied = false;
      }

      document.body.removeChild(textarea);

      if (copied) resolve();
      else reject(new Error('Clipboard unavailable'));
    });
  }

  if (legacyGmod && (!navigator.clipboard || typeof navigator.clipboard.writeText !== 'function')) {
    try {
      Object.defineProperty(navigator, 'clipboard', {
        configurable: true,
        value: {
          writeText: copyTextFallback
        }
      });
    } catch (error) {
      window.MP_COPY_TEXT = copyTextFallback;
    }
  }

  var fa = document.createElement('link');
  fa.rel = 'stylesheet';
  fa.href = legacyGmod
    ? 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.7.2/css/all.min.css'
    : 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.3.1/css/all.min.css';
  document.head.appendChild(fa);
})();