---
description: Global JavaScript (ES2022+) rules
applyTo: "**/*.js,**/*.mjs,**/*.cjs"
---
# JavaScript
- Default to ESM (`"type":"module"`); use `import` even in Node when possible.
- Avoid CommonJS unless interoperability is required.
- Prefer functional patterns; avoid classes in React code.
- Never commit floating promises; handle with `await` or `.catch`.
- Include minimal comments explaining *why*, not *what*.
- Don't use `.cjs` or `.mjs` extensions. Use `.js` for everything.
