---
name: morphicons
description: Use when an icon needs to change into another icon — hamburger to close, play to pause, chevron flipping, arrow to checkmark, copy to check — or when the user mentions morphicons / morphicons.com, an animated or morphing icon, or a conditional icon swap that currently just cross-fades or snaps.
---

# morphicons

Open-source library that morphs any stroke-based icon into any other with spring physics. Works with Lucide, Tabler, Heroicons, Iconoir and custom paths. Zero runtime dependencies, ESM only.

Playground (pick two icons, copy the code): https://www.morphicons.com
Repo: https://github.com/guillermolg00/morphicons

## When to use

- A conditional icon render: `{open ? <X/> : <Menu/>}`, `{playing ? <Pause/> : <Play/>}`, `{copied ? <Check/> : <Copy/>}`. These snap. Replace with `MorphIcon`.
- A chevron/arrow that flips direction on toggle or sort change.
- The user pastes a morphicons.com link — the site emits ready code; adapt it to the project's icon source.

**Not for filled icons.** The geometry must be a stroked centerline (`fill="none"`, color via `stroke`). Material Symbols, Bootstrap Icons, Remix Icon, Phosphor and Heroicons *solid* parse but read wrong in flight.

## Install

```bash
npm install morphicons
```

Peers are optional and per-binding: `react >=18`, `vue >=3.3`, `svelte >=5`, or `react-native >=0.71` + `react-native-svg >=14`. `morphicons/element` and `morphicons/astro` need no peer.

## The critical gotcha: data, not components

`MorphIcon` consumes icon **data**, so import from the vanilla `lucide` package — not `lucide-react`.

```tsx
import { MorphIcon } from "morphicons/react";
import { Menu, X } from "lucide";        // ✅ data (IconNode)
// import { Menu, X } from "lucide-react"; // ❌ components — will not work

<button onClick={() => setOpen(o => !o)} aria-expanded={open}>
  <MorphIcon icon={open ? X : Menu} spring="snappy" />
</button>
```

Both packages can coexist — keep `lucide-react` for static icons, just keep the versions aligned.

Props are a drop-in match for lucide-react: `size`, `strokeWidth`, `absoluteStrokeWidth`, `color`, `className`, plus every `<svg>` prop. `aria-hidden` by default; pass `label` to get `role="img"` + `<title>`. SSR emits the exact static SVG (no flash, no layout shift).

## Three modes (identical in React, Vue, Svelte, React Native, web component)

| Mode | Shape | Use for |
|---|---|---|
| Uncontrolled | `<MorphIcon icon={open ? X : Menu} />` | 90% of cases — change the prop, it animates |
| Controlled | `<MorphIcon from={Menu} to={X} progress={p} />` | gestures, scroll scrubbing; no spring |
| Imperative | `ref.current?.morphTo(Check)` / `.set(X)` | sequences; `set` jumps without animating |

While `from` **and** `to` are both present they own the path and `icon` is ignored.

## Other entry points

| Import | For |
|---|---|
| `morphicons/react`, `/vue`, `/svelte`, `/react-native` | framework bindings |
| `morphicons/element` | `<morph-icon>` custom element — plain HTML, HTMX, Rails |
| `morphicons/astro` | Astro SSR shell, zero framework runtime |
| `morphicons/dom` | `createMorph(pathEl, icon)` — vanilla; `.morphTo/.set/.seek/.progress/.destroy` |
| `morphicons/adapters` | `svgToIcon` (SVG markup in), `maskTarget` (CSS-mask icons, UnoCSS/`i-lucide-*`), `canvasTarget` (2D canvas / OffscreenCanvas / WebGL texture) |
| `morphicons` | pure core: `resampleIcon`, `buildPlan`, `interpPolar`, `fitIcon` |

## Common mistakes

- **Importing from `lucide-react`.** The single most likely failure. Use `lucide`.
- **Icons on different grids.** Both endpoints must share a coordinate space. Lucide, Tabler, Heroicons outline and Iconoir are all 24×24 and cross-morph freely. Off-grid packs (Carbon 32, Teenyicons 15, Heroicons solid 20) need `fitIcon(icon, 32)` once, **at module scope**.
- **Calling `svgToIcon` / `fitIcon` inside render.** Parse once at module scope so the plan cache holds the reference.
- **Expecting reduced-motion to auto-degrade.** Since 1.4.2 morphs play by default (`reducedMotion="never"`). Pass `reducedMotion="user"` to honour the OS setting, `"always"` for tests and screenshots.
- **Handing a host's own canvas context to `canvasTarget`.** The driver runs its own rAF and fights the host loop. Use a dedicated small canvas and composite it with `onWrite` as the dirty signal.
