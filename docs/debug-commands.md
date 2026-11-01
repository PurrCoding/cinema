# Debug commands

This page covers client-side visualizers, map-authoring helpers, and server-side diagnostics. Commands that expose diagnostics or edit configuration are permission-restricted as noted.

## Location visualization (client)

| ConVar | Default | Description |
|---|---:|---|
| `cinema_debug_locations` | `0` | Draw registered location bounding boxes and names |
| `cinema_debug_grid` | `0` | Draw the spatial grid around the local player |

Enable them in the client console:

```text
cinema_debug_locations 1
cinema_debug_grid 1
```

## Teleporter visualization (client)

| ConVar | Default | Description |
|---|---:|---|
| `cinema_debug_teleports` | `0` | Draw teleport sender/receiver markers and a connecting beam |

```text
cinema_debug_teleports 1
```

The overlay marks valid `theater_door` teleport senders and their destination receivers. Doors sharing a destination use the same color. Turn it off with `cinema_debug_teleports 0`; clientside preview models are cleaned up when disabled or when the client shuts down.

## Location editing helpers (client, admin)

| Command | Description |
|---|---|
| `cinema_loc_start` | Start a live location box at the current position |
| `cinema_loc_end` | Finish the box and copy the Lua snippet to the clipboard |
| `cinema_loc_vector` | Copy the current position as a Lua `Vector(...)` expression |

Use noclip to reach one corner, run `cinema_loc_start`, move to the opposite corner, then run `cinema_loc_end`. The generated Lua table is printed to the console and copied to the clipboard. Add it to the appropriate map location file. These commands require admin permissions.

See [Creating custom maps](creating-custom-maps.md).

## Server-side location diagnostics (superadmin)

| Command | Description |
|---|---|
| `cinema_location_debug` | Print cache hit/miss rates, spatial-grid statistics, per-player cache state, location occupancy, and diagnostic counters |
| `cinema_location_debug_reset` | Reset accumulated location diagnostic counters and restart their measurement window |

Run these from an in-game superadmin client console. They are server commands and print the report to the server console/log; they cannot be invoked from the dedicated-server console because the command checks the calling player.

Use `cinema_location_debug` after the system has been active for a while. Run `cinema_location_debug_reset` before a fresh measurement period.

## Seat visualizer and editor (client)

| ConVar / Command | Default | Description |
|---|---:|---|
| `cinema_seat_debug` | `0` | Show supported seatable props and seat positions in the player's current location |
| `cinema_seat_editor` | `0` | Enable the seat-editor overlay |
| `cinema_seat_debug_numbers` | `1` | Show seat indices |
| `cinema_seat_debug_names` | `1` | Show prop/model names |
| `cinema_seat_select` | — | Admin command: select the prop under the crosshair and open the editor |

Example:

```text
cinema_seat_debug 1
cinema_seat_editor 1
```

The debug overlay only scans props inside the player's current registered location. Existing seat positions are shown as 3D seat models; occupied seats are red and available seats are green. To edit a prop, look at it and run `cinema_seat_select`. The editor loads existing `ChairOffsets` for that model when available and provides a 3D preview.

Exporting copies a Lua configuration snippet to the clipboard and prints it to the console. The edit is not automatically written to the gamemode files: copy the exported entry into the appropriate seat configuration source. See [Seats](seats.md).

## SQL history diagnostics (client and server)

Two recently added ConVars enable verbose logging for the local SQLite history tables.

| ConVar | Where to set it | Default | Description |
|---|---|---:|---|
| `cinema_debug_history` | Server console | `0` | Print server-side video-history SQL queries and returned rows |
| `cinema_debug_requests` | Client console | `0` | Print client-side request-history SQL queries and returned rows |

Enable the relevant flag only while investigating history problems:

```text
# Server console
cinema_debug_history 1
```

```text
# Client console
cinema_debug_requests 1
```

When enabled, the corresponding console prints the SQL statement and returned rows, or a message if the query returned no rows. SQL errors are reported separately even when verbose logging is disabled. Turn these flags off after troubleshooting to avoid noisy logs.

## HTML service console output (client)

| ConVar | Default | Description |
|---|---:|---|
| `cinema_html_filter` | `0` | Controls filtering of messages from the embedded HTML console |

The current implementation uses `0` as the default filtered mode: ordinary HTML console messages are suppressed while the special `gmod` messages remain visible. Set it to `1` to allow all HTML console messages through. This can help diagnose playback-service JavaScript errors and warnings.

## Other useful client commands

| Command | Description |
|---|---|
| `cinema_refresh` | Reload the local theater HTML panel |
| `cinema_fullscreen` | Toggle fullscreen playback |
| `cinema_playermodel_selector` | Open the player-model, color, skin, and bodygroup selector |

## Notes

- The location spatial-grid cell size is currently 512 units in the source.
- Keep location boxes tight and avoid unnecessary overlaps.
- After editing map Lua, reload the map or restart the server so the location data is registered again.
- For the complete ConVar inventory, see [Configuration](configuration.md).
