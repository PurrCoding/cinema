# Configuration

Most options are **ConVars**. Archive flags mean they persist in `server.cfg` / client config when set.

## Server

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_queue_mode` | `1` | `1` = players may vote videos up/down; `2` = play in request order |
| `cinema_skip_ratio` | `0.66` | Share of players in the theater required to voteskip (0–1) |
| `cinema_video_duration_max` | `10800` | Max video length in **public** theaters (seconds) |
| `cinema_allow_reset` | `0` | Reset the theater when all players leave |
| `cinema_allow_voice` | `0` | Allow voice chat among theater viewers |
| `cinema_allow_3dvoice` | `1` | Use 3D positional voice |
| `cinema_url` | built-in host | Base URL loaded on theater screens (override only if you host custom HTML) |
| `cinema_spawn_popcorn` | `0` | Give `weapon_popcorn` on spawn (also in gamemode settings) |
| `cinema_enable_sandbox` | `0` | Experimental Sandbox features (see gamemode settings; often singleplayer-oriented) |
| `cinema_service_imageduration` | `0` | Duration for image-like media (`0` = infinite, max 60) |

### Theater renting

See [Theater renting](theater-renting.md) for the full `cinema_rent_*` list.

## Client

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_volume` | `50` | Theater volume (0–100) |
| `cinema_resolution` | `1080` | Preferred playback resolution hint |
| `cinema_mute_nofocus` | `1` | Mute when the game window is not focused |
| `cinema_hideplayers` | `0` | Reduce visibility of other players in theaters |
| `cinema_hide_amount` | `0.11` | Strength of player hiding when enabled |
| `cinema_drawnames` | `1` | Draw player names |
| `cinema_smoother` | `1` | Smoother HTML video at a possible FPS cost |
| `cinema_html_filter` | `0` | HTML filter option |

Many of these are also exposed in the **scoreboard → Settings** panel.

## Gamemode settings UI

`cinema_modded.txt` registers menu checkboxes for:

- Spawn with popcorn  
- Enable Sandbox (experimental)  
- Allow 3D voice  
- Allow voice in theater  
- Allow reset when empty  

## Maps

The gamemode prefers maps matching `theater|theater_|cinema_`. Additional Lua setup lives under `cinema_modded/gamemode/maps/`. Custom maps need theater entities / location data consistent with the location module.
