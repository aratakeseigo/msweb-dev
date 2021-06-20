.PHONY: build-mac
build-mac:  ## docker build
	[ -f ./sb/.env ] || cp ./sb/.env.sample ./sb/.env
	[ -f ../docker-compose.sb.yml ] || cp ./docker-compose.sb.yml
	docker compose -f ../docker-compose.sb.yml build
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle install

.PHONY: build
build:  ## docker build
	if not exist .\sb\.env copy .\sb\.env.sample .\sb\.env
	if not exist ..\docker-compose.sb.yml copy .\docker-compose.sb.yml.sample ..\docker-compose.sb.yml
	docker compose -f ../docker-compose.sb.yml build
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle install

.PHONY: update
update:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle install

.PHONY: db_create
db_create:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rails db:create
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec ridgepole -c config/database.yml -E development --apply --dump-with-default-fk-name
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec ridgepole -c config/database.yml -E test --apply --dump-with-default-fk-name

.PHONY: run
run:
	docker compose -f ../docker-compose.sb.yml up sb

.PHONY: stop
stop:
	docker compose -f ../docker-compose.sb.yml stop

.PHONY: down
down:
	docker compose -f ../docker-compose.sb.yml down

.PHONY: recreate-db
recreate-db:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rails db:drop db:create

.PHONY: migrate
migrate:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rake db:migrate

.PHONY: seed
seed:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rake db:seed

.PHONY: console
console:
	docker-compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rails c

.PHONY: routes
routes:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rake routes

.PHONY: precompile
precompile:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rake assets:precompile

.PHONY: test
test:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rspec

.PHONY: test-with-prof
test-with-prof:
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rspec --format progress --profile 10

.PHONY: lint
lint: ## docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rubocop  --display-cop-names --extra-details --display-style-guide --parallel
	docker compose -f ../docker-compose.sb.yml run  --rm sb bundle exec rubocop  --fail-level W --display-only-fail-level-offense
