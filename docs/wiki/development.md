# Development

## Stack

- **Lua** gamemode for Garry's Mod (`cinema_modded`)
- Supporting **HTML/JS** for in-theater playback (loaded via `cinema_url`)
- Module loader under `gamemode/modules/` with standard `sh_` / `sv_` / `cl_` prefixes

Authoritative contribution rules for humans and automation: [AGENTS.md](https://github.com/PurrCoding/cinema/blob/master/AGENTS.md).

---

## Module overview

| Module | Role |
|--------|------|
| `theater` | Theater class, queue, video services, networking |
| `rent` | Private theater renting |
| `scoreboard` | Queue, owner/admin, request, settings UI |
| `location` | Named locations / theater bounds + spatial grid |
| `seats` | Seat placement helpers |
| `control` | Input / control helpers |
| `playermodel` | Playermodel integration |
| `names` / `taunts` / `warning` | Ancillary UX |

Shared init paths: `gamemode/shared.lua`, `sh_load.lua`, `cl_init.lua`, `init.lua`.

---

## Repository layout

```
cinema_modded/                 Gamemode root (install this folder)
  gamemode/
    modules/
      theater/                 Core theater logic & video services
      rent/                    Theater renting system
      scoreboard/              Queue, admin, request UI
      location/                Map location system
      seats/                   Seat helpers / editor
      control/ playermodel/ …
    i18n/                      Translations
    maps/                      Per-map theater / location setup
  entities/                    Theater entities (screen, door, portable, …)
  content/                     Materials, fonts, sounds
  cinema.fgd                   Hammer entity definitions
```

---

## Conventions

- **Tabs** for indentation; no trailing whitespace
- Strict **CLIENT / SERVER / SHARED** separation
- Prefer extending theater/rent APIs over monkey-patching core GMod functions
- Network explicitly; avoid large unstructured tables when a fixed layout works
- Clean up hooks, timers, and net receivers

---

## Theater renting integration

Rent extends `theater.THEATER` on the server (`RequestOwner` disabled for automatic ownership; ownership comes from paid rent).  
Client UI lives in scoreboard + `rent` VGUI. See [Theater renting](theater-renting).

---

## i18n

Locale files: `cinema_modded/gamemode/i18n/languages/*.lua`.  
Missing keys fall back to English. Rent-related keys use the `Rent_` prefix.

---

## Useful links

- [Garry's Mod Wiki](https://wiki.facepunch.com/gmod/)
- [garrysmod-issues](https://github.com/Facepunch/garrysmod-issues)
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix)
- [AGENTS.md](https://github.com/PurrCoding/cinema/blob/master/AGENTS.md) – coding standards for this repository
