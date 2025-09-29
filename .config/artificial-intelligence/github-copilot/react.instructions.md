---
description: React (TSX/JSX)
applyTo: "**/*.tsx,**/*.jsx"
---
# React
- Function components + hooks only; no legacy class components.
- Co-locate components with tests and styles.
- Use server-safe code in Next.js server files; avoid `use client` unless needed.
- Favor controlled components; derive state, avoid duplication.
- Use React Query/TanStack Query for async server state; keep fetches out of components.
- Accessibility: label controls, keyboard support, semantic HTML, `aria-*` only when needed.
- Use Modern CSS for styling; extract shared patterns into components/util classes.

## Testing & accessibility

- Default test runner for React components: Vitest + Testing Library (see `testing.instructions.md`). Use Playwright for e2e where needed.
- Prefer testing the public contract (props, DOM roles, text) and behaviour over implementation details.

Recommended Testing Library patterns
- Query by role, label, or visible text first: `getByRole`, `getByLabelText`, `getByText`.
- Use `findBy*` for async assertions and `waitFor` only when necessary.
- Avoid relying on `data-testid` unless there is no accessible alternative.
- Use `user-event` to simulate user interactions rather than firing events directly.

Mocking & network
- Use `msw` to mock network requests for components that fetch; tests must not hit real HTTP endpoints.

Accessibility checks
- Include at least one automated accessibility check per component or critical page where feasible (e.g., `axe-core` or `vitest-axe`).
- Prefer semantic HTML and ensure controls have associated labels.

Test file conventions
- Co-locate tests: `Button.tsx` → `Button.test.tsx` in same folder.
- Keep tests small and focused: one behaviour per test.
- Always include one happy-path test and one edge-case (null/undefined props, disabled states, error UI).

Example test skeleton (Vitest + Testing Library)

```tsx
// ...existing code...
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import Button from './Button'

test('calls onClick when activated', async () => {
	const user = userEvent.setup()
	const handle = vi.fn()
	render(<Button onClick={handle}>Click me</Button>)
	const btn = screen.getByRole('button', { name: /click me/i })
	await user.click(btn)
	expect(handle).toHaveBeenCalledTimes(1)
})
```

Example package.json scripts (component package)

```json
{
	"scripts": {
		"test": "vitest",
		"test:ci": "vitest --run --coverage"
	}
}
```
