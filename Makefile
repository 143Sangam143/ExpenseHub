.PHONY: docker-develop docker-develop-rebuild docker-production docker-production-rebuild \
        down logs ps migrate migrate-fresh certs artisan composer npm shell-backend shell-web

COMPOSE_DEV  = docker compose
COMPOSE_PROD = docker compose -f docker-compose.yml -f docker-compose.prod.yml

## ---- Certificates ----

certs:
	./.docker/certs/generate-certs.sh $(LAN_IP)

## ---- Development ----

docker-develop:
	$(COMPOSE_DEV) up -d --build

docker-develop-rebuild:
	$(COMPOSE_DEV) down -v --remove-orphans
	$(COMPOSE_DEV) build --no-cache
	$(COMPOSE_DEV) up -d

## ---- Production ----

docker-production:
	$(COMPOSE_PROD) up -d --build

docker-production-rebuild:
	$(COMPOSE_PROD) down -v --remove-orphans
	$(COMPOSE_PROD) build --no-cache
	$(COMPOSE_PROD) up -d

## ---- Common utilities (dev) ----

down:
	$(COMPOSE_DEV) down

ps:
	$(COMPOSE_DEV) ps

logs:
	$(COMPOSE_DEV) logs -f

migrate:
	$(COMPOSE_DEV) exec backend php artisan migrate

migrate-fresh:
	$(COMPOSE_DEV) exec backend php artisan migrate:fresh

artisan:
	$(COMPOSE_DEV) exec backend php artisan $(filter-out $@,$(MAKECMDGOALS))

composer:
	$(COMPOSE_DEV) exec backend composer $(filter-out $@,$(MAKECMDGOALS))

npm:
	$(COMPOSE_DEV) exec web npm $(filter-out $@,$(MAKECMDGOALS))

shell-backend:
	$(COMPOSE_DEV) exec backend sh

shell-web:
	$(COMPOSE_DEV) exec web sh

mail:
	docker compose -f docker-compose.yml -f docker-compose.mail.yml up -d

mail-down:
	docker compose -f docker-compose.mail.yml down

%:
	@: