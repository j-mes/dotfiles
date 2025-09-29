---
description: Language-agnostic global rules
applyTo: "**/*"
---
# Global conventions
- Use British English for human-readable text in code, comments, documentation and messages (e.g. `organisation`, `colour`, `optimise`).
- Write clear, maintainable code; prefer readability over cleverness.
- Include minimal comments explaining *why* something is done, not *what*.
- All files should use UTF-8, LF line endings, and tab indentation (unless project dictates otherwise or doing things that needs space indentation).
- Use consistent naming: `camelCase` for variables/functions, `PascalCase` for types/classes, `kebab-case` for files.
- Avoid duplicate logic — extract reusable functions or modules.
- Write tests for new features; ensure all test suites pass before commit.
- Prefer small, focused commits with descriptive messages (Conventional Commits style).
- Document public APIs (functions, classes, modules) with clear descriptions and examples where appropriate.
- Security: never hardcode secrets; load from environment variables or config files.
- Keep dependencies minimal; prefer standard library or existing project libraries before adding new ones.
- Prioritise readability over terseness or clever/ambiguous naming. Prefer explicit names and full words that improve comprehension for future readers.
- Naming clarity rule: avoid single-letter variable names (e.g. `x`, `y`, `d`) except for very short-lived loop indices or mathematical code where the meaning is conventional. Prefer descriptive names like `count`, `index`, `duration`, `userId`.
- Avoid halved or abbreviated words when the full word is equally simple and more readable. Examples to forbid: `err` (prefer `error`), `el` (prefer `element`), `cfg` (prefer `config`), `qty` (prefer `quantity`). Short, well-known abbreviations (e.g. `id`, `url`, `json`) are acceptable.
