# Location System

The Location system is the core spatial framework of Cinema.  
It answers two questions for every player every few frames:

1. **Which named area** of the map is the player currently inside?
2. **Does that area contain a theater?** If yes, prepare / attach the theater instance.

Without correct location data a map is treated as unsupported and screens will not appear.

---

## High-level overview

```
Map loads
    ↓
Location.Add("mapname", { ... }) registers all boxes
    ↓
Pre-computation builds:
  • Index → name / data caches
  • Spatial grid (512-unit cells)
    ↓
Every player Think (after a short join delay):
  • Check movement threshold
  • Query spatial grid for candidate locations
  • Test player position against Min/Max boxes
  • Update player location index + fire PlayerChangeLocation hook
```

The system is optimized with:

- Movement threshold (skip work if the player has barely moved)
- Spatial hash grid so only nearby location boxes are tested
- Pre-built index and name caches

---

## Registering locations

Locations are registered per map with:

```lua
Location.Add( "map_name_here", {
	[ "Lobby" ] = {
		Min = Vector( x1, y1, z1 ),
		Max = Vector( x2, y2, z2 ),
	},

	[ "Private Theater #1" ] = {
		Min = Vector( ... ),
		Max = Vector( ... ),
		Theater = { ... }   -- optional, see below
	},
} )
```

- The first argument **must** match the map name (case-insensitive).
- Keys are human-readable location names shown on the scoreboard / HUD.
- `Min` / `Max` define an axis-aligned bounding box (AABB).

Files live in:

```
cinema_modded/gamemode/maps/<mapname>.lua
```

For standalone Workshop maps you can also use an autorun file that calls `Location.Add` inside `InitPostEntity` (see mapping guide).

---

## Theater definition inside a location

A location can contain **at most one** theater.  
Add a `Theater` table:

```lua
Theater = {
	Name   = "Private Theater 1",          -- display name
	Flags  = THEATER_PRIVATE,              -- type flags
	Pos    = Vector( x, y, z ),            -- top-left corner of the screen
	Ang    = Angle( 0, yaw, 0 ),           -- screen orientation
	Width  = 396,                          -- width in Hammer units
	Height = 192,                          -- height in Hammer units

	-- Optional thumbnail outside the theater
	ThumbInfo = {
		Pos = Vector( ... ),
		Ang = Angle( ... )
	}
}
```

### Theater flags

| Flag | Meaning |
|------|---------|
| `THEATER_REPLICATED` | Public theater – open to everyone, only admins have full control |
| `THEATER_PRIVATE` | Private theater – can be owned / rented, owner has control |
| `THEATER_PRIVILEGED` | VIP-style theater (special access rules) |
| `THEATER_NONE` | Acts like a public theater but does **not** appear on the scoreboard |

---

## How a player’s location is determined

1. Player position is obtained.
2. A cheap distance check against the last known position may early-out.
3. The spatial grid cell(s) that contain the player are looked up.
4. Only the location boxes that overlap those cells are tested with `pos:InBox(Min, Max)`.
5. The matching location index is stored on the player and networked.
6. If the location changed, `PlayerChangeLocation` is called (this is where theater enter/leave logic runs).

---

## Debug & diagnostics

- `cinema_debug_locations 1` – draw every box and name
- `cinema_debug_grid 1` – visualize the spatial grid
- `cinema_location_debug` (superadmin) – print cache / grid health
- `cinema_loc_start` / `cinema_loc_end` – interactive box creation tools

Full details: [Debug Commands](debug-commands).

---

## Performance notes

- Grid size is 512 units (hard-coded in the module).
- Movement threshold is ~10 units before a full re-query.
- All caches are rebuilt when locations are added or on map change.
- Keep location boxes reasonably tight; large overlapping boxes increase candidate tests.

---

## Related pages

- [Creating Custom Maps](creating-custom-maps) – step-by-step mapping workflow
- [Debug Commands](debug-commands)
- [Commands](commands)
