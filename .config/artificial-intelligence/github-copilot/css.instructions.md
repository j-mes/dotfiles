---
description: Global CSS conventions
applyTo: "**/*.css"
---
# CSS
- Use modern layout tools: CSS Grid for 2D layouts, Flexbox for 1D alignment.
- Prefer **CSS custom properties** (`--color-primary`) for theming and reuse.
- Use **logical properties** (`margin-inline`, `padding-block`) for better internationalization.
- Default to `rem`/`em` units for spacing and typography; use `clamp()` for fluid font sizes.
- Prefer `min()`, `max()`, `clamp()` and `aspect-ratio` for responsive design over media queries when possible.
- Respect user preferences: `prefers-reduced-motion`, `prefers-color-scheme`.
- Layer styles logically: reset/normalize → base → layout → components → utilities.
- Keep files modular and scoped: component CSS should not leak globally.
- Avoid `!important`; structure selectors to prevent specificity wars.
- Use `@media (min-width: …)` (mobile-first approach).
- Ensure sufficient color contrast (WCAG AA minimum).

## Additional conventions (British English & readability)

- Use British English for human-facing text in comments, documentation and token names (e.g. `--colour-primary`, `organisation`, `optimise`). Do not change standard CSS keywords or spec names (leave `prefers-color-scheme` as-is in code examples).
- Prioritise readability over terseness when naming tokens, classes and variables. Prefer full words over cryptic abbreviations.

## Naming & tokens

- Token naming: keep a predictable structure. Examples:
	- Theme tokens: `--colour-primary`, `--colour-accent`, `--space-4`, `--font-size-base`
	- Component tokens (scoped): `--button-gap`, `--card-bg`
- Keep global theme tokens in a central `tokens.css` (or `tokens/` folder) and import or reference them in component files.
- Avoid single-letter or halved/ambiguous names in tokens and variables. Prefer `--error-colour` over `--err` or `--bg` where clarity matters.

## Class naming & scoping

- Prefer component-scoped classes or CSS Modules to avoid leakage. If using a naming convention, be explicit:
	- BEM: `.button`, `.button--primary`, `.button__icon`
	- Or prefix classes with component name: `.card`, `.card-title`, `.card--collapsed`
- Keep nesting shallow (max 2 levels) when using preprocessors to avoid fragile selectors.

## Architecture & organisation

- Follow the layer order you already have: reset/normalize → base → tokens → layout → components → utilities.
- Consider ITCSS/SMACSS patterns for large codebases: separate settings (tokens), tools (mixins), generic, elements, objects, components, utilities.
- Co-locate component CSS with the component source (e.g. `Button.tsx` + `Button.css`) and keep tokens/global utilities in a central folder.

## Accessibility (explicit rules)

- Ensure visible focus styles. Do not remove focus outlines without replacing them with an accessible alternative (use `:focus-visible`).
	- Example: `:focus-visible { outline: 3px solid var(--colour-focus); outline-offset: 3px; }`
- Provide skip-links for long pages and ensure keyboard navigation works for all interactive components.
- Test colour contrast against WCAG AA (minimum) and consider `prefers-contrast` for users who request stronger contrast.
- Do not rely solely on colour to convey information; provide additional cues (icons, text, ARIA where appropriate).

## Animations & performance

- Prefer animating `transform` and `opacity` for smooth, GPU-accelerated transitions. Avoid animating layout properties (`width`, `height`, `top`, `left`) when possible.
- Respect reduced-motion preferences with a media query fallback:
	- `@media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation: none !important; transition: none !important; } }`
- Use `will-change` sparingly and remove it after transitions to avoid memory pressure.

## Modern features & responsiveness

- Use container queries (`@container`) for component-level responsiveness when supported; provide sensible fallbacks or graceful degradation.
- Prefer fluid typographic scales using `clamp()` and sensible `line-height` conventions (unitless values are recommended for predictability).

## Testing, linting & CI

- Add Stylelint to CI with a shared configuration (e.g. `stylelint-config-standard`) and consider `stylelint-a11y` for accessibility checks.
- Recommend visual regression testing for critical components/pages (Playwright snapshots, Percy, Chromatic) in CI.
- Example scripts to add to `package.json`:
	- `"lint:css": "stylelint \"**/*.css\""`
	- `"test:visual": "npx playwright test --project=chromium"`

## Tooling suggestions

- Use PostCSS + Autoprefixer if you need to support older browsers; keep browserslist in the repo root.
- Suggested Stylelint plugins: `stylelint-order`, `stylelint-a11y`, `stylelint-declaration-block-no-ignored-properties`.
- If using a utility-first framework (Tailwind), keep configuration and purge/scan lists strict to avoid shipping unused styles.

## CSS-in-JS / component styling

- If a package uses CSS-in-JS (styled-components, emotion, stitches) prefer co-located component styles and shared theme tokens. Avoid mixing global CSS and CSS-in-JS for the same component.
- Keep dynamic styling performant: avoid heavy calculations in style props on every render.

## Readability & naming rules (align with global conventions)

- Use British English in comments, documentation and token names (e.g. `--colour-background`).
- Prefer full words and clear identifiers: avoid `err`, `el`, `cfg` in favour of `error`, `element`, `config` unless the abbreviation is conventional (`id`, `url`, `json`).

## Small examples

- Focus-visible:
	- `:focus-visible { outline: 3px solid var(--colour-focus); outline-offset: 2px; }`
- Reduced motion:
	- `@media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }`
- Performance-friendly animation:
	- `.fade-in { transform: translateY(0); opacity: 1; transition: transform 200ms ease, opacity 200ms ease; }`

## Files & organisation

- Suggested file layout:
	- `tokens/` — design tokens and global CSS variables
	- `base/` — resets, typography, global elements
	- `layout/` — grid and layout utilities
	- `components/` — component styles, co-located where appropriate
	- `utilities/` — helper classes (very small, well-documented)
