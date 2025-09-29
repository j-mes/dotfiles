---
description: Global HTML rules
applyTo: "**/*.html"
---
# HTML
- Use semantic elements (`header`, `main`, `section`, `article`, `footer`) instead of generic `div`s.
- Always declare `<html lang="en-GB">` (or appropriate language) as I'm a Brit.
- Include `<meta charset="utf-8">` and `<meta name="viewport" content="width=device-width, initial-scale=1">`.
- Provide a `<title>` and descriptive `<meta name="description">`.
- Associate every form control with a `<label>`; use `for`/`id` or wrapping.
- Use `<button>` for actions, not `<div>`/`<span>`.
- Place scripts with `type="module"` and `defer` to avoid blocking render.
- Keep markup minimal; avoid redundant `div`/`span` wrappers.
- Follow accessibility best practices (landmarks, headings in order, ARIA only when necessary).
- Tooling & validation
    - Consider using `html-validate` or similar HTML linters to catch common mistakes and enforce rules (lang attribute, meta tags, required title). Add a CI step to run HTML validation for critical pages or templates.

    Example script in `package.json`:

        ```json
        {
            "scripts": {
                "lint:html": "html-validate . --ignore node_modules"
            }
        }
        ```
