---
description: Unit/integration/e2e testing rules
applyTo: "**/*.test.ts,**/*.spec.ts,**/*.test.tsx,**/*.spec.tsx,**/*.test.js,**/*.spec.js,**/*.test.jsx,**/*.spec.jsx,**/playwright/**"
---
# Tests
This repository prefers the following defaults, but choose the runner based on the type of project being tested.

- Vitest + Testing Library for unit/integration; Playwright for e2e (default for frontend/UI projects).

When to use which runner
- Frontend / component libraries (React, Vue, Svelte, Solid, etc.; any project with DOM/JSX/TSX):
    - Use Vitest together with Testing Library (e.g. `@testing-library/react`) and `jsdom` or the built-in environment Vitest provides.
    - Benefits: fast isolated runs, built-in mocking, snapshot support, TypeScript out-of-the-box, Vite-compatible transforms, and excellent DX (watch, filtering, coverage).

- Full application (Vite/webpack-based SPA, component-driven apps):
    - Use Vitest for unit and integration tests; use Playwright for end-to-end tests.

- Node-only libraries, CLI tools, or backend services (no DOM):
    - Prefer the Node.js built-in test runner (`node --test`) when you want zero runtime dependencies, minimal config, and the smallest surface area.
    - Use Testing Library style assertions only where DOM APIs are required; otherwise use plain assertions / assertion helpers tailored to Node (or lightweight libraries).
    - Use Vitest when you need richer features (advanced mocking, snapshotting, plugin ecosystem, faster watch iteration when using Vite, or Jest-like ergonomics).

- Monorepos / mixed workspaces:
    - Use Vitest for packages that are UI/front-end facing.
    - For pure Node packages in the same monorepo, you may keep the Node test runner to avoid adding extra dependencies; document the choice in that package's README.

Test guidance (rules for Copilot & contributors)
- Test the contract, not implementation details. Prefer queries by role/text for UI; prefer behaviour/spec for libraries.
- Use `msw` (mock service worker) for network interactions — avoid real HTTP in tests.
- Keep tests deterministic: avoid real timers/sleeps; use fake timers when applicable and restore them after each test.
- Snapshot only for stable UI or serialized config; do not snapshot frequently-changing output.

Tiny contract (what tests should assert)
- Inputs: public API (props, function args, CLI args, environment)
- Outputs: return values, emitted events, rendered DOM, CLI exit codes
- Error modes: invalid input, network failures (mocked), permission/auth errors
- Success criteria: deterministic, isolated, fast (<50ms per unit test ideally)

Edge cases to cover in tests
- Null/undefined / empty inputs
- Large payloads or pagination boundaries
- Slow / failing network responses (use `msw` to simulate)
- Concurrent access / race conditions where applicable

Example scripts
- package.json examples you can add per-package:
    - Vitest (frontend):
        - `"test": "vitest"`
        - `"test:ci": "vitest --run --coverage"
    - Node built-in (backend/library):
        - `"test": "node --test"`
        - `"test:watch": "node --test --watch"`

Additional setup notes
- For Vitest-based React packages, include a `test/setupTests.ts` to wire `msw` and `@testing-library/jest-dom` (see `test/setupTests.ts` example templates). Configure `vitest.config.ts` with `setupFiles: './test/setupTests.ts'` and `environment: 'jsdom'`.
- Document the chosen runner and the path to the setup file in each package README so Copilot and contributors know where to look.

Minimal conventions
- Prefer ESM and Node 18+ test features where possible.
- Keep test files colocated with source (component.tsx + component.test.tsx) unless the project prefers a separate `tests/` folder.
- Always include one happy-path unit test and one edge-case test for each public function/component.

Notes for maintainers
- When adding a new package to the repo, document the chosen test runner in that package's README and include install + run examples.
- If migrating from Jest, prefer Vitest for UI packages for minimal API friction.
