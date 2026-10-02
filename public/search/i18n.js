'use strict';

const CINEMA_I18N = {
  _languages: {},
  _currentLang: 'en',

  registerLanguage(code, strings) {
    this._languages[code.toLowerCase()] = strings;
  },

  setLanguage(lang) {
    const code = String(lang || '').toLowerCase();
    this._currentLang = this._languages[code] ? code : 'en';
    this.applyTranslations();
    document.documentElement.lang = this._currentLang;
  },

  t(key) {
    const lang = this._languages[this._currentLang];
    if (lang && lang[key] !== undefined) return lang[key];
    const fallback = this._languages.en;
    return fallback && fallback[key] !== undefined ? fallback[key] : key;
  },

  applyTranslations() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
      el.textContent = this.t(el.getAttribute('data-i18n'));
    });
    document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
      el.placeholder = this.t(el.getAttribute('data-i18n-placeholder'));
    });
    document.querySelectorAll('[data-i18n-aria-label]').forEach(el => {
      el.setAttribute('aria-label', this.t(el.getAttribute('data-i18n-aria-label')));
    });
  },

  initFromHash() {
    const match = window.location.hash.match(/(?:^|[&#])lang=([a-zA-Z-]+)/);
    this.setLanguage(match ? match[1] : 'en');
  }
};

window.CINEMA_I18N = CINEMA_I18N;
