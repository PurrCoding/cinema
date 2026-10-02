'use strict';

CINEMA_I18N.registerLanguage('en', {
  'hero.eyebrow': 'Pick something to watch',
  'hero.title': 'What do you want to play?',
  'hero.description': 'Paste a media URL, or choose a service below.',
  'url.placeholder': 'https://youtube.com/watch?v=...',
  'url.aria': 'Media URL',
  'url.request': 'Request media',
  'url.support': 'Supported formats & examples',
  'services.kicker': 'SERVICES',
  'services.title': 'Choose a provider',
  'services.empty': 'No service matches your search.',
  'codec.kicker': 'CODEC REQUIRED',
  'codec.title': 'GModPatchTool is required',
  'codec.body': 'needs the H.264 codec support provided by GModPatchTool.',
  'codec.step1': 'Install/apply GModPatchTool.',
  'codec.step2': 'Restart Garry\'s Mod completely.',
  'codec.step3': 'Return here and try the service again.',
  'codec.cancel': 'Not now',
  'codec.get': 'Get GModPatchTool',
  'support.kicker': 'REFERENCE',
  'support.title': 'Supported formats & URLs',
  'support.intro': 'These examples reflect the URL services currently implemented in Cinema.',
  'support.copy': 'Copy example',
  'toast.copied': 'Example URL copied.',
  'toast.paste': 'Paste a media URL first.',
  'toast.invalid': 'Please enter a valid HTTP(S) URL.',
  'toast.bridge': 'Cinema request bridge is unavailable.',
  'toast.sent': 'Media request sent.',
  'dialog.close': 'Close dialog',
  'dialog.closeSupport': 'Close supported formats'
});

CINEMA_I18N.registerLanguage('de', {
  'hero.eyebrow': 'Etwas zum Anschauen auswählen',
  'hero.title': 'Was möchtest du abspielen?',
  'hero.description': 'Füge eine Medien-URL ein oder wähle unten einen Dienst.',
  'url.placeholder': 'https://youtube.com/watch?v=...',
  'url.aria': 'Medien-URL',
  'url.request': 'Medium anfragen',
  'url.support': 'Unterstützte Formate & Beispiele',
  'services.kicker': 'DIENSTE',
  'services.title': 'Dienst auswählen',
  'services.empty': 'Kein passender Dienst gefunden.',
  'codec.kicker': 'CODEC ERFORDERLICH',
  'codec.title': 'GModPatchTool wird benötigt',
  'codec.body': 'benötigt die von GModPatchTool bereitgestellte H.264-Codec-Unterstützung.',
  'codec.step1': 'GModPatchTool installieren und anwenden.',
  'codec.step2': 'Garry\'s Mod vollständig neu starten.',
  'codec.step3': 'Hierher zurückkehren und den Dienst erneut versuchen.',
  'codec.cancel': 'Nicht jetzt',
  'codec.get': 'GModPatchTool herunterladen',
  'support.kicker': 'REFERENZ',
  'support.title': 'Unterstützte Formate & URLs',
  'support.intro': 'Diese Beispiele zeigen die aktuell in Cinema implementierten URL-Dienste.',
  'support.copy': 'Beispiel kopieren',
  'toast.copied': 'Beispiel-URL kopiert.',
  'toast.paste': 'Bitte zuerst eine Medien-URL einfügen.',
  'toast.invalid': 'Bitte eine gültige HTTP(S)-URL eingeben.',
  'toast.bridge': 'Die Cinema-Request-Verbindung ist nicht verfügbar.',
  'toast.sent': 'Medienanfrage gesendet.',
  'dialog.close': 'Dialog schließen',
  'dialog.closeSupport': 'Unterstützte Formate schließen'
});

for (const code of ['fr','es-es','it','pt-br','ru','uk','pl','nl','sv-se','da','nb','fi','tr','ja','ko','zh-cn','zh-tw','en-pt']) {
  CINEMA_I18N.registerLanguage(code, {});
}
