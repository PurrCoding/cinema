'use strict';

/**
 * Called when the user either clicks the URL request button or presses
 * enter on it.
 */
function requestUrl() {
    var elem = document.getElementById('urlinput'),
        url = elem.value;

    if (url.length === 0) { return; }

    if (typeof gmod !== 'undefined' && gmod.clickSound) {
        gmod.requestUrl(url);
    }
}

/**
 * Called when the user presses a key while focused on the URL input
 * text box.
 *
 * @param  {KeyboardEvent} event Keyboard event.
 */
function onUrlKeyDown(event) {
    var key = event.keyCode || event.which;

    // submit request when the enter key is pressed
    if (key === 13) {
        requestUrl();
    }
}

/**
 * Emit UI sounds (true = click, false = hover)
 */
function playUISound(click) {
    if (typeof gmod !== 'undefined' && gmod.clickSound) {
        gmod.clickSound(click);
    }
}

/**
 * Called when a user hovers over a service icon.
 */
function hoverService() {
    playUISound(false);
}

/**
 * Called when a user selects a service to navigate to.
 *
 * @param  {HTMLElement} elem DOM element.
 */
function selectService(elem) {
    playUISound(true);

    var href = elem.dataset.href;
    window.location.href = href;
}