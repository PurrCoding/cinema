# Installation

## Requirements

- **Garry's Mod** (x86-64 branch strongly recommended for HTML / Chromium playback)
- A map with Cinema support:
  - Built-in style maps: `theater*`, `cinema*`
  - Or any map that includes theater entities **and** a location definition (see [Creating Custom Maps](creating-custom-maps))
- **Optional but highly recommended:** [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) for broader video codec support (H.264, etc.)

> **Conflict warning**  
> This gamemode **conflicts** with the original PixelTail “Cinema” addon and any forks/re-uploads of it.  
> Unsubscribe / remove every other Cinema addon before using Fixed Edition.

---

## Method 1 – Steam Workshop (easiest for players & most servers)

1. Subscribe to the [Workshop addon](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587).
2. For a dedicated server, add the Workshop ID `2419005587` to your collection or `workshopid` list.
3. Restart the server / client.
4. Select the gamemode **Cinema (Fixed Edition)** (`cinema_modded`) and start a supported map.

Workshop builds can lag behind the Git repository. Prefer Git when you need the absolute newest features or when developing.

---

## Method 2 – From this repository (recommended for servers & developers)

1. Download or clone the repository:
   ```bash
   git clone https://github.com/PurrCoding/cinema.git
   ```
2. Copy the **`cinema_modded`** folder into:
   ```
   garrysmod/gamemodes/cinema_modded
   ```
3. Restart the game or server.
4. Set the gamemode:
   - **Listen / single-player / menu:** choose *Cinema (Fixed Edition)* in the gamemode list.
   - **Dedicated server:** in `server.cfg` or launch options:
     ```
     gamemode cinema_modded
     ```
5. Start a supported map.

---

## Currency providers (theater renting)

If you want the optional [theater renting](theater-renting) system, install one of:

- PointShop 1
- PointShop 2 (standard or premium points)

The rent module auto-detects a provider. You can force one with the ConVar `cinema_rent_currency`.

---

## Verification checklist

1. Join a private or public theater area on a supported map.
2. Open the scoreboard (default `TAB`) → queue panel.
3. Confirm **Request Video** (and **Rent Theater** if renting is configured) appears.
4. Paste a short YouTube (or other supported) URL and confirm synchronized playback for all players in the theater.
5. If the screen stays black / no media:
   - Confirm you are **not** running the original Cinema addon.
   - Confirm the map has location + theater data.
   - Confirm CEF Codec Fix + x86-64 branch if using advanced codecs.
   - Try `cinema_refresh` in console.

---

## Common problems

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Missing textures / menus | Old Cinema still subscribed | Unsubscribe original Cinema, restart GMod |
| Doors / screens do nothing | Running Sandbox instead of the gamemode | `gamemode cinema_modded` then changelevel |
| “Map unsupported” message | Missing location Lua for the map | Add a map file under `gamemode/maps/` (see [Creating Custom Maps](creating-custom-maps)) |
| Black screen / no video | Missing codecs or wrong CEF | Install GMod CEF Codec Fix, use x86-64 branch |
| History / DB errors | First run or permissions | Let the gamemode create its SQLite tables; check server write permissions |

---

## Related pages

- [Configuration](configuration) – all ConVars
- [Commands](commands) – player & admin commands
- [Creating Custom Maps](creating-custom-maps) – make your own cinema map
