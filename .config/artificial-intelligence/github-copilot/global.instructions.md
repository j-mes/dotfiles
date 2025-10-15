---
description: Unified global conventions for GitHub Copilot and contributors
applyTo: '**/*'
---

# Global Conventions

-   Use British English in all human-facing text (`organisation`, `colour`, `optimise`).
-   Write code that future you can understand at 3 a.m. — clear, explicit, and intentional.

## General Rules

-   UTF-8, LF endings, tabs by default (unless a project dictates spaces).
-   `camelCase` for variables/functions, `PascalCase` for types/classes, `kebab-case` for files.
-   Prefer readability to cleverness. Explain _why_, not _what_, in comments.
-   Avoid duplication; extract reusable modules.
-   Test before you commit. Every new feature gets a test.
-   Never hardcode secrets; use environment variables or config files.
-   Prefer full words (`error`, `config`, `quantity`) to vague truncations (`err`, `cfg`, `qty`).
-   `id`, `url`, `json` are the only acceptable short forms.

---

## Committing

Our commit messages use a simplified form of Conventional Commits[^1].
This helps automated release tooling determine the semantic version bump and group notes correctly.

```shell
<type>: <description>
[body]
```

### Commit type prefixes

The `type` can be one of `feat`, `fix`, `docs`, or `backstage`.

The prefix is used to calculate the semver release level and the section of the release notes to place the commit message in.

| **type**  | when to use                         | release level | release note section |
| --------- | ----------------------------------- | ------------- | -------------------- |
| feat      | a feature has been added            | `minor`       | **Features**         |
| fix       | a bug has been patched              | `patch`       | **Bug fixes**        |
| docs      | a change to documentation           | none          | **Documentation**    |
| backstage | any changes that aren't user-facing | none          | none                 |

Indicate a breaking change by placing an `!` between the type name and the colon, for example:

```shell
feat!: add large mouse
## this is breaking because it may distract large cats in user code
```

## HTML

-   Use semantic elements (`header`, `main`, `section`, `article`, `footer`) rather than generic `div`s.
-   Always declare `<html lang="en-GB">`.
-   Include standard meta: charset UTF-8 and viewport.
-   Provide meaningful `<title>` and `<meta name="description">`.
-   Each form control must have a `<label>`.
-   Use `<button>` for actions, never `<div>` or `<span>`.
-   Load scripts as `type="module" defer`.
-   Keep markup minimal and accessible; ARIA only when truly necessary.
-   Validate HTML in CI using `html-validate` or similar.

---

## CSS

-   Modern layout tools first: **Grid** for 2D, **Flexbox** for 1D.
-   Prefer CSS custom properties for tokens (`--colour-primary`).
-   Use logical properties (`margin-inline`, `padding-block`) for international layouts.
-   Default to `rem`/`em`; use `clamp()` for fluid sizing.
-   Respect user preferences (`prefers-reduced-motion`, `prefers-colour-scheme`).
-   Follow layer order: reset → base → layout → components → utilities.
-   Avoid `!important`; fix specificity instead.
-   Mobile-first queries: `@media (min-width: …)`.
-   Maintain WCAG AA colour contrast; don’t rely solely on colour to convey information.
-   Use British spellings in token names: `--colour-accent`, not `--color-accent`.
-   Co-locate component CSS; keep global tokens in `tokens.css`.
-   Test focus visibility with keyboard; always provide clear `:focus-visible` styles.
-   Animate only `transform` and `opacity`; honour `prefers-reduced-motion`.
-   Use `light-dark()` for colour tokens and `@media (prefers-colour-scheme)` for fallbacks.
-   Lint with `stylelint-config-standard` + `stylelint-a11y`; include in CI.

---

## JavaScript (ES2022+)

-   Default to ESM (`"type":"module"`). Use `import`/`export`.
-   Avoid CommonJS unless needed for compatibility.
-   Handle promises explicitly; never leave them floating.
-   Functional patterns preferred; no classes in React.
-   Prefer `forEach`, `map`, and `filter` over `reduce` for clarity and maintainability.
-   Prefer **destructuring** (`const { name } = obj`) over excessive use of **spread operators** (`{ ...obj }`) when accessing or assigning properties.
-   Comment _why_, not _what_.
-   Use `.js` for all modules — avoid `.cjs`/`.mjs`.

---

## TypeScript

-   Target modern ESM; enable `strict` mode (`noImplicitAny`, `strictNullChecks`).
-   Add explicit param and return types.
-   Use `zod` for runtime validation and derive types from schemas.
-   Prefer `const`, immutable data, and narrow types via guards.
-   Keep modules cohesive (< 300 LOC).
-   Group imports: std/lib → external → internal, then alphabetise.
-   Document public functions with JSDoc.

---

## Node Runtime

-   Node 18 +; use `node:` specifiers where available.
-   Prefer built-ins to third-party packages.
-   Use top-level `await`; avoid IIFEs.
-   HTTP via `fetch` or `undici` with retries + timeouts.
-   Structured logs (`pino` or `console`); no stray debug prints.
-   Use `pnpm` workspaces; lockfile committed.
-   Libraries throw typed Errors; CLIs may `process.exit(1)`.

---

## React (Modern)

-   Function components + hooks only — no classes.
-   Co-locate tests + styles with components.
-   Use controlled inputs and derived state.
-   React Query/TanStack Query for server data.
-   Semantic HTML + keyboard support; minimal `aria-*`.
-   Style with Modern CSS or CSS-in-JS, not legacy patterns.

### Testing Guidance:

-   Vitest + Testing Library for unit/integration.
-   Playwright for E2E.
-   Query by role/label/text first; avoid `data-testid` unless necessary.
-   Mock network with `msw`.
-   Include automated accessibility checks (`axe-core` or `vitest-axe`).

---

## Tests

-   Use **Vitest + Testing Library** for frontend, **Playwright** for e2e, **Node test runner** for backend libs.
-   Test behaviour and public API, not implementation details.
-   Mock network; no live HTTP.
-   Keep deterministic (fake timers > real waits).
-   One happy-path + one edge-case per public function or component.
-   Co-locate tests with source unless project dictates otherwise.

---

## Quality & Tooling

-   ESLint (flat config) + TypeScript ESLint. Prettier = formatter only.
-   Use `eslint-disable` comments rarely and justify them.
-   Validate env vars via a single `zod` schema.
-   CI must run lint → typecheck → unit tests for PRs.
-   Use visual regression tools (Playwright snapshots, Percy, Chromatic) for key UI.
-   Keep PRs small; document migrations.

CI example (minimal):

```yaml
# .github/workflows/ci.yml
jobs:
    build:
        steps:
            - run: pnpm install --frozen-lockfile
            - run: pnpm lint
            - run: pnpm typecheck
            - run: pnpm test:ci
```

---

## Accessibility First

-   Visible focus indicators.
-   Skip-links for long pages.
-   Sufficient contrast and alternative cues beyond colour.
-   Keyboard operability everywhere.
-   Honour `prefers-reduced-motion`.
-   Test with screen readers where possible.

---

## Closing Notes

These defaults exist so each `AGENTS.md` can focus on project nuance — framework choices, architecture, tone.
The global file enforces shared civility in code: clarity, accessibility, and the quiet virtue of readable naming.
Please respect these conventions in all contributions.

[^1]: https://www.conventionalcommits.org/en/v1.0.0/
