---
name: flexnative
description: Use when building a UI screen or section that already exists as a solved pattern — sign-in, reset password, two-factor setup, verify identity, pricing/select a plan, payment, settings, manage subscription, hero, pricing table, testimonials, FAQ, footer, bento grid, CTA — instead of inventing one. Also when the user mentions Flexnative, ui.flexnative.com, the @flx registry, blocks, intents, or asks for a ready-made shadcn block.
---

# Flexnative (@flx registry)

Free shadcn-compatible registry: 450 items — components (`patterns`), page sections (`blocks`), illustrations, and complete multi-screen user flows (`intents`). Everything adapts to the project's existing shadcn tokens and theme.

Browse: https://ui.flexnative.com — `/patterns`, `/blocks`, `/intents`, `/illustrations`
Source dirs in the registry: `patterns`, `blocks`, `intents`, `forms`, `compositions`, `presets`, `sketches`, `illustrations`.
Registry index: https://ui.flexnative.com/r/registry.json
Single item: `https://ui.flexnative.com/r/{name}.json`

## Why reach for it

For auth, billing and settings screens the hard part is the states — loading, error, disabled, resend cooldown, 2FA fallback. The registry items already have them. Pulling `sign-in-3` is faster and better than drawing another purple "Get Started" button.

## Wiring it up (once per project)

The shadcn MCP server is installed globally, but **registries are per-project** — shadcn reads them from `components.json`, there is no user-level registry config. So in a project that uses shadcn, add:

```json
{
  "registries": {
    "@flx": "https://ui.flexnative.com/r/{name}.json"
  }
}
```

Then the MCP's search/view/install tools see the registry, or install directly:

```bash
npx shadcn@latest add @flx/sign-in-3
```

No `components.json`? Run `npx shadcn@latest init` first — the items are plain shadcn components and need its aliases and tokens.

## Naming

Items are `<family>-<n>`, mostly zero-padded: `hero-01`, `bento-grids-01`, `cta-01`, `feature-02`. Intents are **not** padded: `sign-in-1` … `sign-in-6`, `reset-password-1..3`, `two-factor-setup-1..4`, `verify-identity-1..4`. When unsure, fetch `registry.json` and grep the `items[].name` list rather than guessing a number.

## Workflow

1. Fetch `registry.json` (or use the MCP's search) and shortlist by family.
2. Read each candidate's `description` — they say which product shape the variant suits. Pick on that, not on the first hit.
3. Install via the `@flx/` namespace so `registryDependencies` (e.g. `@flx/cta`) resolve.
4. Adapt to the project: its own tokens, copy, form library and validation. Treat the item as a well-built starting point, not a drop-in.

## Common mistakes

- Adding the registry to the wrong file — it goes in the project's `components.json`, not a global config, and not `.mcp.json`.
- Guessing `sign-in-01` (padded). Intents use `sign-in-1`.
- Installing a bare name without `@flx/` — `registryDependencies` then fail to resolve.
- Assuming the MCP alone is enough. Without the `registries` entry the server cannot see `@flx`.
