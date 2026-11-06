# AGENTS.md

Engineering guidelines for Cinema (Fixed Edition). Follow existing code and architecture first. Use these notes when the existing code leaves a decision open.

## AI usage rules (strict)

AI-generated code is a draft, not a finished contribution.

- **Never apply AI output blindly.** Read it, understand it, and verify it against the existing codebase before committing.
- **Always report back** to the person who gave the prompt or ticket: what was changed, why, what was assumed, and what still needs human review.
- **No vibe-coding.** Do not produce large, speculative, or loosely related changes. Prefer small, deliberate edits that solve the stated problem.
- **No monkey-patching.** Do not paper over problems with hacks, global overrides, or parallel systems. Fit the change into the existing architecture.
- Every change must look like it belongs in this repository. Match style, patterns, naming, and layering already used in the surrounding code.
- If the correct fix is unclear, stop and ask instead of inventing a workaround.

## Copyright and license

Licensed under the **GNU General Public License v3.0** (`LICENSE.md`).

- Originally created by PixelTail Games (https://github.com/pixeltailgames/cinema).
- Continued by PurrCoding and contributors as Cinema (Fixed Edition).

**Rules:**

- Do not remove or alter copyright / license notices in source files or `LICENSE.md`.
- Do not relicense the project or remove GPL-3.0 obligations.
- When adding substantial new source files, include an appropriate copyright and GPL-3.0 notice consistent with the project.
- Modified versions must remain under GPL-3.0 when distributed.

## Project context

Cinema is a Garry's Mod **gamemode**. Most of the runtime is Lua, with browser/CEF code in the web UI and media playback layer.

**Boundaries:**

- **SERVER** owns game state, permissions, persistence, and other authoritative decisions.
- **CLIENT** owns presentation, input, and CEF/browser interaction.
- **SHARED** is only for code that genuinely belongs on both realms.
- Network messages are an API; keep them small and validate on the server.
- Follow the existing module structure under `cinema_modded/gamemode/modules/` instead of creating parallel systems.

When changing theater, video, service, queue, renting, location, seats, or scoreboard code, extend the existing abstraction rather than duplicating its responsibilities.

## Lua / Garry's Mod

Prefer straightforward Lua that matches surrounding code.

- Keep CLIENT, SERVER, and SHARED responsibilities clear.
- Use existing hooks, timers, entities, modules, and service interfaces.
- Clean up timers, hooks, entities, and temporary state when their owner goes away.
- Avoid global state unless the project already uses it intentionally.
- Keep functions focused; avoid clever abstractions that obscure GMod behavior.
- Use tabs for indentation; match nearby formatting.
- Comments explain intent, engine quirks, or non-obvious decisions — not the obvious.

### Performance

Code can run every tick or for many players. Performance matters most in hot paths.

- Be suspicious of expensive work in `Think`, frequent hooks, entity loops, and network handlers.
- Avoid repeated table/string work and unnecessary allocations in hot paths.
- Cache globals as locals only when a function is actually hot.
- Prefer event-driven updates over polling.
- Keep network traffic proportional to what actually needs to change.
- For CEF/UI work, avoid unnecessary DOM rebuilds, timers, layout thrashing, and high-frequency Lua ↔ browser messages.

Optimize measured or obviously hot code. Readability usually beats micro-optimisations.

## HTML / CSS / JavaScript / CEF

The browser side is part of the game, not a separate trusted application.

- Keep HTML, CSS, and JavaScript valid, readable, and modular.
- Prefer normal DOM APIs and event handlers over large inline scripts or fragile HTML injection.
- Keep Lua ↔ CEF communication explicit: define messages, accepted data, and allowed actions.
- Treat everything from the browser as untrusted, even when it normally comes from our own UI.
- Never turn browser input into Lua code, console commands, filesystem operations, or arbitrary calls.
- Validate and constrain values crossing the CEF boundary.
- Escape or safely insert user-controlled text; avoid `innerHTML` when text/DOM APIs suffice.
- Keep assets and runtime work reasonably small.

New Lua bridges should be narrow, named actions with validated arguments — not a generic "execute this" interface.

## Security

Security decisions belong on the server.

- Never trust client-provided permissions, SteamIDs, entity ownership, queue state, or other authoritative values.
- Validate every network message: types, ranges, ownership, permissions, state.
- Privileged actions must be enforced server-side; client-side checks are only UX.
- Treat media URLs and external content as untrusted input.
- Avoid arbitrary code execution (`RunString`, `CompileString`, etc.), especially with client or CEF input.
- Do not expose server-only details or privileged functionality to the client.
- Be deliberate with filesystem access; user input must never select arbitrary paths.
- Rate-limit or constrain networked actions that can be spammed.
- Keep browser integrations narrow; a browser surface is a larger attack surface than normal UI code.

If a change weakens a validation or permission boundary, stop and reconsider.

## Changes and verification

Understand the path through the existing system before changing code. Prefer small, local changes that solve the problem cleanly.

After meaningful changes, check relevant realms and failure paths:

- normal multiplayer use, not only singleplayer
- invalid or unexpected client input
- connect/disconnect and map cleanup
- timers, hooks, entities, and net receivers created and removed correctly
- CEF loading and Lua ↔ browser communication
- queue/theater state remaining synchronized across players

Do not add tests or abstractions only to satisfy this file. Add verification where it catches a realistic regression.

## When unsure

Prefer the existing project pattern over inventing a new one. If code relies on a Garry's Mod engine quirk, verify against current documentation or known engine issues.

If the right approach is unclear: **ask the person who assigned the work** instead of guessing.

Priority order when goals conflict:

1. Correctness and player/server safety
2. Security and authority boundaries
3. Stability and compatibility
4. Maintainability and readability
5. Performance
6. Convenience
