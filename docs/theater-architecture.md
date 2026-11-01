# Theater Architecture

This page describes how the core theater objects fit together. Useful for developers who want to extend queue logic, networking, or the HTML player.

---

## Main objects

| Object | Module | Role |
|--------|--------|------|
| `Location` | `modules/location` | Spatial areas + “is player inside theater X?” |
| `THEATER` | `modules/theater/sh_theater.lua` | One theater instance (queue, current video, owner, flags) |
| `VIDEO` | `modules/theater/sh_video.lua` | One queued / playing media item |
| `SERVICE` | `modules/theater/services/*` | URL → metadata → embed player |
| Scoreboard UI | `modules/scoreboard` | Queue list, request panel, owner/admin controls |

---

## Theater lifecycle (server)

1. Map loads → location file registers boxes (some with a `Theater` table).
2. For each theater location the gamemode creates a `THEATER` object.
3. Players enter/leave → `PlayerChangeLocation` → theater adds/removes the player.
4. A player requests a URL → matching `SERVICE` resolves metadata → `VIDEO` is created and pushed onto the theater queue.
5. When the current video finishes (or is skipped) the next `VIDEO` is started.
6. Clients receive net messages and open the corresponding HTML provider on their screen panel.

---

## THEATER – important methods / state

**Identity & geometry**

- `Id` – location index
- `Name()`, `GetFlags()`, `GetPos()`, `GetAngles()`, `GetSize()`
- `IsPrivate()`, `IsPrivileged()`

**Playback**

- Current video, playlist / queue, skip votes
- `RequestVideo`, `SkipVideo`, `Seek`, `SetPaused`, `Reset`, `PlayDefault`
- Queue lock (owner can prevent new requests)

**Ownership (private theaters)**

- Owner player / SteamID
- Integrated with the rent module when renting is enabled

**Thumbnails**

- Optional thumbnail entity outside the room that mirrors the current video

---

## VIDEO – important fields

| Field | Meaning |
|-------|---------|
| `Type()` | Service class name (`youtube`, `dailymotion`, …) |
| `Data()` | Service-specific ID string |
| `Title()`, `Duration()`, `Thumbnail()` | Display metadata |
| `StartTime()` | Server `CurTime()` when playback started (used for sync) |
| Owner nick / SteamID | Who requested it |
| Votes | Up-votes when queue mode = 1 |

---

## Networking (high level)

- Theater state (current video, queue snapshot, pause, lock) is networked to players **inside** that theater.
- Request / vote / seek / pause commands are sent from client → server, validated (location, privileges, rate limits), then applied.
- The rent module adds its own net messages for rent / refund / filter lists.

Exact message names live in the `sv_*.lua` / `cl_*.lua` files of the theater and rent modules; prefer extending existing helpers over adding raw `net.Receive` calls.

---

## HTML player side

1. Client theater panel is a DHTML surface.
2. `SERVICE:LoadProvider` opens an embed URL or injects HTML.
3. JavaScript must set `window.cinema_controller` and call `exTheater.controllerReady()`.
4. The injected `window.theater` (CinemaPlayer) bridges volume, seek, play, pause and soft-sync.

Base URL for hosted HTML helpers:

```lua
theater.GetCinemaURL("youtube.html")  -- etc.
```

Controlled by the ConVar `cinema_url` (do not change unless you host your own copy of the player pages).

---

## Extension points

| Goal | Where to look |
|------|----------------|
| New media platform | New file in `services/` – see [Custom Video Service](custom-video-service) |
| Extra owner power | Extend `THEATER` methods + scoreboard owner panel |
| Different queue rules | `cinema_queue_mode` + queue helpers in theater module |
| Currency for renting | `modules/rent/sh_currency.lua` |
| New chair models | `modules/seats/sh_seats.lua` |
| New language | `i18n/languages/*.lua` – see [Translations](translations) |

---

## Related pages

- [Custom Video Service](custom-video-service)
- [Location System](location-system)
- [Development](development)
- [Commands](commands)
