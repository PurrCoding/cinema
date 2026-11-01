# Translations (i18n)

Cinema includes locale files for the player-facing UI. English is the fallback language; missing translations should be added to the schema and locale files as appropriate.

## File locations

```text
cinema_modded/gamemode/i18n/
  init.lua
  schema.lua
  colors.lua
  languages/
    en.lua
    de.lua
    fr.lua
    ...
```

## Adding or updating a language

1. Copy the English locale file as a starting point.
2. Keep translation keys identical; translate the string values only.
3. Preserve format placeholders such as `%s` and `%d`.
4. Preserve any formatting tokens used by the UI.
5. Add new user-facing keys to `schema.lua` and the English fallback, then update other locale files.
6. Test the language in-game, including longer strings and formatted announcements.

Locale files return a table containing metadata and translated values. Follow the structure of the current `en.lua` and neighboring locale files rather than copying an outdated example.

## Schema and key groups

The schema is the authoritative list of expected translation keys. Common prefixes include:

- `Theater_*` – playback and theater announcements
- `Queue_*` / `Request_*` – queue and request UI
- `Rent_*` – theater-renting UI and announcements
- `Warning_*` / `Dependency_*` – warnings and missing dependency notices

## Using translations in code

Use the project's translation helpers rather than hard-coding player-facing English text. Check existing call sites for the current API and formatting conventions.

## Best practices

- Keep placeholders and formatting tokens consistent across locales.
- Avoid changing key names without updating the schema and all call sites.
- Test with at least one non-English locale.
- Update the English fallback whenever a new UI string is introduced.

## Related pages

- [Development](development.md)
- [Theater renting](theater-renting.md)
