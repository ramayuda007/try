.SILENT:

DOCKER_COMPOSE = docker-compose
DOCKER_PHP_CONTAINER_EXEC = $(DOCKER_COMPOSE) exec php

DOCKER_PHP_EXECUTABLE_CMD = php -d memory_limit=1G

CMD_ARTISAN = $(DOCKER_PHP_EXECUTABLE_CMD) artisan
CMD_COMPOSER = $(DOCKER_PHP_EXECUTABLE_CMD) /usr/bin/composer

build-up:
	$(DOCKER_COMPOSE) up --build -d

start:
	$(DOCKER_COMPOSE) up -d

stop:
	$(DOCKER_COMPOSE) stop

logs:
	$(DOCKER_COMPOSE) logs -ft --tail=50

install:
ifeq (,$(wildcard ./.env))
	cp .env.example .env
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) key:generate
endif
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_COMPOSER) install
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) migrate:fresh --seed

cache:
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) config:clear
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) cache:clear
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) route:cache

reset:
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) migrate:fresh
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) db:seed --class=DatabaseSeeder

route-list:
	$(DOCKER_PHP_CONTAINER_EXEC) $(CMD_ARTISAN) route:list

bash:
	$(DOCKER_PHP_CONTAINER_EXEC) bash
