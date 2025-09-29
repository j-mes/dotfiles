---
description: Global CSS conventions
applyTo: '**/*.css'
---

# CSS

-   Use modern layout tools: CSS Grid for 2D layouts, Flexbox for 1D alignment.
-   Prefer **CSS custom properties** (`--color-primary`) for theming and reuse.
-   Use **logical properties** (`margin-inline`, `padding-block`) for better internationalization.
-   Default to `rem`/`em` units for spacing and typography; use `clamp()` for fluid font sizes.
-   Prefer `min()`, `max()`, `clamp()` and `aspect-ratio` for responsive design over media queries when possible.
-   Respect user preferences: `prefers-reduced-motion`, `prefers-color-scheme`.
-   Layer styles logically: reset/normalize → base → layout → components → utilities.
-   Keep files modular and scoped: component CSS should not leak globally.
-   Avoid `!important`; structure selectors to prevent specificity wars.
-   Use `@media (min-width: …)` (mobile-first approach).
-   Ensure sufficient color contrast (WCAG AA minimum).

## Additional conventions (British English & readability)

-   Use British English for human-facing text in comments, documentation and token names (e.g. `--colour-primary`, `organisation`, `optimise`). Do not change standard CSS keywords or spec names (leave `prefers-color-scheme` as-is in code examples).
-   Prioritise readability over terseness when naming tokens, classes and variables. Prefer full words over cryptic abbreviations.

## Naming & tokens

-   Token naming: keep a predictable structure. Examples:
    -   Theme tokens: `--colour-primary`, `--colour-accent`, `--space-4`, `--font-size-base`
    -   Component tokens (scoped): `--button-gap`, `--card-bg`
-   Keep global theme tokens in a central `tokens.css` (or `tokens/` folder) and import or reference them in component files.
-   Avoid single-letter or halved/ambiguous names in tokens and variables. Prefer `--error-colour` over `--err` or `--bg` where clarity matters.

## Class naming & scoping

-   Prefer component-scoped classes or CSS Modules to avoid leakage. If using a naming convention, be explicit:
    -   BEM: `.button`, `.button--primary`, `.button__icon`
    -   Or prefix classes with component name: `.card`, `.card-title`, `.card--collapsed`
-   Keep nesting shallow (max 2 levels) when using preprocessors to avoid fragile selectors.

## Architecture & organisation

-   Follow the layer order you already have: reset/normalize → base → tokens → layout → components → utilities.
-   Consider ITCSS/SMACSS patterns for large codebases: separate settings (tokens), tools (mixins), generic, elements, objects, components, utilities.
-   Co-locate component CSS with the component source (e.g. `Button.tsx` + `Button.css`) and keep tokens/global utilities in a central folder.

## Accessibility (explicit rules)

-   Ensure visible focus styles. Do not remove focus outlines without replacing them with an accessible alternative (use `:focus-visible`).
    -   Example: `:focus-visible { outline: 3px solid var(--colour-focus); outline-offset: 3px; }`
-   Provide skip-links for long pages and ensure keyboard navigation works for all interactive components.
-   Test colour contrast against WCAG AA (minimum) and consider `prefers-contrast` for users who request stronger contrast.
-   Do not rely solely on colour to convey information; provide additional cues (icons, text, ARIA where appropriate).

## Animations & performance

-   Prefer animating `transform` and `opacity` for smooth, GPU-accelerated transitions. Avoid animating layout properties (`width`, `height`, `top`, `left`) when possible.
-   Respect reduced-motion preferences with a media query fallback:
    -   `@media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation: none !important; transition: none !important; } }`
-   Use `will-change` sparingly and remove it after transitions to avoid memory pressure.

## Modern features & responsiveness

-   Use container queries (`@container`) for component-level responsiveness when supported; provide sensible fallbacks or graceful degradation.
-   Prefer fluid typographic scales using `clamp()` and sensible `line-height` conventions (unitless values are recommended for predictability).

## Testing, linting & CI

-   Add Stylelint to CI with a shared configuration (e.g. `stylelint-config-standard`) and consider `stylelint-a11y` for accessibility checks.
-   Recommend visual regression testing for critical components/pages (Playwright snapshots, Percy, Chromatic) in CI.
-   Example scripts to add to `package.json`:
    -   `"lint:css": "stylelint \"**/*.css\""`
    -   `"test:visual": "npx playwright test --project=chromium"`

## Tooling suggestions

-   Use PostCSS + Autoprefixer if you need to support older browsers; keep browserslist in the repo root.
-   Suggested Stylelint plugins: `stylelint-order`, `stylelint-a11y`, `stylelint-declaration-block-no-ignored-properties`.
-   If using a utility-first framework (Tailwind), keep configuration and purge/scan lists strict to avoid shipping unused styles.

## CSS-in-JS / component styling

-   If a package uses CSS-in-JS (styled-components, emotion, stitches) prefer co-located component styles and shared theme tokens. Avoid mixing global CSS and CSS-in-JS for the same component.
-   Keep dynamic styling performant: avoid heavy calculations in style props on every render.

## Readability & naming rules (align with global conventions)

-   Use British English in comments, documentation and token names (e.g. `--colour-background`).
-   Prefer full words and clear identifiers: avoid `err`, `el`, `cfg` in favour of `error`, `element`, `config` unless the abbreviation is conventional (`id`, `url`, `json`).

## Small examples

-   Focus-visible:
    -   `:focus-visible { outline: 3px solid var(--colour-focus); outline-offset: 2px; }`
-   Reduced motion:
    -   `@media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }`
-   Performance-friendly animation:
    -   `.fade-in { transform: translateY(0); opacity: 1; transition: transform 200ms ease, opacity 200ms ease; }`

## Files & organisation

-   Suggested file layout:
    -   `tokens/` — design tokens and global CSS variables
    -   `base/` — resets, typography, global elements
    -   `layout/` — grid and layout utilities
    -   `components/` — component styles, co-located where appropriate
    -   `utilities/` — helper classes (very small, well-documented)

## Append — CSS guidance: light-dark(), prefers-color-scheme, WCAG tokens, and reduced motion

This fragment is intended to be appended to this `css.instructions.md` (or merged in) to standardise how we handle light/dark colour switching, accessibility tokens and reduced-motion preferences.

### Use the light-dark() convenience function (preferred)

-   Author tokens using the `light-dark()` CSS colour function as the canonical value where a token should resolve to distinct light and dark colours. Treat `light-dark()` as the primary authoring approach: tokens in `tokens.css` should use `light-dark()` so supporting user agents pick the correct value automatically.

Example (authoring a brand token):

```css
:root {
    /* Primary token value uses light-dark() so supported UAs pick the right colour */
    --colour-brand: light-dark(#0064e6, #88b7ff);
    /* Optional: for very old UAs you may provide a simple fallback token if needed */
    --colour-brand-fallback: #0064e6; /* usually the light value */
}
```

Notes:

-   Prefer `light-dark()` as the canonical token value in your tokens file. Do not avoid it solely because older UAs lack support — that support is increasing and authoring with `light-dark()` keeps your token API simple.
-   If you must support very old browsers, provide a single minimal fallback (for example a `--*-fallback` token) or use a small `@media (prefers-color-scheme: dark)` override only where necessary as progressive enhancement.
-   Verify the exact `light-dark()` syntax and current support on MDN; consider adding a quick test/visual check in your CI to detect regressions.

### Use prefers-color-scheme to scope tokens

-   Use `@media (prefers-color-scheme: dark)` to switch token values for dark mode. Keep tokens semantic (surface, text, border, accent) rather than ad-hoc colour names.

Example — semantic tokens:

```css
:root {
    --bg-surface: #ffffff;
    --text-primary: #111111;
    --text-muted: #6b6b6b;
    --accent: #0064e6;
}

@media (prefers-color-scheme: dark) {
    :root {
        --bg-surface: #0f1113;
        --text-primary: #eceff1;
        --text-muted: #9aa0a6;
        --accent: #88b7ff;
    }
}
```

-   Keep token names stable across themes; only the values change.
-   Prefer using tokens in your components (for example: `background: var(--bg-surface); color: var(--text-primary);`).

### WCAG design tokens and contrast guidance

-   Create tokens that map to WCAG intent, for example:

    -   `--colour-text-primary` (regular body text)
    -   `--colour-text-large` (large or bold text)
    -   `--colour-ui-muted` (secondary UI text)
    -   `--colour-surface` (page and card backgrounds)
    -   `--colour-border`
    -   `--colour-accent`

-   Design goals and checks:
    -   Aim for contrast ratios conforming to WCAG AA at minimum: 4.5:1 for normal text, 3:1 for large text (or bold large text). Use automated tools to verify.
    -   When choosing token pairs (text on surface), calculate contrast in both light and dark schemes.

Small example token set annotated with purpose:

```css
:root {
    /* text / content */
    --colour-text-primary: #111111; /* body text, target 4.5:1 vs --colour-surface */
    --colour-text-large: #0b0b0b; /* large text — target 3:1 */

    /* surfaces */
    --colour-surface: #ffffff;
    --colour-muted-surface: #f6f7f9;

    /* UI */
    --colour-border: #e6e9ee;
    --colour-accent: #0064e6;
}

@media (prefers-color-scheme: dark) {
    :root {
        --colour-text-primary: #eaeef0;
        --colour-text-large: #ffffff;
        --colour-surface: #0b0c0d;
        --colour-muted-surface: #0f1113;
        --colour-border: #1c2023;
        --colour-accent: #88b7ff;
    }
}
```

### prefers-reduced-motion — snippet

-   Respect `prefers-reduced-motion` for users who need reduced animation. Prefer to remove non-essential motion and keep meaningful motion minimal.

```css
@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 1ms !important;
        transition-duration: 1ms !important;
        animation-iteration-count: 1 !important;
        scroll-behaviour: auto !important;
    }
}
```

Notes:

-   Test interactive components (modals, carousels) manually to ensure they behave correctly with reduced motion.
-   For motion that conveys information (e.g., progress), provide an alternative or ensure content remains understandable without the animation.

---

Quick checklist to include with the appended instructions:

-   [ ] Add semantic WCAG tokens to `:root` and provide dark-mode overrides with `prefers-color-scheme`.
-   [ ] Author tokens using `light-dark()` as the default canonical value; provide minimal fallbacks for legacy UAs only when required.
-   [ ] Verify colour contrast ratios for each token pair in both schemes (automated and manual checks).
-   [ ] Add `prefers-reduced-motion` media query to the base stylesheet and test key components.

References:

-   MDN: search for "light-dark()" and "prefers-color-scheme" for the detailed explainer and browser support.
-   WCAG guidelines for contrast ratios (AA / AAA).
