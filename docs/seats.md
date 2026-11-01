# Seats system

Cinema includes a lightweight seat system for supported chairs, sofas, and benches placed in theater maps.

## How it works

1. The seats module maps model paths to local seat offsets (`Pos` and optional `Ang`).
2. When a player uses a supported prop, the server creates a temporary seat entity at the configured offset and places the player in it.
3. The temporary seat is cleaned up when the player gets up or the seat is otherwise removed.

The basic prop-seat behavior does not require custom Hammer entities.

## Adding a chair model

Edit:

```text
cinema_modded/gamemode/modules/seats/sh_seats.lua
```

Add an entry to `ChairOffsets`:

```lua
ChairOffsets["models/path/to/your_chair.mdl"] = {
    { Pos = Vector(0, 0, 20), Ang = Angle(0, -90, 0) },
    -- Additional seat offsets for multi-seat models
    { Pos = Vector(0, 30, 20), Ang = Angle(0, -90, 0) },
}
```

Offsets are local to the prop model. Test the position and orientation in-game; small vertical and angular adjustments are common.

## Seat debugging and editor

Client ConVars:

| ConVar | Default | Description |
|---|---:|---|
| `cinema_seat_debug` | `0` | Show recognized props and their seat positions |
| `cinema_seat_editor` | `0` | Enable the editor mode |
| `cinema_seat_debug_numbers` | `1` | Show seat indices |
| `cinema_seat_debug_names` | `1` | Show model names |

Admins can aim at a prop and run `cinema_seat_select` to select it and open the editor. The editor provides 3D previews and controls for adjusting seat offsets. Verify edited offsets in `sh_seats.lua` before distributing them.

See [Debug commands](debug-commands.md) for more details.

## Server behavior

- The server-side seats module handles use interaction and temporary seat entities.
- Seat offsets are defined by model path in the shared seats module.
- Seats are separate from theater location definitions; location data still determines whether a player is inside a theater.

## Related pages

- [Location system](location-system.md)
- [Creating custom maps](creating-custom-maps.md)
- [Debug commands](debug-commands.md)
