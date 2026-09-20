# Cinema (Fixed Edition)

[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Gamemode-blue?style=flat-square)](https://gmod.facepunch.com/)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square)](LICENSE.md)
[![Workshop](https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587)
[![Wiki](https://img.shields.io/badge/Docs-Wiki-informational?style=flat-square)](https://github.com/PurrCoding/cinema/wiki)

**Synchronized multiplayer video streaming** for Garry's Mod — watch movies, streams, and music together on in-game theater screens.

Community-maintained successor to the original [Cinema](https://github.com/pixeltailgames/cinema) gamemode by PixelTail Games. The goal is to keep cinema servers playable on modern Garry's Mod while adding practical features for players and operators.

> *Remember sitting down on a lazy afternoon with your friends, drinking a cup of hot cocoa and watching a movie? It's a magical bonding experience between people, a timeless ritual that not many are able to do with some of their friends…*  
> — PixelTail Games

---

## Links

| | |
|---|---|
| **Workshop** | [Cinema (Fixed Edition)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587) |
| **Documentation** | [GitHub Wiki](https://github.com/PurrCoding/cinema/wiki) |
| **Issues** | [Bug reports & feature requests](https://github.com/PurrCoding/cinema/issues) |
| **CEF Codec Fix** | [Required for many video formats](https://github.com/solsticegamestudios/GModCEFCodecFix) |

---

## Features

### Playback & theaters

- Public and private theaters with queue, vote-skip, seek, and pause
- Video history with search, filters, and pagination
- Per-player volume, mute-on-alt-tab, and hide-players options
- Optional smoother HTML playback
- Map-aware location system and seat integration

### Supported media

YouTube · Twitch · TikTok · SoundCloud · Dailymotion · Rumble · Kick · Bilibili (VOD / AV / live / episodes) · VK · OK · Internet Archive · Google Drive · MEGA · Jellyfin · direct URL / protocol playback

### Theater renting

Private theaters can be rented with **PointShop 1 or 2** points:

- Rent, extend, and refund remaining time
- Ownership persists across disconnects (SteamID-based)
- Player whitelist / blacklist
- Vote-skip lock for the renter
- Admin cancel with automatic refund (including offline owners)

### Other

- Multi-language UI (20+ locales)
- Optional experimental Sandbox derivation
- Popcorn weapon, 3D voice, and theater voice settings

---

## Requirements

- **Garry's Mod** (x86-64 branch recommended)
- A supported map (`theater*`, `cinema*`, or any map with theater entities + location data)
- **[GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix)** — strongly recommended for H.264 and other codecs

> **Important:** This gamemode conflicts with the original PixelTail Cinema addon and any forks of it. Disable or unsubscribe from those before using Fixed Edition.

---

## Installation

### Workshop (players & most servers)

1. Subscribe to the [Workshop addon](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587).
2. On dedicated servers, add Workshop ID `2419005587` to your collection.
3. Set the gamemode to **Cinema (Fixed Edition)** (`cinema_modded`) and start a supported map.

### From source (development & full control)

```bash
git clone https://github.com/PurrCoding/cinema.git
# Copy cinema_modded/ into garrysmod/gamemodes/
```

Then set `gamemode cinema_modded` (or select it in the menu) and load a supported map.

Full walkthrough, verification checklist, and troubleshooting: **[Installation guide](https://github.com/PurrCoding/cinema/wiki/installation)**.

---

## Configuration

Common server ConVars:

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_queue_mode` | `1` | `1` = vote queue · `2` = chronological |
| `cinema_skip_ratio` | `0.66` | Fraction of players required to voteskip |
| `cinema_video_duration_max` | `10800` | Max duration (seconds) in public theaters |
| `cinema_allow_reset` | `0` | Reset theater when empty |
| `cinema_allow_voice` | `0` | Voice chat inside theaters |
| `cinema_allow_3dvoice` | `1` | 3D positional voice |
| `cinema_url` | (built-in) | Base URL for theater HTML pages |

Renting ConVars, client settings, and more: **[Configuration](https://github.com/PurrCoding/cinema/wiki/configuration)** · **[Theater renting](https://github.com/PurrCoding/cinema/wiki/theater-renting)**.

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Installation](https://github.com/PurrCoding/cinema/wiki/installation) | Setup, requirements, troubleshooting |
| [Configuration](https://github.com/PurrCoding/cinema/wiki/configuration) | All ConVars |
| [Commands](https://github.com/PurrCoding/cinema/wiki/commands) | Player, owner, and admin commands |
| [Debug commands](https://github.com/PurrCoding/cinema/wiki/debug-commands) | Location visualizers and diagnostics |
| [Location system](https://github.com/PurrCoding/cinema/wiki/location-system) | Spatial areas and theater bounds |
| [Creating custom maps](https://github.com/PurrCoding/cinema/wiki/creating-custom-maps) | Hammer + Lua mapping tutorial |
| [Custom video service](https://github.com/PurrCoding/cinema/wiki/custom-video-service) | Implement a new media provider |
| [Theater architecture](https://github.com/PurrCoding/cinema/wiki/theater-architecture) | THEATER / VIDEO / SERVICE internals |
| [Seats](https://github.com/PurrCoding/cinema/wiki/seats) | Chair models and offsets |
| [Translations](https://github.com/PurrCoding/cinema/wiki/translations) | Adding languages |
| [Development](https://github.com/PurrCoding/cinema/wiki/development) | Module layout and contribution notes |

---

## Repository layout

```
cinema_modded/                 ← install this folder as the gamemode
  gamemode/
    modules/
      theater/                 Core logic & video services
      rent/                    Private theater renting
      scoreboard/              Queue, request, owner UI
      location/                Map location system
      seats/                   Seat helpers
      …
    i18n/                      Translations
    maps/                      Per-map location / theater setup
  entities/                    Screen, door, portable TV, …
  content/                     Materials, fonts, sounds
  cinema.fgd                   Hammer entity definitions
```

Contributor standards: **[AGENTS.md](AGENTS.md)**.

---

## Credits

- Original [Cinema](https://github.com/pixeltailgames/cinema) by [PixelTail Games](https://steamcommunity.com/groups/pixelTail)
- YouTube-related work by [Veitikka](https://github.com/veitikka) and the mediaplayer ecosystem
- Sandbox-in-Cinema contributions by Ket'Ta-Lani & ArtarOs
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) by Solstice Game Studios / Akiko Kumagara
- Community translators and maintainers of this fixed edition

---

## License

This project is licensed under the **GNU General Public License v3.0**. See [LICENSE.md](LICENSE.md) for the full text.
