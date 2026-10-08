# AGENTS.md

## What this file is for

This is a small set of engineering guidelines for the project, not a rigid style policy. Follow the existing code and architecture first, and use these notes when making changes or when the existing code leaves a decision open.

AI tools are welcome. Generated code still needs to fit the project, be understood by the contributor, and be checked for side effects before it is merged.

## Project context

Cinema is a Garry's Mod gamemode. Most of the runtime is Lua, with browser/CEF code in the web UI and media playback layer.

The important boundaries are:

- **SERVER** owns game state, permissions, persistence, and other authoritative decisions.
- **CLIENT** owns presentation, input, and CEF/browser interaction.
- **SHARED** is only for code that genuinely belongs on both realms.
- Network messages are an API between client and server; keep them small and validate them on the server.
- Follow the existing module structure under `cinema_modded/gamemode/modules/` instead of creating parallel systems.

When changing theater, video, service, queue, renting, location, seats, or scoreboard code, look for the existing abstraction and extend it rather than duplicating its responsibilities.

## Lua / Garry's Mod

Prefer straightforward Lua that matches the surrounding code.

- Keep CLIENT, SERVER, and SHARED responsibilities clear.
- Use the existing hooks, timers, entities, modules, and service interfaces where possible.
- Clean up timers, hooks, entities, and other temporary state when their owner goes away.
- Avoid global state unless the project already uses it intentionally.
- Keep functions focused and avoid clever abstractions that make GMod behavior harder to follow.
- Use tabs for indentation and keep formatting consistent with nearby files.
- Comments should explain intent, engine quirks, or non-obvious decisions rather than restating the code.

### Performance

Garry's Mod code can run every tick or for many players, so performance matters most in hot paths.

- Be suspicious of expensive work in `Think`, frequent hooks, entity loops, and network handlers.
- Avoid repeated table/string work and unnecessary allocations in hot paths.
- Cache globals as locals when a function is actually hot; do not turn every file into a wall of cached globals just for micro-optimisation.
- Prefer event-driven updates over polling when practical.
- Keep network traffic proportional to the information that actually needs to change.
- For CEF/UI work, avoid unnecessary DOM rebuilds, timers, layout work, and high-frequency Lua ↔ browser messages.

Optimize measured or obviously hot code. Readability is normally more valuable than tiny micro-optimisations.

## HTML / CSS / JavaScript / CEF

The browser side is part of the game, not a separate trusted application.

- Keep HTML, CSS, and JavaScript valid, readable, and modular.
- Prefer normal DOM APIs and event handlers over large inline scripts or fragile HTML injection.
- Keep Lua ↔ CEF communication explicit: define what messages exist, what data they accept, and what they are allowed to do.
- Treat anything coming from the browser as untrusted, even if it normally comes from our own UI.
- Never turn browser input directly into Lua code, console commands, filesystem operations, or arbitrary event/function calls.
- Validate and constrain values crossing the CEF boundary.
- Escape or safely insert user-controlled text; do not use `innerHTML` or equivalent injection paths when text/DOM APIs are sufficient.
- Keep assets and runtime work reasonably small. Avoid unnecessary dependencies and blocking work.

When a browser feature needs a new Lua bridge, prefer a narrow, named action with validated arguments over a generic "execute this" interface.

## Security

Security decisions belong primarily on the server.

- Never trust client-provided permissions, SteamIDs, entity ownership, queue state, or other authoritative values.
- Validate every network message before using its contents. Check types, ranges, ownership, permissions, and state where relevant.
- Privileged actions must be enforced server-side; client-side checks are only UX.
- Treat media URLs and external content as untrusted input. Validate them according to the service or feature that consumes them.
- Avoid arbitrary code execution such as `RunString`, `CompileString`, or equivalent dynamic execution, especially when input can originate from clients or CEF.
- Do not expose server-only implementation details or privileged functionality to the client.
- Be deliberate with filesystem access and never allow user input to select arbitrary files or paths.
- Rate-limit or otherwise constrain networked actions that can be spammed.
- Keep browser integrations narrow, because a browser surface is a larger attack surface than normal UI code.

If a change weakens a validation or permission boundary, stop and reconsider the design instead of treating the check as boilerplate.

## Changes and verification

Before changing code, understand the path through the existing system. Small, local changes are preferred when they solve the problem cleanly.

After a meaningful change, check the relevant realms and failure paths:

- normal multiplayer use, not only singleplayer;
- invalid or unexpected client input;
- connect/disconnect and map cleanup;
- timers, hooks, entities, and net receivers being created and removed correctly;
- CEF loading and Lua ↔ browser communication where applicable;
- queue/theater state remaining synchronized across players.

Do not add tests or abstractions only to satisfy this file. Add verification where it catches a realistic regression.

## When unsure

Prefer the existing project pattern over inventing a new one. If the code relies on a Garry's Mod engine quirk, verify the behavior against current GMod documentation or known engine issues before building a new dependency on it.

For conflicting goals, use this order as a practical guide:

1. Correctness and player/server safety
2. Security and authority boundaries
3. Stability and compatibility
4. Maintainability and readability
5. Performance
6. Convenience
