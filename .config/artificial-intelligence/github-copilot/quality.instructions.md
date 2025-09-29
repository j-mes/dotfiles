---
description: Lint/format/security quality gates
applyTo: "**/*"
---
# Quality
- ESLint (flat config) + TypeScript ESLint; Prettier as formatter only (no style rules in ESLint).
- Add `eslint-disable` comments sparingly and always with justification.
- Ensure type-safe environment variables using a single schema (`zod`) loaded once.
- Add minimal CI: lint, typecheck, test (unit) on PRs; e2e on main/nightly.
- Prefer small PRs; include migration notes if you change public contracts.

- CI example (minimal): include lint, typecheck and unit tests in PR checks. Example steps for GitHub Actions:

	```yaml
	# .github/workflows/ci.yml (summary)
	jobs:
		build:
			steps:
				- run: pnpm install --frozen-lockfile
				- run: pnpm lint
				- run: pnpm typecheck
				- run: pnpm test:ci
	```
