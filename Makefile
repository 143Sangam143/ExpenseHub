.PHONY: setup certs \
        docker-develop docker-develop-rebuild \
        docker-production docker-production-rebuild \
        down logs ps \
        migrate migrate-fresh \
        artisan composer npm \
        shell-backend shell-web \
        mail mail-down

COMPOSE_DEV  = docker compose
COMPOSE_PROD = docker compose -f docker-compose.yml -f docker-compose.prod.yml


# ==================================================
# First-time setup
# ==================================================

setup: certs
	@if [ ! -f backend/.env ]; then \
		echo "==> Creating backend/.env from backend/.env.example"; \
		cp backend/.env.example backend/.env; \
	fi
	@if [ ! -f web/.env.local ]; then \
		echo "==> web/.env.local not found"; \
		echo "==> Please create it before continuing."; \
		exit 1; \
	fi
	@echo "==> Building and starting ExpenseHub..."
	$(COMPOSE_DEV) up -d --build
	@echo ""
	@echo "========================================"
	@echo " ExpenseHub is ready"
	@echo "========================================"
	@echo " Backend:  Docker container"
	@echo " Frontend: http://localhost:3000"
	@echo " HTTP:     http://localhost:8000"
	@echo " HTTPS:    https://localhost:8443"
	@echo "========================================"


# ==================================================
# Certificates
# ==================================================

certs:
	./.docker/certs/generate-certs.sh $(LAN_IP)


# ==================================================
# Development
# ==================================================

docker-develop:
	$(COMPOSE_DEV) up -d --build

docker-develop-rebuild:
	$(COMPOSE_DEV) down -v --remove-orphans
	$(COMPOSE_DEV) build --no-cache
	$(COMPOSE_DEV) up -d


# ==================================================
# Production
# ==================================================

docker-production:
	$(COMPOSE_PROD) up -d --build

docker-production-rebuild:
	$(COMPOSE_PROD) down -v --remove-orphans
	$(COMPOSE_PROD) build --no-cache
	$(COMPOSE_PROD) up -d


# ==================================================
# Common utilities
# ==================================================

down:
	$(COMPOSE_DEV) down

ps:
	$(COMPOSE_DEV) ps

logs:
	$(COMPOSE_DEV) logs -f


# ==================================================
# Laravel
# ==================================================

migrate:
	$(COMPOSE_DEV) exec backend php artisan migrate

migrate-fresh:
	$(COMPOSE_DEV) exec backend php artisan migrate:fresh

artisan:
	$(COMPOSE_DEV) exec backend php artisan $(filter-out $@,$(MAKECMDGOALS))


# ==================================================
# Composer
#
# These commands are optional utilities.
# Composer always runs INSIDE Docker.
#
# Example:
#   make composer install
#   make composer update
#   make composer require laravel/sanctum
# ==================================================

composer:
	$(COMPOSE_DEV) exec backend composer $(filter-out $@,$(MAKECMDGOALS))


# ==================================================
# NPM
#
# These commands are optional utilities.
# npm always runs INSIDE Docker.
#
# Example:
#   make npm install
#   make npm run build
# ==================================================

npm:
	$(COMPOSE_DEV) exec web npm $(filter-out $@,$(MAKECMDGOALS))


# ==================================================
# Shells
# ==================================================

shell-backend:
	$(COMPOSE_DEV) exec backend sh

shell-web:
	$(COMPOSE_DEV) exec web sh


# ==================================================
# Mail
# ==================================================

mail:
	docker compose \
		-f docker-compose.yml \
		-f docker-compose.mail.yml \
		up -d

mail-down:
	docker compose \
		-f docker-compose.yml \
		-f docker-compose.mail.yml \
		down


# ==================================================
# Ignore unknown make targets
# ==================================================

%:
	@: