# ExpenseHub

ExpenseHub is a personal expense and finance management application designed to provide a structured way to record, organize, and analyze financial activity.

The project is being built as a full-stack application with a Laravel API backend and a Next.js web frontend, with PostgreSQL as the primary database.

## Project Status

The project is currently in its initial setup phase.

The repository is being developed incrementally, with infrastructure, backend, frontend, and application features kept as separate concerns.

## Architecture

```text
ExpenseHub
│
├── backend/    Laravel API
├── web/        Next.js web application
├── docker/     Development and deployment containers
└── docs/       Project documentation
```

### Backend

The backend provides the application's API and business logic.

* Laravel
* PHP
* PostgreSQL
* RESTful API
* DTO-based request handling
* Service layer
* Repository abstraction where appropriate
* API Resources for response transformation

### Web

The web application provides the user-facing interface.

* Next.js
* React
* TypeScript
* Tailwind CSS
* API-driven architecture

### Infrastructure

The project is developed and run through Docker.

Docker Compose will provide the development environment, including application services and PostgreSQL, so the required runtime dependencies do not need to be installed directly on the host system.

```text
Browser
   │
   ▼
Next.js
   │
   ▼
Laravel API
   │
   ▼
PostgreSQL
```

## Development Principles

The project follows a few core principles:

* Keep responsibilities separated between frontend, backend, and infrastructure.
* Keep business logic out of controllers.
* Use DTOs to define application input data.
* Use API Resources to define API output representations.
* Keep API responses consistent.
* Avoid unnecessary abstractions and folders until they solve a real problem.
* Prefer clear, maintainable code over unnecessary complexity.
* Develop and run the project through Docker Compose.

## Repository Structure

More detailed architectural decisions and responsibilities are documented within the `docs/` directory and the respective `structure.txt` files.

```text
backend/
    Laravel API and application logic

web/
    Next.js web application

docker/
    Docker and Docker Compose configuration

docs/
    Project and architectural documentation
```

## Development

The project is intended to be run through Docker Compose.

Once the development environment is configured:

```bash
docker compose up -d
```

The exact services, commands, environment variables, and development workflow will be documented as the project setup progresses.

## Project Goals

ExpenseHub aims to provide a maintainable foundation for managing:

* Expenses
* Income
* Categories
* Accounts
* Financial summaries
* Financial activity and history

Additional functionality will be introduced incrementally as the application evolves.
