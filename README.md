# Cinema (Fixed Edition)

[![Garry's Mod](https://img.shields.io/badge/Garry's%20Mod-Gamemode-blue?style=flat-square)](https://gmod.facepunch.com/)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-green?style=flat-square)](LICENSE.md)
[![Steam Workshop](https://img.shields.io/badge/Steam-Workshop-171a21?style=flat-square&logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587)
[![Documentation](https://img.shields.io/badge/Docs-Wiki-informational?style=flat-square)](https://github.com/PurrCoding/cinema/wiki)

**Watch videos together in Garry's Mod.** Cinema is a multiplayer theater gamemode with synchronized playback, public and private theaters, queues, and support for a wide range of media services.

This community-maintained successor to the original [PixelTail Games Cinema](https://github.com/pixeltailgames/cinema) focuses on keeping theater servers working on modern Garry's Mod while adding practical features for players and server owners.

## At a glance

- **Type:** Full Garry's Mod gamemode (not a regular addon)
- **Workshop:** [Cinema (Fixed Edition)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587)
- **Documentation:** [GitHub Wiki](https://github.com/PurrCoding/cinema/wiki)
- **Issues and feature requests:** [GitHub Issues](https://github.com/PurrCoding/cinema/issues)
- **License:** [GPL-3.0](LICENSE.md)

## Features

### Theaters and playback

- Public and private theaters with queues, vote-skip, seeking, and pause
- Video history with search, filters, and pagination
- Theater renting with PointShop 1 or 2 points, time extensions, refunds, and player lists
- Per-player volume, mute-on-alt-tab, and hide-player options
- Map-aware theater locations and seat integration
- Optional experimental Sandbox derivation, popcorn weapon, and 3D voice options
- UI translations in 20+ locales

### Supported media

YouTube, Twitch, SoundCloud, Dailymotion, Rumble, Kick, Bilibili (VOD, AV, live, and episodes), VK, OK, Internet Archive, Google Drive, MEGA, Jellyfin, and direct URL/protocol playback.

Actual playback support can depend on the provider, URL type, and the Chromium/CEF codecs available in the player's Garry's Mod installation.

## Requirements

- Garry's Mod (the **x86-64 branch is recommended**).
- A supported map: a `theater*` or `cinema*` map, or a map with theater entities and location data.
- [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool) is strongly recommended for H.264 and other codec support.

> **Compatibility:** Do not run this gamemode alongside the original PixelTail Cinema addon or its forks. Disable or unsubscribe from those first.

## Installation

### Steam Workshop

1. Subscribe to [Cinema (Fixed Edition)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587).
2. For a dedicated server, add Workshop ID `2419005587` to your collection.
3. Select **Cinema (Fixed Edition)** (`cinema_modded`) as the gamemode and start a supported map.

### From source

Clone the repository and copy `cinema_modded/` into `garrysmod/gamemodes/`:

```bash
git clone https://github.com/PurrCoding/cinema.git
```

Then select `cinema_modded` and load a supported map.

See the [installation guide](https://github.com/PurrCoding/cinema/wiki/installation) for the full walkthrough and troubleshooting.

## Configuration

Common server ConVars:

| ConVar | Default | Description |
|---|---:|---|
| `cinema_queue_mode` | `1` | Queue voting: `1` upvote only, `2` chronological, `3` up/down voting |
| `cinema_skip_ratio` | `0.66` | Fraction of players required to vote-skip |
| `cinema_video_duration_max` | `10800` | Maximum video duration in public theaters, in seconds |
| `cinema_allow_reset` | `0` | Reset a theater when it becomes empty |
| `cinema_allow_voice` | `0` | Enable voice chat inside theaters |
| `cinema_allow_3dvoice` | `1` | Enable positional voice |
| `cinema_url` | Built-in | Base URL for theater HTML pages |

For renting options, client settings, and the complete list, see [Configuration](https://github.com/PurrCoding/cinema/wiki/configuration) and [Theater renting](https://github.com/PurrCoding/cinema/wiki/theater-renting).

## Documentation

| Guide | What it covers |
|---|---|
| [Installation](https://github.com/PurrCoding/cinema/wiki/installation) | Setup, requirements, troubleshooting |
| [Configuration](https://github.com/PurrCoding/cinema/wiki/configuration) | Server ConVars and options |
| [Commands](https://github.com/PurrCoding/cinema/wiki/commands) | Player, owner, and admin commands |
| [Debug commands](https://github.com/PurrCoding/cinema/wiki/debug-commands) | Location visualizers and diagnostics |
| [Location system](https://github.com/PurrCoding/cinema/wiki/location-system) | Theater bounds and map areas |
| [Creating custom maps](https://github.com/PurrCoding/cinema/wiki/creating-custom-maps) | Hammer and Lua mapping guide |
| [Custom video service](https://github.com/PurrCoding/cinema/wiki/custom-video-service) | Adding a media provider |
| [Theater architecture](https://github.com/PurrCoding/cinema/wiki/theater-architecture) | THEATER, VIDEO, and SERVICE internals |
| [Seats](https://github.com/PurrCoding/cinema/wiki/seats) | Chair models and offsets |
| [Translations](https://github.com/PurrCoding/cinema/wiki/translations) | Adding languages |
| [Development](https://github.com/PurrCoding/cinema/wiki/development) | Module layout and contribution notes |

## Repository layout

```text
cinema_modded/                 Gamemode root
  gamemode/
    modules/
      theater/                 Core theater logic and video services
      rent/                    Private theater renting
      scoreboard/              Queue, request, and owner UI
      location/                Map location system
      seats/                   Seat helpers
    i18n/                      Translations
    maps/                      Per-map theater/location setup
  entities/                    Screens, doors, portable TVs, etc.
  content/                     Materials, fonts, sounds
  cinema.fgd                   Hammer entity definitions
```

Contributor guidance: [AGENTS.md](AGENTS.md).

## Credits

- Original [Cinema](https://github.com/pixeltailgames/cinema) by [PixelTail Games](https://steamcommunity.com/groups/pixelTail)
- YouTube-related work by [Veitikka](https://github.com/veitikka) and the media-player ecosystem
- Sandbox-in-Cinema contributions by Ket'Ta-Lani and ArtarOs
- [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool) by Solstice Game Studios / Akiko Kumagara
- Community translators and maintainers of this edition

## License

Licensed under the **GNU General Public License v3.0**. See [LICENSE.md](LICENSE.md) for the full license text.
