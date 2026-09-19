# Theater renting

Private theaters can be rented for a limited time using the server’s point system. While rented, the renter is the theater owner for the full duration—even if they disconnect and rejoin.

## Player guide

### Renting
1. Enter a **private** theater.  
2. Open the **queue** panel on the scoreboard.  
3. Click **Rent Theater**, choose a duration (minutes), and confirm.  
4. Cost is `minutes × cinema_rent_cost_per_minute` in the active currency.

### While you are the renter
From the **owner** panel (scoreboard admin/owner side):

- **Add rent time** — extend the current rent (you pay the extra minutes)  
- **Refund rent** — end the rent early and reclaim remaining value  
- **Player filter** — whitelist or blacklist SteamIDs  
- **Toggle vote-skip lock** — prevent voteskips while you own the theater  

### Admins
Admins can **Cancel rent** on a theater they do not own. The owner is refunded remaining time. If the owner is offline, the refund is queued and applied on their next connect.

## Requirements

- A private theater location on the map  
- A supported currency provider:
  - PointShop 1  
  - PointShop 2 (standard or premium points)  

If no provider is available, players see a clear “no currency” announcement and cannot rent.

## ConVars

### Shared (replicated)

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_rent_cost_per_minute` | `10` | Points charged per minute of rent |
| `cinema_rent_min_time` | `1` | Minimum rent length (minutes) |
| `cinema_rent_max_time` | `300` | Maximum rent length (minutes) |
| `cinema_rent_ps2_premium` | `0` | If `1`, use PointShop 2 **premium** points |
| `cinema_rent_currency` | `""` | Force provider id (`pointshop1`, `pointshop2`, …). Empty = auto-detect |

### Server only

| ConVar | Default | Description |
|--------|---------|-------------|
| `cinema_rent_prevent_unrented` | `0` | If `1`, private theaters cannot be used until rented |
| `cinema_rent_admins_ignore_filter` | `1` | Admins may enter filtered theaters |
| `cinema_rent_admins_alert_filtered` | `1` | Warn admins when they are filtered |
| `cinema_rent_super_alert_admin_filtered` | `1` | Alert superadmins when an admin enters a filtered theater |

Example `server.cfg` snippet:

```
cinema_rent_cost_per_minute 15
cinema_rent_min_time 5
cinema_rent_max_time 120
cinema_rent_prevent_unrented 0
```

## Behavior notes

- **Ownership** is stored by SteamID; leaving the theater does not end the rent.  
- **Refunds** use remaining time (rounded up to whole minutes for partial minutes).  
- **Pending refunds** apply when an offline owner reconnects.  
- UI updates when rent ends: owner controls hide and **Rent Theater** returns in the queue panel.  
- Translations for rent strings ship in English and German; other locales fall back to English for newer keys.

## Module layout

```
cinema_modded/gamemode/modules/rent/
  sh_config.lua      ConVars and accessors
  sh_currency.lua    Currency providers
  sh_rent.lua        Shared helpers (rent/refund net from client)
  sv_theater.lua     Theater class extensions (rent lifecycle)
  sv_net.lua         Networking + rate limits
  sv_hooks.lua       Enter / queue / filter hooks
  sv_player.lua      Player connect (pending refunds)
  cl_rent.lua        Client rent state
  cl_windows.lua     Rent and filter VGUI
```
