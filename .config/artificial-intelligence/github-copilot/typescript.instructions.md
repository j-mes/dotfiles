---
description: Global TypeScript rules for modern JS stack
applyTo: "**/*.ts,**/*.tsx"
---
# TypeScript
- Target modern ESM; prefer `import`/`export` and async/await.
- Strict types (`noImplicitAny`, `strictNullChecks`); add explicit return/param types.
- Use `tsup` or Vite for builds where appropriate; no tsc emits in app repos.
- Use `zod` for runtime validation at boundaries; infer TS types from schemas.
- Prefer `const` and immutability; narrow types with type guards.
- Organize imports (group std/lib, external, internal; then alphabetize).
- Add JSDoc on public functions; keep modules ≤ 300 LOC with cohesive exports.
