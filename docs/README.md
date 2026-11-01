# Cinema documentation

This documentation lives in the repository and is reviewed and versioned with the code. Links below are relative Markdown paths, so they continue to work on branches, forks, and local clones.

## Getting started

| Guide | Description |
|---|---|
| [Installation](installation.md) | Install the gamemode, verify a setup, and troubleshoot common issues |
| [Configuration](configuration.md) | Server, client, renting, and debug ConVars |
| [Commands](commands.md) | Console commands grouped by player, privileged, editor, and diagnostic use |

## Server owners and players

| Guide | Description |
|---|---|
| [Theater renting](theater-renting.md) | Currency integration, renting, extensions, refunds, and player filters |
| [Seats](seats.md) | Supported chair props and seat configuration |

## Mapping and debugging

| Guide | Description |
|---|---|
| [Location system](location-system.md) | Location registration, theater definitions, and spatial lookup |
| [Creating custom maps](creating-custom-maps.md) | Hammer entities and Lua location files |
| [Debug commands](debug-commands.md) | Location, teleport, seat, and SQL diagnostics |

## Development

| Guide | Description |
|---|---|
| [Theater architecture](theater-architecture.md) | THEATER, VIDEO, SERVICE, and client/server flow |
| [Custom video service](custom-video-service.md) | Implement a new media provider |
| [Translations](translations.md) | Add or update UI languages |
| [Development](development.md) | Repository layout, module conventions, and contribution notes |
| [AGENTS.md](../AGENTS.md) | Engineering and AI-assisted contribution guidelines |

## Keeping documentation current

- Update the relevant page in the same change as the code or configuration it describes.
- Prefer paths relative to the current Markdown file; include the .md extension.
- Document only commands, ConVars, defaults, permissions, and behavior that exist in the current source.
- If a command or option is removed, remove it from the docs in the same change.
- Keep the root [README](../README.md) concise and use this index for detailed guides.
