# Creating Custom Maps

This guide explains how to make a map fully compatible with **Cinema (Fixed Edition)**.  
It is an updated version of the classic PixelTail mapping tutorial, adapted to the current codebase.

You will need:

- Hammer (or another Source map editor)
- The Cinema FGD (included in the repository)
- Basic knowledge of Garry’s Mod Lua for the location file

---

## 1. Add the Cinema FGD to Hammer

The FGD defines the special entities the gamemode understands.

**Location in this repository:**

```
cinema_modded/cinema.fgd
```

In Hammer:

1. Tools → Options → Game Configurations
2. Add the FGD to your Garry’s Mod configuration
3. Restart Hammer if necessary

You now have the following point entities available:

| Entity | Purpose |
|--------|---------|
| `theater_screen` | 3D2D theater screen |
| `theater_thumbnail` | Preview screen that shows what is currently playing |
| `theater_door` | One-way teleport door used by classic Cinema maps |
| `theater_portable_tv` / `theater_portable_projector` | Portable media entities |

---

## 2. Place theater entities in Hammer

### theater_screen

- Place it at the **top-left corner** of where the screen should appear, pointing outwards (toward the audience).
- Keyvalues:
  - **Theater Name** – shown on scoreboard and thumbnails
  - **Flags** – public / private / etc.
  - **Screen Width / Height** – size in Hammer units
  - **Thumbnail** – `targetname` of the matching `theater_thumbnail` (optional)

### theater_thumbnail

- Place anywhere (usually outside the theater entrance).
- Give it a unique `targetname` and reference that name from the corresponding `theater_screen`.

### theater_door (optional)

- Classic Cinema maps use these for one-way teleports between rooms.
- Pair with an `info_teleport_destination`.
- Two doors are required for two-way travel.

After placing entities, compile the map as usual.

---

## 3. Create location data (required)

Even with perfect entities, the gamemode needs **Lua location boxes** so it knows when a player enters a theater.

### Interactive method (recommended)

1. Load your map with the Cinema gamemode.
2. Become admin.
3. Noclip to one corner of an area → run:
   ```
   cinema_loc_start
   ```
4. Move to the opposite corner (a live wireframe box follows you).
5. Run:
   ```
   cinema_loc_end
   ```
6. The generated Lua is copied to the clipboard. Paste it into a text editor and give it a proper name.

Repeat for every distinct area (lobby, each theater, bathrooms, etc.).

You can also grab a single position with:

```
cinema_loc_vector
```

### Resulting file structure

Create a file named exactly after your map, e.g. `mymap.lua`, and place it in:

```
garrysmod/gamemodes/cinema_modded/gamemode/maps/mymap.lua
```

Template:

```lua
Location.Add( "mymap", {

	[ "Lobby" ] =
	{
		Min = Vector( -100, -200, 0 ),
		Max = Vector(  100,  200, 200 ),
	},

	[ "Private Theater #1" ] =
	{
		Min = Vector( ... ),
		Max = Vector( ... ),
		Theater = {
			Name   = "Private Theater 1",
			Flags  = THEATER_PRIVATE,
			Pos    = Vector( ... ),   -- top-left of screen
			Ang    = Angle( 0, 180, 0 ),
			Width  = 396,
			Height = 192,
			ThumbInfo = {             -- optional
				Pos = Vector( ... ),
				Ang = Angle( 0, 0, 0 )
			}
		}
	},

} )
```

### Standalone Workshop maps

If you distribute the map separately from the gamemode, put the location code in an autorun file instead:

```lua
-- garrysmod/lua/autorun/mymap.lua
hook.Add( "InitPostEntity", "mymap_locations", function()
	if not Location then return end

	Location.Add( "mymap", {
		-- locations here
	} )
end )
```

---

## 4. Manual theater placement (when entities are missing)

If the map is already compiled and you cannot re-add entities, you can define the theater completely inside the location table (see the `Theater = { ... }` block above).

Useful workflow:

1. Use `cinema_loc_vector` while standing at the desired top-left corner of the screen → paste into `Pos`.
2. Adjust `Ang` (especially the yaw) until the screen faces the audience.
3. Tweak `Width` and `Height` until the picture fills the wall correctly.
4. Optionally add `ThumbInfo` the same way.

Only **one** theater is allowed per location box.

---

## 5. Theater flags reference

| Constant | Use case |
|----------|----------|
| `THEATER_REPLICATED` | Normal public theater |
| `THEATER_PRIVATE` | Ownable / rentable private theater |
| `THEATER_PRIVILEGED` | Restricted / VIP theater |
| `THEATER_NONE` | Public but hidden from scoreboard |

---

## 6. Testing checklist

1. `cinema_debug_locations 1` – confirm every box is correct and non-overlapping.
2. Walk into each theater – the scoreboard should show the theater name and queue controls.
3. Request a short video – playback should start for everyone inside the location.
4. Test private theater ownership / renting if applicable.
5. Check thumbnails outside the rooms.

---

## 7. Example maps in the repository

Look at the existing files for real-world examples:

```
cinema_modded/gamemode/maps/
  cinema_theatron.lua
  theater_gcinema.lua
  lp_cinema_rc3.lua
  theater_nexmultiplex_1m.lua
```

The original `cinema_theatron.vmf` is also available in the repository root if you want to study a complete Hammer map.

---

## 8. Tips & common pitfalls

- Keep location boxes as tight as possible; large overlapping boxes cause ambiguous results.
- The screen `Pos` is the **top-left** corner of the 3D2D quad.
- Always test with the debug visualizers before publishing.
- If the “map unsupported” message still appears, the map name in `Location.Add` does not match `game.GetMap()`.
- Portable TVs / projectors are separate entities and do not require location boxes in the same way fixed theaters do.

---

## Related pages

- [Location System](location-system) – technical details of the spatial system
- [Debug Commands](debug-commands) – all visualizer and helper commands
- [Installation](installation)
