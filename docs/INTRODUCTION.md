# Introduction

## What ExpenseHub is

ExpenseHub is a personal expense and finance management application, providing a structured way to record, organize, and analyze financial activity.

It's built as a full-stack application: a Laravel API backend, a Next.js web frontend, and PostgreSQL as the primary database.

## Project status

The project is currently in its initial setup phase. It's being developed incrementally, with infrastructure, backend, frontend, and application features kept as separate, clearly bounded concerns.

## Architecture

```text
ExpenseHub
│
├── backend/    Laravel API
├── web/        Next.js web application
├── .docker/    Development and deployment container configuration
└── docs/       Project documentation
```

Request flow:

```text
Browser
   │
   ▼
Next.js (web/)
   │
   ▼
Laravel API (backend/)
   │
   ▼
PostgreSQL
```

### Backend

- Laravel
- PHP
- PostgreSQL
- RESTful API
- DTO-based request handling
- Service layer
- Repository abstraction where appropriate
- API Resources for response transformation

### Web

- Next.js
- React
- TypeScript
- Tailwind CSS
- API-driven architecture

### Infrastructure

The project is developed and run entirely through Docker Compose — application services and PostgreSQL run in containers, so none of the runtime dependencies (PHP, Node, Postgres) need to be installed directly on the host machine.

See the [README](../README.md) for the actual setup steps.

## Development principles

- Keep responsibilities separated between frontend, backend, and infrastructure.
- Keep business logic out of controllers.
- Use DTOs to define application input data.
- Use API Resources to define API output representations.
- Keep API responses consistent.
- Avoid unnecessary abstractions and folders until they solve a real problem.
- Prefer clear, maintainable code over unnecessary complexity.
- Develop and run the project through Docker Compose.

## Project goals

ExpenseHub aims to provide a maintainable foundation for managing:

- Expenses
- Income
- Categories
- Accounts
- Financial summaries
- Financial activity and history

Additional functionality will be introduced incrementally as the application evolves.