# Cinema (Fixed Edition)

Community-maintained successor to the original [Cinema](https://github.com/pixeltailgames/cinema) gamemode by PixelTail Games. The goal is to keep cinema servers playable on modern Garry's Mod while adding practical features for players and operators.

[Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587) · [Issues](https://github.com/PurrCoding/cinema/issues) · [Documentation](docs/README.md)

---

## Features

### Playback & theaters
- Private and public theaters with queue, vote-skip, seek, and pause
- Video history with search, filters, and pagination
- Per-player volume, mute-on-alt-tab, hide players in theaters
- Optional smoother HTML playback (client)
- Map-aware theater locations and seat integration

### Video services
Built-in providers include **YouTube**, **Twitch**, **TikTok**, **SoundCloud**, **Dailymotion**, **Rumble**, **Kick**, **Bilibili** (VOD / AV / live / episodes), **VK**, **OK**, **Internet Archive**, **Google Drive**, **MEGA**, **Jellyfin**, and generic **URL** / protocol playback.

### Theater renting
Private theaters can be **rented with points** (PointShop 1 or 2):

- Rent, extend, and refund remaining time
- Ownership persists across disconnects (SteamID-based)
- Player whitelist / blacklist
- Vote-skip lock for the renter
- Admin cancel with refund (including pending refund if offline)

See [Theater renting](docs/theater-renting.md) for ConVars and usage.

### Other
- Multi-language UI (20 locale files)
- Optional experimental Sandbox derivation
- Popcorn weapon spawn option, 3D / theater voice settings

---

## Quick install

1. Copy the `cinema_modded` folder into `garrysmod/gamemodes/`.
2. Set the server gamemode to `cinema_modded` (or select it in the menu).
3. Use a supported map (`theater*`, `cinema*`, or maps with theater entities).
4. For HTML video codecs, install [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix).

Workshop subscribers get the gamemode automatically; this repository is the source of truth for development and server-side customization.

Full steps: [Installation](docs/installation.md).

---

## Configuration

Common server ConVars:

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_queue_mode` | `1` | `1` = vote queue, `2` = chronological |
| `cinema_skip_ratio` | `0.66` | Fraction of players needed to voteskip |
| `cinema_video_duration_max` | `10800` | Max duration (seconds) in public theaters |
| `cinema_allow_reset` | `0` | Reset theater when empty |
| `cinema_allow_voice` | `0` | Voice chat inside theaters |
| `cinema_allow_3dvoice` | `1` | 3D voice |
| `cinema_url` | (built-in) | Base URL for theater HTML pages |

Renting-related ConVars are listed in [Theater renting](docs/theater-renting.md).  
Client settings (volume, resolution, mute on focus loss, etc.) are available in the in-game scoreboard settings panel.

More detail: [Configuration](docs/configuration.md).

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
    maps/                      Per-map theater setup
  entities/                    Theater entities (screen, door, portable, …)
  content/                     Materials, fonts, sounds
docs/                          Project documentation (wiki-style)
```

Development notes for contributors and tools: [AGENTS.md](AGENTS.md), [Development](docs/development.md).

---

## Documentation

| Page | Contents |
|------|----------|
| [Documentation index](docs/README.md) | Overview of all docs |
| [Installation](docs/installation.md) | Server & client setup |
| [Configuration](docs/configuration.md) | ConVars and options |
| [Theater renting](docs/theater-renting.md) | Rent system guide |
| [Video services](docs/video-services.md) | Supported providers |
| [Development](docs/development.md) | Architecture & contribution |

---

## Credits

- Original [Cinema](https://github.com/pixeltailgames/cinema) by [PixelTail Games](https://steamcommunity.com/groups/pixelTail)
- YouTube-related work by [Veitikka](https://github.com/veitikka) and others in the mediaplayer ecosystem
- Sandbox-in-Cinema contributions by Ket'Ta-Lani & ArtarOs
- [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) by Solstice Game Studios / Akiko Kumagara
- Community translators and maintainers of this fixed edition

## License

See [LICENSE.md](LICENSE.md).
