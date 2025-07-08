.PHONY: up down build console c sh rspec lint routes install setup swagger

up:
	docker compose up

down:
	docker compose down

build:
	docker compose build

console:
	docker compose run --rm web rails console


sh:
	docker compose run --rm web bash

rspec:
	docker compose run --rm web rspec $(filter-out $@,$(MAKECMDGOALS))

%:
	@:

lint:
	docker compose run --rm web rubocop

install:
	docker compose run --rm web bundle install

swagger:
	docker compose run --rm web rails rswag:specs:swaggerize

# SETUP

setup:
	docker compose build
	docker compose up -d
	docker compose exec web rails db:create db:migrate db:seed
