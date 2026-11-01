# Debug commands

This page covers client-side visualizers and server-side diagnostics for mappers, server operators, and developers. Commands that mutate data or expose diagnostics are permission-restricted as noted.

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

## Location editing helpers (client, admin)

| Command | Description |
|---|---|
| `cinema_loc_start` | Start a live location box at the current position |
| `cinema_loc_end` | Finish the box and copy the Lua snippet to the clipboard |
| `cinema_loc_vector` | Copy the current position as a Lua `Vector(...)` expression |

Use these while creating map location data. See [Creating custom maps](creating-custom-maps.md).

## Server-side location diagnostics (superadmin)

| Command | Description |
|---|---|
| `cinema_location_debug` | Print cache hit/miss rates, spatial-grid statistics, player cache state, and approximate memory usage |
| `cinema_location_debug_reset` | Reset the internal location diagnostic counters |

Run these from an in-game superadmin client console. They are server commands and print the report to the server console/log.

## Seat visualizer and editor (client)

| ConVar / Command | Default | Description |
|---|---:|---|
| `cinema_seat_debug` | `0` | Show supported seatable props and seat positions in the current location |
| `cinema_seat_editor` | `0` | Enable seat-editor mode |
| `cinema_seat_debug_numbers` | `1` | Show seat indices |
| `cinema_seat_debug_names` | `1` | Show prop/model names |
| `cinema_seat_select` | — | Admin command: select the prop under the crosshair and open the editor |

Example:

```text
cinema_seat_debug 1
cinema_seat_editor 1
```

The seat editor is development tooling for adjusting model-relative seat offsets. See [Seats](seats.md).

## Other useful client debugging

| ConVar / Command | Description |
|---|---|
| `cinema_debug_teleports` | Toggle theater-door teleport overlays |
| `cinema_html_filter` | Toggle HTML/player console diagnostics |
| `cinema_refresh` | Reload the local theater HTML panel |
| `cinema_fullscreen` | Toggle fullscreen playback |

## Notes

- The location spatial-grid cell size is currently 512 units in the source.
- Keep location boxes tight and avoid unnecessary overlaps.
- After editing map Lua, reload the map or restart the server so the location data is registered again.
- For the complete ConVar inventory, see [Configuration](configuration.md).
