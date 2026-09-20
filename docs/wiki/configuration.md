# Configuration

Most options are **ConVars**. Flags such as `FCVAR_ARCHIVE` mean the value is saved and restored (server.cfg / client config).

---

## Server ConVars

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_queue_mode` | `1` | `1` = players may vote videos up/down · `2` = play in request order (chronological) |
| `cinema_skip_ratio` | `0.66` | Fraction of players in the theater required to voteskip (0–1) |
| `cinema_video_duration_max` | `10800` | Maximum video length in **public** theaters (seconds). Private theaters are not limited by this. |
| `cinema_allow_reset` | `0` | If `1`, reset the theater when all players leave |
| `cinema_allow_voice` | `0` | Allow voice chat among theater viewers |
| `cinema_allow_3dvoice` | `1` | Use 3D positional voice |
| `cinema_url` | built-in host | Base URL loaded on theater screens. **Do not change** unless you host custom HTML. |
| `cinema_spawn_popcorn` | `0` | Give `weapon_popcorn` on spawn |
| `cinema_enable_sandbox` | `0` | Experimental Sandbox features (mostly useful in single-player) |
| `cinema_service_imageduration` | `0` | Duration for image-like media (`0` = infinite, max 60) |

### Theater renting ConVars

See the dedicated [Theater renting](theater-renting) page for the full `cinema_rent_*` list.

Example `server.cfg` snippet:

```cfg
cinema_queue_mode 1
cinema_skip_ratio 0.66
cinema_video_duration_max 10800
cinema_allow_reset 0
cinema_allow_voice 0
cinema_allow_3dvoice 1
```

---

## Client ConVars

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_volume` | `50` | Theater volume (0–100) |
| `cinema_resolution` | `1080` | Preferred playback resolution hint (clamped 2–1080) |
| `cinema_mute_nofocus` | `1` | Mute when the game window is not focused |
| `cinema_hideplayers` | `0` | Reduce visibility of other players inside theaters |
| `cinema_hide_amount` | `0.11` | Strength of player hiding (0–1) |
| `cinema_drawnames` | `1` | Draw player names |
| `cinema_smoother` | `1` | Smoother HTML video (possible FPS cost) |
| `cinema_html_filter` | `0` | HTML filter option |

Most of these are also exposed in the **scoreboard → Settings** panel.

---

## Gamemode settings UI

The file `cinema_modded.txt` registers menu checkboxes for:

- Spawn with popcorn
- Enable Sandbox (experimental)
- Allow 3D voice
- Allow voice in theater
- Allow reset when empty

These mirror the corresponding ConVars.

---

## Maps & location data

The gamemode prefers maps whose names match `theater|theater_|cinema_`.  
Additional per-map Lua lives under:

```
cinema_modded/gamemode/maps/
```

Custom maps need both:

1. Theater entities (or manual Theater tables in the location file)
2. Location bounding boxes registered with `Location.Add`

See [Location System](location-system) and [Creating Custom Maps](creating-custom-maps).

---

## Related pages

- [Commands](commands)
- [Debug Commands](debug-commands)
- [Theater Renting](theater-renting)
