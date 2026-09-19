# Development

## Stack

- **Lua** gamemode for Garry's Mod (`cinema_modded`)
- Supporting **HTML/JS** for in-theater playback (loaded via `cinema_url`)
- Module loader under `gamemode/modules/` with standard `sh_` / `sv_` / `cl_` prefixes

Authoritative contribution rules for humans and automation: [AGENTS.md](../AGENTS.md).

## Module overview

| Module | Role |
|--------|------|
| `theater` | Theater class, queue, video services, networking |
| `rent` | Private theater renting |
| `scoreboard` | Queue, owner/admin, request, settings UI |
| `location` | Named locations / theater bounds |
| `seats` | Seat placement helpers |
| `control` | Input / control helpers |
| `playermodel` | Playermodel integration |
| `names` / `taunts` / `warning` | Ancillary UX |

Shared init paths: `gamemode/shared.lua`, `sh_load.lua`, `cl_init.lua`, `init.lua`.

## Conventions

- **Tabs** for indentation; no trailing whitespace  
- Strict **CLIENT / SERVER / SHARED** separation  
- Prefer extending theater/rent APIs over monkey-patching core GMod functions  
- Network explicitly; avoid large unstructured tables when a fixed layout works  
- Clean up hooks, timers, and net receivers  

## Theater renting integration

Rent extends `theater.THEATER` on the server (`RequestOwner` disabled for automatic ownership; ownership comes from paid rent). Client UI lives in scoreboard + `rent` VGUI. See [Theater renting](theater-renting.md).

## i18n

Locale files: `cinema_modded/gamemode/i18n/languages/*.lua`.  
Missing keys fall back to English. Rent-related keys use the `Rent_` prefix.

## Testing checklist

- [ ] Public theater request + voteskip  
- [ ] Private theater without rent (if `cinema_rent_prevent_unrented` is `0`)  
- [ ] Full rent lifecycle: rent → extend → refund  
- [ ] Disconnect / reconnect while rented  
- [ ] Admin cancel online and offline  
- [ ] At least one non-YouTube service if you change providers  
- [ ] No currency addon → rent blocked with announcement  

## Useful links

- [Garry's Mod Wiki](https://wiki.facepunch.com/gmod/)  
- [garrysmod-issues](https://github.com/Facepunch/garrysmod-issues)  
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix)
