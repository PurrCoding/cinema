# Translations (i18n)

Cinema ships with **20+ locale files**. Missing keys always fall back to English.

---

## File locations

```
cinema_modded/gamemode/i18n/
  init.lua          -- loader
  schema.lua        -- authoritative list of required keys
  colors.lua
  languages/
    en.lua          -- English (fallback)
    de.lua
    fr.lua
    …
```

---

## Adding or updating a language

1. Copy `en.lua` to a new file, e.g. `languages/pt.lua`.
2. Translate every string value. Keep the **keys** identical.
3. Set the metadata at the top:

```lua
return {
	Name = "Português",
	Author = "YourName",
	-- … all other keys
}
```

4. Restart the client / server. The language appears in the scoreboard settings if the file is valid.

---

## Schema

`schema.lua` lists every key the gamemode expects.  
When you add a new user-facing string in Lua, also add the key to the schema and to **every** language file (or at least to `en.lua`).

Examples of key groups:

- `Theater_*` – announcements (requested, skipped, paused, …)
- `Queue_*` / `Request_*` – queue & request UI
- `Rent_*` – theater renting UI
- `Warning_*` / `Dependency_*` – missing map / codec warnings

---

## Using translations in code

```lua
-- Simple key
theater.GetTranslation("Theater_RequestFailed")

-- Key with format arguments
theater.GetTranslation("Theater_VideoRequestedBy", ply:Nick())
```

On the client the same helpers are available; the active language is chosen from the player’s setting / ConVar.

---

## Best practices

- Never hard-code English UI strings in new features; always go through the translation system.
- Keep format placeholders consistent (`%s`, `%d`, …) across languages.
- Test with a non-English locale to catch missing keys early.
- Rent-related strings use the `Rent_` prefix – keep that convention.
