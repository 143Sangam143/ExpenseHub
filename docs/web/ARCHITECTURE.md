# Frontend Architecture

Scope right now: `backend/` + `web/` only. No `shared/`, no `mobile/`. The CMS
public frontend (Page Builder + `component_registry`) is a real future phase
but nothing for it gets created until you start it — it's documented here so
the convention isn't lost, not because there's a folder for it today.

Create folders only as you build that piece, following `structure.txt`.

---

## Naming convention

Pattern: **`[Entity][Purpose][Type]`**

| Suffix | Used for | Example |
|---|---|---|
| `View` | Composes multiple sections for a route. Skip it for a single-form page (e.g. plain Create) — render the form directly. Decide per page. | `RoleIndexView`, `DashboardView` |
| `Form` | Create/edit forms | `RoleCreateForm`, `RoleEditForm` |
| `List` | Tables/lists | `RoleList`, `UserList` |
| `Skeleton` | Loading placeholder, colocated next to the real component | `RoleListSkeleton.tsx` |
| (descriptive) | Named sections | `DashboardStats` |

**Never call a page-composing component "Layout."** `layout.tsx` wraps
`page.tsx` (parent, not child) and structurally can't receive `page.tsx`'s
fetched data as a prop — a composing `View` does the opposite job.

Global/reusable components (2+ entities, identical design + data) drop the
entity prefix: `DataTable.tsx`, `ConfirmDialog.tsx`, `Stats.tsx`.

---

## `app/` — routes, server-first

Default pattern: **fetch once, in `page.tsx` (server component)**, pass data
down to a `View`/`List`/`Form`. Don't reach for a client-side data layer
(react-query, etc.) until you have a specific interactive case that needs it
(live search, client-side pagination) — not as an upfront default.

### `_components/`
Next's private-folder convention (`_` prefix opts out of routing). Anything
used by **exactly one route** goes here. The moment something is imported
into a second, unrelated route, promote it to `components/admin/common/` (or
`components/` top-level if it's truly generic, not admin-specific).

### `loading.tsx` / `error.tsx` / `not-found.tsx`
Route-segment conventions. They cascade to nested segments that don't define
their own. Add a segment's own version the moment it needs to do something
(a real fetch, a distinct error case) the parent's version doesn't cover —
not preemptively.

- `loading.tsx` is the default Suspense boundary — it composes the colocated
  `Skeleton` components to match the route's final layout.
- Only reach for a component-level `<Suspense>` (own `Skeleton` as fallback)
  when a section has an independent, unawaited promise for a *measured*
  reason (slow query, different cache lifetime) — never a guess made upfront.

### `layout.tsx` placement
Must sit directly in the segment folder it applies to — never nested inside
`_components/`. The components it *renders* (Sidebar, Header) can live in
that segment's `_components/`.

### Route paths
`[uuid]` directly — no `/edit` suffix.

---

## `components/` — shared across 2+ routes

- **`components/ui/`** — dumb primitives (Button, Input, Modal). No business
  logic. shadcn-style, kebab-case filenames.
- **`components/admin/common/`** — composed components reused across 2+
  admin routes with identical design + data shape (DataTable, ConfirmDialog,
  Stats). Don't promote from `_components/` early — wait until it's actually
  reused.
- **`components/providers/`** — real Context providers mounted once near the
  root (ThemeProvider, ToastProvider) — they supply something to descendants.
- **`components/islands/`** — small, reusable, leaf-level client wrappers
  used inline to attach client-only behavior to their own children
  (ScrollReveal, FadeIn). Not providers — no context, just behavior. This and
  `providers/` are the only places `'use client'` should originate from.
- **`components/frontend/`** — reserved for the future CMS phase
  (`component_registry`-driven section rendering). Leave empty for now.

---

## `lib/api/` — the calls to your backend

One file per backend domain, matching your Repository split
(`roles.ts`, `users.ts`, `auth.ts`) plus:

- **`client.ts`** — single wrapper around native `fetch`, attaches the
  bearer token and base URL, throws a typed error via `classifyApiError` on
  a non-2xx response. Same symmetry reasoning as Sanctum bearer tokens on
  the backend: one client, works the same when mobile shows up later. No
  axios — `fetch` is built into Next.js/Node, one less dependency to carry.
- **`handleApiError.ts`** — maps a backend error response into a typed
  `ApiError` (via `lib/errors/classifyApiError.ts`); for a `NotFoundError`
  calls Next's `notFound()`, otherwise re-throws for the nearest `error.tsx`.
  **Exception: `ValidationError` (422)** never reaches `error.tsx`. Forms
  call `classifyApiError` directly and catch it inline to show field-level
  messages.

`page.tsx` calls these functions directly (server-side) — no extra
hooks/service layer needed unless a specific client component needs its own
client-side fetch.

---

## `lib/errors/` — typed error classes

Plain TypeScript, zero Next.js imports on purpose — even though `shared/`
doesn't exist yet, writing these with no framework dependency means the
whole folder can move into `shared/` unchanged once mobile enters the
picture. `ApiError` base class + `NotFoundError`, `ForbiddenError`,
`UnauthorizedError`, `ValidationError`, `ServerError`,
`TooManyRequestsError`, and `classifyApiError.ts` (pure `statusCode → ApiError`
function).

---

## `types/` — shapes shared across pages

`Role`, `User`, `AuthUser`, `ApiResponse<T>`, `PaginatedResponse<T>` — things
used by more than one page (list page + edit page both need `Role`).
Domain-specific request shapes for forms live here too, or colocated inside
the `Form` component itself if only that one form uses them — promote to
here only once Create and Edit end up needing the exact same shape.

---

## `stores/` — client-only state, not a cache

Zustand (or similar) for state that's genuinely client-side and global:
current user/token in memory, sidebar collapsed state. This is **not** a
data-fetching/caching layer — that's `lib/api/` called from server
components. If you later add a case that genuinely needs client-side
fetching + caching (e.g. a live-search admin table), that's the trigger to
add react-query, not a default to install upfront.

---

## `constants/` and `config/`

- **`constants/`** — literal values used app-wide (route paths, mirrors of
  your backend's `UserRole`/`RoleScope` enums, pagination sizes).
- **`config/`** — environment-driven config (site name, API base URL).

---

## `proxy.ts`

Next.js 16's rename of `middleware.ts`. No config needed — Next.js just
looks for it at the same level as `app/`, so `src/proxy.ts` is picked up
automatically since this project uses `--src-dir`. Keep it thin: only check
token *presence* and redirect to `/login`. Actual token validity is checked
wherever the protected page fetches data (401 → `handleApiError` →
`UnauthorizedError`), not here.

---

## Images

Never mix a fixed `width`/`height` on `<Image>` with a CSS class that can
resize the box — pick `fill` + an aspect-ratio container + accurate `sizes`,
defined once per component role (Hero, Card, Avatar) when you get there.

---

## Deliberately deferred

- **`app/(frontend)/`, `components/frontend/sections/*`, `component_registry`,
  `admin/templates/`, `admin/pages/`** — the whole CMS Page Builder phase.
  You confirmed this is coming later, not now — don't scaffold any of it
  until that phase actually starts.
- **`shared/`** — only needed once `mobile/` exists. `lib/errors/` is written
  with no Next.js dependency specifically so that move is a folder relocate
  + import path update, not a rewrite.
- **Roles/permissions UI** (`usePermissions()`, `<Can>`) — after core CRUD is
  working.