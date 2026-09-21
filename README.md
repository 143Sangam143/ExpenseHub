# ExpenseHub

A personal expense and finance management application — a Laravel API backend, a Next.js web frontend, and PostgreSQL, all running through Docker.

For project goals, architecture, and development principles, see [`docs/INTRODUCTION.md`](docs/INTRODUCTION.md).

## Prerequisites

- Docker & Docker Compose
- Make

## Setup

### 1. Clone and enter the repo
```bash
git clone https://github.com/143Sangam143/ExpenseHub.git
cd ExpenseHub
```

### 2. Copy environment files
```bash
cp .env.example .env
cp backend/.env.example backend/.env
cp web/.env.example web/.env.local
```

### 3. Generate local HTTPS certificates
One-time, or whenever your LAN IP changes:
```bash
# One-time: already applied and committed to the repo — re-run only if you recreate this script locally
chmod +x .docker/certs/generate-certs.sh  ## it is kept only for note

make certs # to make the ssl certificates

## Use below if you want to make it so that the ssl certificate works for whole netowrk i.e laptop, mobile.
make certs LAN_IP=192.168.1.23   # your machine's LAN IP,
```

*(Optional)* Import `.docker/certs/generated/ca.crt` into your OS/browser trust store to remove the browser's self-signed-certificate warning. This step is optional; if skipped, your browser will show a self-signed-certificate warning that you can safely dismiss.

### 4. Build and start everything
```bash
make docker-develop
```
This builds all images and starts Postgres, the backend, nginx, and the web frontend. Database migrations run **automatically** on backend startup — no separate migrate step needed for a first-time setup.

> `composer install` and `npm install` both happen automatically inside the Docker build — nothing needs to be installed on your host machine.

### 5. Generate the application key (first time only)
```bash
make artisan key:generate
```

### 6. Confirm everything is running
```bash
make ps
```
All four containers should show as running/healthy.

### 7. Open the app

| Service | URL |
|---|---|
| Frontend | http://localhost:3000 |
| Backend API | https://localhost:8443/api |
| Backend health check | https://localhost:8443/up |

## Everyday commands

| Command | What it does |
|---|---|
| `make docker-develop` | Build + start the dev stack |
| `make docker-develop-rebuild` | Wipe everything (including DB data) and rebuild from scratch |
| `make down` | Stop all containers |
| `make ps` | Check container status |
| `make logs` | Tail logs from all containers |
| `make migrate` | Run new migrations manually (only needed if the backend was already running when the migration was added) |
| `make migrate-fresh` | Drop all tables and re-migrate |
| `make artisan <cmd>` | Run any `php artisan` command, e.g. `make artisan make:model Expense` |
| `make composer <cmd>` | Run any Composer command inside the backend container |
| `make npm <cmd>` | Run any npm command inside the web container |
| `make shell-backend` | Open a shell inside the backend container |
| `make shell-web` | Open a shell inside the web container |

## Running the production-mode build locally

```bash
make docker-production
```
The same stack, built from the optimized production Dockerfile targets. Use this to validate the production build locally before deploying to a real server.

## Email testing (Mailhog)

Not enabled by default. When testing anything that sends email:
```bash
make mail            # alongside the dev stack
make mail-prod       # alongside the production-mode local rehearsal
```
View caught emails at http://localhost:8025 — nothing is ever sent to a real inbox locally.

## Documentation

Further documentation lives in [`docs/`](docs/):

- [`docs/INTRODUCTION.md`](docs/INTRODUCTION.md) — project goals, architecture, and development principles