# Installation

## Requirements

- **Garry's Mod** (the x86-64 branch is strongly recommended for modern HTML/Chromium playback).
- A supported map: a `theater*` or `cinema*` map, or a map that includes theater entities and location data.
- [GModPatchTool](https://github.com/solsticegamestudios/GModPatchTool) is strongly recommended for broader codec support such as H.264.

> **Compatibility warning:** Cinema (Fixed Edition) conflicts with the original PixelTail Cinema addon and its forks. Unsubscribe from or remove other Cinema gamemodes before using this edition.

## Method 1 – Steam Workshop

1. Subscribe to [Cinema (Fixed Edition)](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587).
2. For a dedicated server, add Workshop ID `2419005587` to your collection or Workshop download list.
3. Restart the server/client if needed.
4. Select **Cinema (Fixed Edition)** (`cinema_modded`) as the gamemode and start a supported map.

Workshop builds may lag behind the repository. Use the Git version when you need the latest source changes or are developing.

## Method 2 – Install from this repository

1. Clone the repository:

   ```bash
   git clone https://github.com/PurrCoding/cinema.git
   ```

2. Copy the `cinema_modded` directory into:

   ```text
   garrysmod/gamemodes/cinema_modded/
   ```

3. Restart the game or server.
4. Select `cinema_modded` in the gamemode menu, or set it in the dedicated server configuration:

   ```cfg
   gamemode cinema_modded
   ```

5. Start a supported map.

## Optional theater-renting dependencies

The renting module supports the built-in PointShop 1 and PointShop 2 currency providers. Install and configure one of those addons if you want players to pay for private-theater rentals. Without a compatible provider, renting cannot charge players.

See [Theater renting](theater-renting.md) for the currency ConVars and behavior.

## Verification checklist

1. Join a supported map and enter a theater location.
2. Open the scoreboard (default `TAB`) and confirm the queue/request interface appears.
3. Request a short video URL and confirm playback starts for everyone in the theater.
4. If renting is configured, confirm the rent controls appear in a private theater.
5. If playback fails, check the troubleshooting section below and try `cinema_refresh` in the client console.

## Troubleshooting

| Symptom | Likely cause | Suggested fix |
|---|---|---|
| Missing menus or textures | Another Cinema addon/fork is installed | Unsubscribe from conflicting addons and restart |
| Doors or screens do not work | The server is running another gamemode | Set `gamemode cinema_modded` and change to a supported map |
| Map unsupported | No matching map location data | Add a location file under `cinema_modded/gamemode/maps/`; see [Creating custom maps](creating-custom-maps.md) |
| Black screen or playback errors | Missing codecs or incompatible CEF | Use the x86-64 branch and install GModPatchTool |
| History/database errors | SQLite initialization or filesystem permissions | Allow the gamemode to create its SQLite tables and check server write permissions |
| A provider works for some URLs but not others | Provider-specific URL or codec limitations | Test a supported URL type and check the provider's requirements |

## Related pages

- [Documentation index](README.md)
- [Configuration](configuration.md)
- [Commands](commands.md)
- [Creating custom maps](creating-custom-maps.md)
