# Commands

All commands are entered in the Garry's Mod console unless stated otherwise. Commands are grouped by where they run and by the permissions enforced by the code. Some actions also have scoreboard UI equivalents.

## Player commands

These commands are available to players who are currently inside a theater, subject to the theater's request and queue rules.

| Command | Arguments | Description |
|---|---|---|
| `cinema_video_request` | `<url>` | Add a video request to the current theater |
| `cinema_video_remove` | `<queue_id>` | Remove a queued video; normal ownership/permission rules are enforced by the theater |
| `cinema_voteskip` | — | Vote to skip the current video |
| `cinema_voteup` | `<queue_id>` | Upvote a queued video |
| `cinema_votedown` | `<queue_id>` | Downvote a queued video; only has an effect with queue mode 3, which is unsupported in the current source |
| `cinema_name` | `<name>` | Set the current theater's display name, subject to theater-side checks |

### Client playback commands

| Command | Arguments | Description |
|---|---|---|
| `cinema_fullscreen` | — | Toggle the local theater fullscreen view |
| `cinema_refresh` | — | Force-refresh the local theater HTML panel |
| `cinema_playermodel_selector` | — | Open the gamemode's player-model and player/weapon color selector |

### Chat URL requests

When a player is inside a theater, a chat message containing a recognized media URL is treated as a video request and the chat message is suppressed.

## Owner and admin theater commands

These commands are registered for players in a theater. Access is checked by the command/theater implementation; admin-only operations remain admin-only, while private-theater owner operations are limited to the owner.

| Command | Arguments | Description |
|---|---|---|
| `cinema_video_set` | `<url>` | Immediately request/set a video, bypassing normal queue placement |
| `cinema_seek` | `<seconds>` | Seek the current video |
| `cinema_pause` | — | Toggle pause/resume for timed media |
| `cinema_forceskip` | — | Force-skip the current video |
| `cinema_lock` | — | Toggle the theater queue lock |
| `cinema_reset` | — | Reset the theater (admin only) |

## Map and seat editing commands

These client-side commands require admin permissions.

| Command | Arguments | Description |
|---|---|---|
| `cinema_loc_start` | — | Start drawing a location bounding box at the player's position |
| `cinema_loc_end` | — | Finish the box and copy a Lua location snippet to the clipboard |
| `cinema_loc_vector` | — | Copy the current position as a Lua `Vector(...)` expression |
| `cinema_seat_select` | — | Select the prop under the crosshair and open the seat editor |

See [Creating custom maps](creating-custom-maps.md), [Seats](seats.md), and [Debug commands](debug-commands.md).

## Diagnostics and maintenance

| Command | Permission / realm | Description |
|---|---|---|
| `cinema_location_debug` | Server, superadmin | Print location cache, spatial-grid, player-location, and performance diagnostics |
| `cinema_location_debug_reset` | Server, superadmin | Reset location diagnostic counters |
| `cinema_truncate_history` | Server, superadmin | Delete all rows from the Cinema video-history table; destructive |
| `cinema_fullscreen_freeze` | Server command, internal helper | Set the issuing player's frozen state from a `0/1` argument; used by fullscreen mode |

**Warning:** `cinema_truncate_history` clears stored video history and cannot be undone.

## Related ConVars

- `cinema_queue_mode` – queue behavior. Mode `3` (up/down voting) is marked unsupported in the current source.
- `cinema_skip_ratio` – fraction of theater players required to vote-skip.
- `cinema_video_duration_max` – maximum duration for public-theater requests.

See [Configuration](configuration.md) and [Debug commands](debug-commands.md) for the option lists.
