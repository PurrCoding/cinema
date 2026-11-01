# Debug Commands

These commands and ConVars are intended for mappers, server operators and developers.  
Most require **admin** or **superadmin**.

---

## Location visualization (client)

| ConVar / Command | Default | Description |
|------------------|---------|-------------|
| `cinema_debug_locations` | `0` | Draw all location bounding boxes and names in the world |
| `cinema_debug_grid` | `0` | Draw the spatial grid cells used for fast location lookups |

Enable them in console:

```
cinema_debug_locations 1
cinema_debug_grid 1
```

When enabled you will see:

- Wireframe boxes for every registered location
- Location names floating at the center of each box
- Teleport points (green boxes) if a location defines them
- Spatial grid cells around the player (when grid debug is on)

---

## Location editing helpers (admin)

These two commands make creating location data painless.

### `cinema_loc_start`

1. Noclip to one corner of the area you want to define.
2. Run `cinema_loc_start`.
3. A live wireframe box follows your movement.

### `cinema_loc_end`

1. Move to the opposite corner.
2. Run `cinema_loc_end`.
3. The resulting Lua snippet is printed to console **and** copied to the clipboard:

```lua
[ "Name" ] =
{
	Min = Vector( ... ),
	Max = Vector( ... ),
},
```

Rename `"Name"` to something meaningful (e.g. `"Private Theater #3"`) and paste it into your map’s location file.

### `cinema_loc_vector`

Copies your current position as a ready-to-paste `Vector(x, y, z)` string.  
Useful when placing theater screens or thumbnails manually.

---

## Server-side location diagnostics (superadmin)

| Command | Description |
|---------|-------------|
| `cinema_location_debug` | Print a detailed report: cache hits/misses, spatial grid stats, player location validity, memory estimate |
| `cinema_location_debug_reset` | Reset the internal debug counters |

Example output sections:

- Cache validation (valid / invalid / stale player caches)
- Spatial grid efficiency
- Approximate memory usage of the location system

---

## Other useful client commands while debugging

| Command | Description |
|---------|-------------|
| `cinema_refresh` | Force the theater HTML panel to reload |
| `cinema_fullscreen` | Toggle fullscreen view (helps verify screen placement) |

---

## Tips

- Always test locations with `cinema_debug_locations 1` after adding a new map file.
- Overlapping location boxes are resolved by the order they are checked; keep boxes tight and non-overlapping when possible.
- The spatial grid size is currently fixed at 512 units (see Location module source).
- After editing location Lua, a map change or `lua_openscript` / full restart is usually required for the new data to load.

See also: [Location System](location-system) and [Creating Custom Maps](creating-custom-maps).
