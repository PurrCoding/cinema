# Cinema (Fixed Edition) Wiki

Community-maintained successor to the original [Cinema](https://github.com/pixeltailgames/cinema) gamemode by PixelTail Games.  
Synchronized multiplayer video streaming on in-game theater screens for Garry's Mod.

**Workshop:** [Cinema (Fixed Edition)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587)  
**Source:** [github.com/PurrCoding/cinema](https://github.com/PurrCoding/cinema)

---

## Guides

| Page | Description |
|------|-------------|
| [Installation](installation) | Server & client setup, requirements, verification |
| [Configuration](configuration) | All server & client ConVars |
| [Commands](commands) | Player, owner, admin and utility console commands |
| [Debug Commands](debug-commands) | Location debugging, visualizers and diagnostics |
| [Location System](location-system) | How locations, theaters and spatial queries work |
| [Creating Custom Maps](creating-custom-maps) | Full mapping tutorial (Hammer + Lua locations) |
| [Theater Renting](theater-renting) | PointShop-based private theater rent system |
| [Video Services](video-services) | Supported providers and how services work |
| [Development](development) | Module layout, contribution and architecture notes |

---

## Quick start

1. Install the gamemode (Workshop or copy `cinema_modded` into `garrysmod/gamemodes/`).
2. Use a supported map (`theater*`, `cinema*`, or any map with theater entities + location data).
3. Set gamemode to `cinema_modded`.
4. For best HTML/video support install [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) and prefer the **x86-64** branch of Garry's Mod.

See [Installation](installation) for details.

---

## Features overview

- Synchronized playback across all players in a theater
- Public & private theaters with queue, vote-skip, seek, pause
- Wide range of video/stream services (YouTube, Twitch, TikTok, SoundCloud, Bilibili, Jellyfin, …)
- Video history with search and pagination
- Per-player volume, mute-on-alt-tab, hide players
- Optional PointShop rent system for private theaters
- Map-aware location system with spatial grid optimization
- Multi-language UI
- Experimental optional Sandbox derivation

---

For high-level project information and credits see the [main repository README](https://github.com/PurrCoding/cinema).
