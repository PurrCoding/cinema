# Configuration

Cinema is configured primarily through Garry's Mod ConVars. Server values belong in the server configuration; client values can be set in the player's console or through the scoreboard settings where available.

## Server ConVars

| ConVar | Default | Description |
|---|---:|---|
| `cinema_queue_mode` | `1` | `1` = upvote-only queue; `2` = chronological/request order. Mode `3` is present in legacy code but currently marked unsupported by the source. |
| `cinema_skip_ratio` | `0.66` | Fraction of players in the theater required to vote-skip (0–1) |
| `cinema_video_duration_max` | `10800` | Maximum video duration for public-theater requests, in seconds |
| `cinema_allow_reset` | `0` | Reset an empty public theater |
| `cinema_allow_voice` | `0` | Allow voice chat between viewers in the same theater |
| `cinema_allow_3dvoice` | `1` | Use positional 3D voice |
| `cinema_url` | Built-in URL | Base URL for the HTML pages loaded on theater screens. Do not change unless hosting a compatible custom player frontend. |
| `cinema_spawn_popcorn` | `0` | Give players the popcorn weapon on spawn when the weapon is installed |
| `cinema_enable_sandbox` | `0` | Experimental Sandbox derivation |
| `cinema_service_imageduration` | `0` | Duration for image-like media; `0` means infinite, maximum is 60 seconds |

### Theater renting ConVars

| ConVar | Default | Description |
|---|---:|---|
| `cinema_rent_cost_per_minute` | `10` | Currency charged per minute |
| `cinema_rent_min_time` | `1` | Minimum rent duration in minutes |
| `cinema_rent_max_time` | `300` | Maximum rent duration in minutes |
| `cinema_rent_ps2_premium` | `0` | Use PointShop 2 premium points instead of standard points |
| `cinema_rent_currency` | Empty | Force a provider ID (`pointshop1`, `pointshop2`); empty auto-detects |
| `cinema_rent_prevent_unrented` | `0` | Prevent use of private theaters until rented |
| `cinema_rent_admins_ignore_filter` | `1` | Allow admins to bypass renter player filters |
| `cinema_rent_admins_alert_filtered` | `1` | Notify admins when a filter would otherwise block them |
| `cinema_rent_super_alert_admin_filtered` | `1` | Notify superadmins when an admin enters a filtered theater |

The last three ConVars are server-only. See [Theater renting](theater-renting.md) for provider and rental behavior details.

## Client ConVars

| ConVar | Default | Description |
|---|---:|---|
| `cinema_volume` | `50` | Local theater volume (0–100) |
| `cinema_resolution` | `1080` | Playback resolution hint; clamped to 2–1080 |
| `cinema_mute_nofocus` | `1` | Mute theater audio while the game window is unfocused |
| `cinema_hideplayers` | `0` | Fade other players while inside a theater |
| `cinema_hide_amount` | `0.11` | Remaining player model blend when hiding is enabled |
| `cinema_drawnames` | `1` | Draw player names |
| `cinema_smoother` | `1` | Enable smoother video rendering; may cost FPS |
| `cinema_html_filter` | `0` | Suppress ordinary embedded HTML console messages; set to `1` to allow all messages |

## Location, seat, and SQL debugging ConVars

| ConVar | Default | Realm | Description |
|---|---:|---|---|
| `cinema_debug_locations` | `0` | Client | Draw registered location bounds and names |
| `cinema_debug_grid` | `0` | Client | Draw spatial-grid cells around the player |
| `cinema_debug_teleports` | `0` | Client | Show teleport sender/receiver overlays |
| `cinema_seat_debug` | `0` | Client | Visualize supported seat props and seat positions |
| `cinema_seat_editor` | `0` | Client | Enable the interactive seat-editor overlay |
| `cinema_seat_debug_numbers` | `1` | Client | Show seat numbers in the seat visualizer |
| `cinema_seat_debug_names` | `1` | Client | Show prop/model names in the seat visualizer |
| `cinema_debug_requests` | `0` | Client | Log client-side request-history SQL queries and results |
| `cinema_debug_history` | `0` | Server | Log server-side video-history SQL queries and results |

See [Debug commands](debug-commands.md) for usage examples and details.

## Example server.cfg

```cfg
cinema_queue_mode 1
cinema_skip_ratio 0.66
cinema_video_duration_max 10800
cinema_allow_reset 0
cinema_allow_voice 0
cinema_allow_3dvoice 1

cinema_rent_cost_per_minute 10
cinema_rent_min_time 1
cinema_rent_max_time 300
cinema_rent_prevent_unrented 0
```

## Gamemode settings menu

The `cinema_modded.txt` file exposes menu settings for popcorn spawning, experimental Sandbox derivation, voice, 3D voice, and empty-theater reset. These menu options mirror their corresponding ConVars.

## Related pages

- [Commands](commands.md)
- [Debug commands](debug-commands.md)
- [Location system](location-system.md)
- [Theater renting](theater-renting.md)
