---
description: Node runtime & tooling conventions
applyTo: "**/server/**,**/api/**,**/*.server.ts,**/*.server.js"
---
# Node
- Node 18+ APIs; use `node:` specifiers where available.
- Use Node built-ins over external deps where possible.
- Use top-level `await` in modules; avoid IIFEs.
- Use `undici`/native fetch; centralize HTTP in a small client wrapper with retries & timeouts.
- Use `pino` or `console` with structured logs; no noisy debug prints in committed code.
- Prefer `pnpm` for workspaces; lockfile must be committed.
- Fail fast: `process.exit(1)` only in CLIs; libraries throw typed errors with causes.
