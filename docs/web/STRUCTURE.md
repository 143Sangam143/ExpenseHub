web/
├── public/
│   ├── images/
│   └── fonts/
│
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── globals.css
│   │   │
│   │   ├── (auth)/                          # route group: unauthenticated
│   │   │   ├── layout.tsx
│   │   │   └── login/
│   │   │       └── page.tsx
│   │   │
│   │   ├── admin/                           # THE app for now
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx                     # dashboard
│   │   │   ├── loading.tsx
│   │   │   ├── error.tsx
│   │   │   ├── _components/
│   │   │   │   ├── AdminSidebar.tsx
│   │   │   │   ├── AdminHeader.tsx
│   │   │   │   ├── DashboardView.tsx
│   │   │   │   ├── DashboardStats.tsx
│   │   │   │   └── DashboardStatsSkeleton.tsx
│   │   │   │
│   │   │   ├── roles/
│   │   │   │   ├── page.tsx
│   │   │   │   ├── loading.tsx
│   │   │   │   ├── error.tsx
│   │   │   │   ├── not-found.tsx
│   │   │   │   ├── _components/
│   │   │   │   │   ├── RoleIndexView.tsx
│   │   │   │   │   ├── RoleList.tsx
│   │   │   │   │   └── RoleListSkeleton.tsx
│   │   │   │   ├── create/
│   │   │   │   │   ├── page.tsx
│   │   │   │   │   └── _components/
│   │   │   │   │       └── RoleCreateForm.tsx
│   │   │   │   └── [uuid]/
│   │   │   │       ├── page.tsx
│   │   │   │       ├── loading.tsx
│   │   │   │       ├── not-found.tsx
│   │   │   │       └── _components/
│   │   │   │           └── RoleEditForm.tsx
│   │   │   │
│   │   │   └── users/
│   │   │       ├── page.tsx
│   │   │       ├── loading.tsx
│   │   │       ├── _components/
│   │   │       │   ├── UserIndexView.tsx
│   │   │       │   ├── UserList.tsx
│   │   │       │   └── UserListSkeleton.tsx
│   │   │       └── [uuid]/
│   │   │           ├── page.tsx
│   │   │           └── _components/
│   │   │               └── UserEditForm.tsx
│   │   │
│   │   └── (frontend)/                      # PLANNED — CMS public site, do not build yet
│   │       └── [...slug]/
│   │           └── page.tsx                 # will render via component_registry when that phase starts
│   │
│   ├── components/
│   │   ├── ui/                              # shadcn-style primitives — kebab-case
│   │   │   ├── button.tsx
│   │   │   └── input.tsx
│   │   ├── admin/
│   │   │   └── common/                      # reused by 2+ admin routes only
│   │   │       ├── DataTable.tsx
│   │   │       ├── ConfirmDialog.tsx
│   │   │       ├── Stats.tsx
│   │   │       └── StatsSkeleton.tsx
│   │   ├── providers/                       # real context providers, mounted once near root
│   │   │   ├── ThemeProvider.tsx
│   │   │   └── ToastProvider.tsx
│   │   ├── islands/                         # leaf-level client wrappers, no context supplied
│   │   │   ├── ScrollReveal.tsx
│   │   │   └── FadeIn.tsx
│   │   └── frontend/                        # PLANNED — component_registry-driven, empty until CMS phase
│   │
│   ├── lib/
│   │   ├── api/
│   │   │   ├── client.ts                    # fetch() wrapper, attaches bearer token, base URL
│   │   │   ├── handleApiError.ts            # maps ApiError -> notFound() / rethrow to error.tsx
│   │   │   ├── roles.ts                     # getRoles(), getRole(), createRole(), updateRole()
│   │   │   ├── users.ts
│   │   │   └── auth.ts
│   │   ├── errors/                          # plain TS, zero Next.js dependency — movable to shared/ later as-is
│   │   │   ├── ApiError.ts
│   │   │   ├── NotFoundError.ts
│   │   │   ├── ForbiddenError.ts
│   │   │   ├── UnauthorizedError.ts
│   │   │   ├── ValidationError.ts
│   │   │   ├── ServerError.ts
│   │   │   ├── TooManyRequestsError.ts
│   │   │   ├── classifyApiError.ts
│   │   │   └── index.ts
│   │   └── utils.ts
│   │
│   ├── types/                               # cross-page shapes: Role, User, AuthUser, ApiResponse<T>
│   │   ├── role.ts
│   │   ├── user.ts
│   │   └── api.ts
│   │
│   ├── stores/                              # client-only global state (NOT a data cache)
│   │   └── auth-store.ts                    # in-memory token / current user for client components
│   │
│   ├── constants/
│   │   └── routes.ts
│   │
│   ├── config/
│   │   └── site.ts
│   │
│   ├── styles/
│   │   └── admin.css
│   │
│   └── proxy.ts                             # Next.js 16 — auto-detected here since app/ also lives in src/
│
├── .env.local
├── .env.example
├── next.config.ts
├── tsconfig.json
├── package.json
└── structure.txt