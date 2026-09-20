# Video services

Theater screens resolve media through **service modules** under:

```
cinema_modded/gamemode/modules/theater/services/
```

Each service implements URL matching and metadata extraction (title, duration, embed data) for one or more hosts.

---

## Built-in services

| Service | Notes |
|---------|-------|
| YouTube | Primary VOD provider |
| Twitch | Streams / VODs (subject to Twitch embed rules) |
| TikTok | Short-form URLs |
| SoundCloud | Audio tracks |
| Dailymotion | VOD |
| Rumble | VOD |
| Kick | Streams |
| Bilibili | VOD, AV, live, and episode variants |
| VK / OK | Regional hosts |
| Internet Archive (`ia`) | archive.org media |
| Google Drive / MEGA | File links where embedding is possible |
| Jellyfin | Self-hosted media server integration |
| URL / URL protocol | Generic fallback for direct or protocol links |

Availability depends on:

- the host’s embed / CORS policy
- CEF codecs on the client (install [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix))
- network access from players’ clients

Some services require the x86-64 branch of Garry’s Mod.

---

## Adding or maintaining a service

1. Follow the patterns in `sh_base.lua` and an existing provider (e.g. `sh_youtube.lua`).
2. Register matchers for the domains you support.
3. Return stable metadata (title, duration, and any IDs needed for the HTML player).
4. Test on both public and private theaters.
5. Respect `cinema_video_duration_max` for public rooms.

Keep CLIENT / SERVER responsibilities clear: metadata fetch may run where the service design expects it; do not assume server HTTP always works for every site.

---

## Playback stack

Theater HTML is driven by the configured `cinema_url` host and the gamemode’s theater panel code.  
Clients need a working Chromium embed (prefer x86-64 GMod + CEF Codec Fix for wider format support).

The default `cinema_url` points to the project’s hosted player pages. Only change it if you host your own copy of the HTML/JS assets.
