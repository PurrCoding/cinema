# Seats System

Cinema includes a lightweight seat system so players can sit on chairs, sofas and benches that belong to a theater map.

---

## How it works

1. The module ships a large table `ChairOffsets` that maps **model paths** to one or more seat offsets (`Pos` + optional `Ang`).
2. When a player presses **use** on a prop whose model is in that table, the gamemode creates a temporary seat entity at the correct offset and puts the player into it.
3. Leaving the seat (jump / use again) removes the temporary entity.

No Hammer entities are required for the basic “sit on this prop” behaviour.

---

## Adding a new chair model

Edit (or override) the seats module:

```
cinema_modded/gamemode/modules/seats/sh_seats.lua
```

Add an entry:

```lua
ChairOffsets["models/path/to/your_chair.mdl"] = {
	{ Pos = Vector(0, 0, 20), Ang = Angle(0, -90, 0) },
	-- more seats for multi-seat models
	{ Pos = Vector(0, 30, 20), Ang = Angle(0, -90, 0) },
}
```

Tips for finding good offsets:

1. Spawn the model in Sandbox.
2. Noclip to the approximate sitting position.
3. Use `lua_run print(LocalPlayer():GetPos())` (or a measuring tool) relative to the prop origin.
4. Test in-game; small Z adjustments (±2–5) are common.

---

## Seat editor (client)

The seats module also contains a simple editor (`cl_editor.lua`) used during map development.  
It is mainly intended for internal use when defining new offsets; most mappers just edit `ChairOffsets` directly.

---

## Server behaviour

- `sv_init.lua` handles the actual “use → sit” logic and cleanup.
- Seats are not networked entities that persist; they exist only while a player is sitting.
- Admins / owners are not given special privileges for ordinary seats.

---

## Related

- Theater locations still determine whether a player is “in” a theater while seated.
- Portable TVs / projectors are separate entities and are not part of the seat system.
