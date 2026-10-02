# Cinema Search — Reimagined Concept

This directory is a standalone V2 concept for `public/search/`. It does **not** replace the current search page.

## UX direction

- Put the primary action first: paste a URL and request it.
- Treat services as secondary shortcuts rather than the main interaction.
- Replace image-based provider logos with Font Awesome brand icons where available and neutral icons where a brand icon is not available.
- Make provider cards keyboard accessible with real `button` elements.
- Add service filtering without changing the existing provider set.
- Keep the GMod bridge APIs used by the current page:
  - `gmod.requestUrl(url)`
  - `gmod.openUrl(url)`
  - `gmod.clickSound(click)`
- Preserve codec detection and the GModPatchTool explanation.
- Make the page usable in narrow CEF/GMod windows.

## Intentionally not changed

The current `public/search/` implementation, its assets, and its behavior remain untouched. This prototype lives under `public/search/reimagined/` so it can be reviewed independently.

## Font Awesome

The concept loads Font Awesome Free from jsDelivr. For production, the dependency should be evaluated against the target CEF environment; if external CDN loading is unreliable, the same Font Awesome webfont/CSS assets can be vendored into the repository without returning to per-service PNG/SVG files.

## Next step

If the visual direction is approved, this prototype can be promoted into the real `public/search/` page and the old logo assets/CSS can be removed in the same change set.