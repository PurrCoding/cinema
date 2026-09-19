# Installation

## Requirements

- Garry's Mod (x86-64 branch recommended for HTML playback)
- A map with Cinema theater support (`theater*`, `cinema*`, or custom maps using theater entities)
- Optional: [GMod CEF Codec Fix](https://github.com/solsticegamestudios/GModCEFCodecFix) for broader video codec support in Chromium

## From this repository

1. Download or clone the repository.
2. Copy the **`cinema_modded`** directory into:
   ```
   garrysmod/gamemodes/cinema_modded
   ```
3. Restart the game or server.
4. Set the gamemode:
   - **Listen / menu:** select *Cinema (Fixed Edition)* in the gamemode list  
   - **Dedicated server:** in `server.cfg` or launch options:
     ```
     gamemode cinema_modded
     ```
5. Start a supported map.

## From the Steam Workshop

Subscribe to the [Workshop addon](https://steamcommunity.com/sharedfiles/filedetails/?id=2419005587). For dedicated servers, add the Workshop ID to your server collection / `workshopid` as usual.

> **Note:** Workshop builds may lag behind this Git repository. Prefer Git for development and for the newest features (e.g. theater renting) until they are published to Workshop.

## Currency (renting)

If you use the [theater renting system](theater-renting.md), install a supported point system on the server:

- PointShop 1, or  
- PointShop 2  

The rent module auto-detects a provider unless you force one with `cinema_rent_currency`.

## Verify

1. Join a private theater area on a supported map.  
2. Open the scoreboard queue panel — video request and (if configured) **Rent Theater** should be available.  
3. Request a short YouTube (or other service) URL and confirm playback.
