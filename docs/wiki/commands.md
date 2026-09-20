# Commands

All commands below are console commands (`~` console).  
Many also have UI equivalents on the scoreboard (queue / owner / admin panels).

---

## Player commands (anyone inside a theater)

| Command | Arguments | Description |
|---------|-----------|-------------|
| `cinema_video_request` | `<url>` | Request a video in the current theater |
| `cinema_video_remove` | `<queue_id>` | Remove a video from the queue (own video or if privileged) |
| `cinema_voteskip` | — | Vote to skip the currently playing video |
| `cinema_voteup` | `<queue_id>` | Vote a queued video up (when queue mode = 1) |
| `cinema_name` | `<name>` | Set the theater display name (owner / admin only in practice) |
| `cinema_fullscreen` | — | Toggle fullscreen theater view (client) |
| `cinema_refresh` | — | Force-refresh the theater HTML panel (client) |

### Chat auto-request

If you are inside a theater and type a URL that looks like a media link into chat, the gamemode automatically requests it and suppresses the chat message.

---

## Owner / Admin privileged commands

These require either:

- the player to be the **owner** of a private theater, **or**
- the player to be an **admin**

| Command | Arguments | Description |
|---------|-----------|-------------|
| `cinema_video_set` | `<url>` | Immediately set / force a video (bypasses normal queue rules) |
| `cinema_seek` | `<seconds>` | Seek the current video to the given time |
| `cinema_pause` | — | Toggle pause / resume (only works for timed videos) |
| `cinema_forceskip` | — | Force-skip the current video and announce it |
| `cinema_lock` | — | Toggle queue lock (prevents further requests while locked) |
| `cinema_reset` | — | Fully reset the theater (admin only) |

---

## Superadmin / utility commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `cinema_truncate_history` | — | Delete the entire cinema history database (superadmin) |
| `cinema_fullscreen_freeze` | `0/1` | Freeze the local player while in fullscreen (internal / utility) |

---

## Location editing helpers (admin)

These are primarily used while creating map locations. See [Debug Commands](debug-commands) and [Creating Custom Maps](creating-custom-maps).

| Command | Description |
|---------|-------------|
| `cinema_loc_start` | Begin defining a location box (admin) |
| `cinema_loc_end` | Finish the box and copy Lua to clipboard (admin) |
| `cinema_loc_vector` | Copy current player position as a `Vector(...)` string (admin) |

---

## Related ConVars that affect command behaviour

- `cinema_queue_mode` – vote vs chronological queue
- `cinema_skip_ratio` – how many votes are needed to skip
- `cinema_video_duration_max` – max length in public theaters
- `cinema_allow_reset` – whether empty theaters auto-reset

Full list: [Configuration](configuration).
