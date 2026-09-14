# Backend Architecture Guide

Reflects the decisions already locked in: input DTOs only (no ResponseDTO —
Resources own output transformation), Repository → Service → Controller
layering, Sanctum bearer tokens, and a flattened API namespace (no nested
`v1/` folders — versioning is deferred, not designed around yet).

---

## `app/Core/`

Cross-cutting building blocks with no business logic of their own —
everything else in `app/` depends on these, they depend on nothing else.

- **`Contracts/`** — interfaces like `BaseRepositoryInterface`,
  `RoleRepositoryInterface`. Services type-hint against these, not concrete
  Repositories, so the binding lives in one place (`Providers/`) and
  Repositories stay swappable/mockable in tests.
- **`Enums/`** — `ResponseStatus`, `RoleScope`, `UserRole`. Native PHP
  backed enums, shared by Models, Requests, and Resources alike so a status
  string never gets typed by hand twice.
- **`Exceptions/`** — `ApiException` base + `InvalidCredentialsException`,
  `AccountInactiveException`. Centralizes the mapping from a domain failure
  to an HTTP status + JSON error shape, so Controllers never build error
  responses by hand.
- **`Traits/`** — `HasUuid`, `ApiResponse`, `Searchable`. Horizontal
  behavior mixed into Models/Controllers where needed, not tied to any one
  domain.

---

## `app/DTO/`

**Input only.** One folder per domain (`Auth/`, `Roles/`, ...), mirroring
`Http/Requests/` and `Http/Resources/`. The sole conduit for validated data
moving forward through the app:

```
Request::validated() → Request::toDTO() → Service
```

There is deliberately no `ResponseDTO` layer — a DTO that just gets handed
to a Resource to re-shape adds a layer that owns nothing. Resources do that
job directly (see below), which is also what makes `whenLoaded()` work
cleanly for relationship composition.

---

## `app/Http/Controllers/Api/`

Controllers stay thin everywhere: validate via a `Request`, call a
`Service`, return a `Resource`. No query building, no business rules here.

- **`Admin/`** — everything behind the admin-authenticated area (Role, User
  management). This is what your Next.js `admin/` app talks to.
- **`Auth/`** — login/register/logout/token issuance. Split out from
  `Admin/` because auth endpoints aren't gated the same way, and every
  future client (web admin, the eventual public frontend, mobile) hits the
  same auth surface.
- **`Public/`** — reserved, empty for now. Will serve the future CMS public
  frontend (page/template rendering) once that phase starts, mirroring the
  deferred `(frontend)/` route group on the Next.js side. Same reasoning:
  the seam exists so nothing has to be restructured later, but nothing gets
  built here until that phase actually starts.

---

## `app/Http/Middleware/`

Custom middleware — e.g. an ability/permission gate layered on top of
Sanctum's token auth. Framework-level concerns only; anything about *who
can do what* that's actually business logic belongs in a Service, not here.

---

## `app/Http/Requests/{Domain}/`

FormRequests extend `BaseRequest` (consistent 422 JSON error envelope) and
each implements `toDTO()`. Organized per domain so `Requests/Roles/`,
`DTO/Roles/`, and `Resources/Roles/` line up one-to-one — anyone can find
the three files describing "Role" input/data/output by name alone.

---

## `app/Http/Resources/{Domain}/` + `BaseCollection.php`

Owns **all** output transformation directly — this is where the eliminated
`ResponseDTO` logic actually lives now. Using `whenLoaded()` here is what
lets a Resource compose nested relationships cleanly without the Controller
or a DTO having to know what was eager-loaded.

- **`BaseCollection.php`** — shared `with()` override so every collection
  response gets the same `meta`/`links` envelope without repeating it per
  domain.

---

## `app/Models/`

Eloquent models. Use `HasUuid` where the domain needs UUID primary keys
(consistent with the auth/token symmetry decision — UUIDs travel safely
across web and future mobile clients the same way bearer tokens do).

---

## `app/Repositories/`

The only layer that touches Eloquent query building. `BaseRepository`
implements `BaseRepositoryInterface` (from `Core/Contracts/`); each domain
repo (`RoleRepository`, `AuthRepository`, `UserRepository`) extends it.
Services depend on the interface, never the concrete class directly.

---

## `app/Services/`

Business logic lives here, and only here. `BaseService` provides the
transaction helper (wrap a multi-step write in `DB::transaction()` once,
reuse it everywhere). Each domain Service (`RoleService`, `AuthService`)
injects its Repository via the interface and is the *only* thing a
Controller is allowed to call.

---

## `app/Providers/`

Binds `Contracts/` interfaces to their concrete `Repositories/`
implementations (and any other service-container wiring). This is the one
place that knows which concrete class backs which interface — everywhere
else in the app only ever sees the interface.

---

## `routes/api/`

- **`admin/`** — one route file per domain (`roles.php`, `users.php`),
  grouped under `auth:sanctum` + an admin-ability check. A folder rather
  than a single file because this is where route count will grow fastest.
- **`auth.php`** — login/register/logout, mixing public and
  token-protected routes in one file since the auth surface is small and
  stable.
- **`public.php`** — reserved, deferred. Will hold the CMS content-delivery
  endpoints once the `Public/` controllers and the Next.js `(frontend)/`
  phase both start.

No `v1/` nesting anywhere — the flattening decision means when real
versioning is needed later, it'll be solved with a prefix or header at that
point, not by restructuring this tree preemptively.

---

## `database/`

Standard Laravel split — `factories/`, `migrations/`, `seeders/`. Nothing
domain-specific here beyond normal Laravel convention.

---

## `docs/`

Architecture rationale — including this file — lives next to the code it
describes instead of in tribal knowledge or a wiki that drifts out of sync.
Add a new doc here whenever a decision is made that isn't obvious from
reading the code alone (e.g. why `ResponseDTO` was removed, why bearer
tokens over SPA cookies).

---

## `tests/`

- **`Feature/`** — hits real endpoints end-to-end: route → controller →
  service → repository → database. This is where you verify a domain slice
  actually works together.
- **`Unit/`** — targets a single Service, Repository, or DTO in isolation,
  with dependencies mocked via the `Contracts/` interfaces.

---

## Open / deferred (matches the frontend's deferred list)

- **`Controllers/Api/Public/`, `routes/api/public.php`** — empty until the
  CMS public-frontend phase starts (mirrors `(frontend)/` on the Next.js
  side).
- **API versioning** — intentionally flattened for now; revisit only when
  there's a real breaking change to ship alongside an old version.
- **Docker, mobile-specific concerns** — not designed around yet, same as
  on the frontend.