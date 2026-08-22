# Design system (frontend)

Public UI under `src/app/(frontend)/` uses the monorepo package **`@dappermountain/ui`**. App code should treat that package as the shared design system.

Implementation lives in **`packages/ui/`** at the repo root: Tailwind v4 tokens, shadcn/ui primitives, and shared icon exports.

## Imports

```tsx
import { Button } from '@dappermountain/ui/components/button'
import { Card, CardHeader, CardTitle } from '@dappermountain/ui/components/card'
import { Separator } from '@dappermountain/ui/components/separator'
import { Building2 } from '@dappermountain/ui/icons'
import { cn } from '@dappermountain/ui/lib/utils'
```

**Do not** import `tamagui` or `@tamagui/core` in this app — ESLint enforces `no-restricted-imports`.

## Next.js wiring

- `next.config.ts` composes **`withPayload`** and transpiles **`@dappermountain/ui`**
- `(frontend)/layout.tsx` imports **`@dappermountain/ui/globals.css`** once
- App-local `globals.css` remains for local resets only

There is no Tamagui build step or generated CSS file anymore.

## Tailwind v4

`packages/ui/src/styles/globals.css` imports:

- `tailwindcss`
- `tw-animate-css`
- shared `tokens.css`

That stylesheet also declares `@source` paths for the shared UI package and this app so utility classes used in either place are included.

## Adding UI

1. Prefer existing exports from `@dappermountain/ui`.
2. Need a new primitive? Add it once in `packages/ui/src/components/`.
3. Need shared tokens or utilities? Add them in `packages/ui/src/styles/` or `packages/ui/src/lib/`.
4. Keep app-specific composition in `src/app/(frontend)/_components/`, but still import base primitives from `@dappermountain/ui`.

## App Router layout (`src/app/(frontend)/`)

```text
(frontend)/
├── layout.tsx              # Server — html/body, i18n, fonts, providers
├── page.tsx                # Server — data for the home route
├── globals.css
├── actions/
│   └── switch-language.ts  # Server Action (payload-lng cookie)
└── _components/            # Colocated UI (not routed)
    ├── providers.tsx       # FrontendProviders (client)
    ├── home-page.tsx       # HomePage (client)
    └── language-switcher.tsx
```

## Related docs

- [CODE_CONVENTIONS.md](./CODE_CONVENTIONS.md)
- [App README](../README.md)
- [Root README](../../../README.md)
