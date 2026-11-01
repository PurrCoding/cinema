# Development

This page is the starting point for contributors working on the Garry's Mod Lua gamemode and its HTML/JavaScript playback layer.

## Stack and entry points

- **Lua:** Garry's Mod gamemode under `cinema_modded/`
- **HTML/CSS/JavaScript:** embedded browser/player pages and service integrations
- **Module loader:** `cinema_modded/gamemode/modules/`, using `sh_`, `sv_`, and `cl_` file prefixes
- **Contributor rules:** [AGENTS.md](../AGENTS.md)

Important entry points include `gamemode/shared.lua`, `gamemode/sh_load.lua`, `gamemode/cl_init.lua`, and `gamemode/init.lua`.

## Module overview

| Module | Responsibility |
|---|---|
| `theater` | Theater class, queue, video objects, media services, and networking |
| `rent` | Private-theater renting, currency providers, filters, refunds |
| `scoreboard` | Queue, request, owner/admin, and settings UI |
| `location` | Named map areas, theater bounds, spatial lookup, diagnostics |
| `seats` | Chair model offsets, use behavior, and editor |
| `control` | Input and control helpers |
| `playermodel` | Playermodel selection UI |
| `names`, `taunts`, `warning` | Supporting player-facing features |

## Repository layout

```text
cinema_modded/
  gamemode/
    modules/
      theater/
      rent/
      scoreboard/
      location/
      seats/
      control/
      playermodel/
    i18n/
    maps/
  entities/
  content/
  cinema.fgd
docs/
README.md
AGENTS.md
```

## Conventions

- Follow the existing code style and use tabs for Lua indentation.
- Keep CLIENT, SERVER, and SHARED responsibilities explicit.
- Treat client and CEF input as untrusted; validate authoritative actions on the server.
- Prefer existing module APIs and abstractions over parallel implementations.
- Validate network messages, permissions, ownership, and input ranges server-side.
- Clean up hooks, timers, entities, and temporary state.
- Avoid expensive work in frequent hooks and hot paths.
- Keep browser-to-Lua messages narrow, named, and validated.

## Theater renting integration

The rent module extends the theater implementation and provides currency abstraction, rent lifecycle, refunds, and player filters. Built-in currency integrations are PointShop 1 and PointShop 2. See [Theater renting](theater-renting.md).

## Translations

Locale files live under `cinema_modded/gamemode/i18n/languages/`; the schema is maintained in `schema.lua`. See [Translations](translations.md).

## Verification

After a change, test the relevant path in a multiplayer environment where practical. Check invalid input, permissions, player disconnects, map cleanup, timer/hook cleanup, CEF loading, and synchronization between players.

## Useful references

- [Garry's Mod Wiki](https://wiki.facepunch.com/gmod/)
- [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool)
- [AGENTS.md](../AGENTS.md)
- [Documentation index](README.md)
