# @ suppresses the normal 'echo' of the command that is executed.
# - means ignore the exit status of the command that is executed (normally, a non-zero exit status would stop that part of the build).
# + means 'execute this command under make -n' (or 'make -t' or 'make -q') when commands are not normally executed.

# Containers ids, name is the container name in the docker-compose file
db-id=$(shell docker ps -q -f "name=sample-pg14-db-container"  | head -n 1)
web-id=$(shell docker ps -q -f "name=sample-django-web-container" | head -n 1)

WEB_SERVICE_NAME=django-web-service
DB_SERVICE_NAME=django-db-service

show-ids:
	@echo "web container id: " $(web-id)
	@echo "db container id:  " $(db-id)

init-project: build
	@docker compose run ${WEB_SERVICE_NAME} django-admin startproject django_project .
	@docker compose stop


# Build docker containers
build: build-db build-web

build-run: build run

clean-build:
	@docker compose -f docker-compose.yml build --no-cache

build-web:
	@docker compose -f docker-compose.yml build ${WEB_SERVICE_NAME}

build-db:
	@docker compose -f docker-compose.yml build ${DB_SERVICE_NAME}

# Run docker containers
run:
	@docker compose -f docker-compose.yml up

run-back:
	@docker compose -f docker-compose.yml up -d

runbuild-web:
	@docker compose -f docker-compose.yml up --build ${WEB_SERVICE_NAME}

run-web:
	@docker compose -f docker-compose.yml up ${WEB_SERVICE_NAME}

run-db:
	@docker compose -f docker-compose.yml up ${DB_SERVICE_NAME}

# restart containers with a stop then run
restart: stop run

restart-web: stop-web run-web

# Stop docker containers, but not remove them nor the volumes
stop:
	@docker compose stop

stop-db:
	-@docker stop $(db-id)

stop-web:
	-@docker stop $(web-id)

# Stop docker containers, remove them AND the named data volumes
down:
	@docker compose down -v


# Remove docker containers
rm-all: rm-web rm-db

rm-db:
	-@docker rm $(db-id)

rm-web:
	-@docker rm $(web-id)

run-shell: run-back shell-web


# Go to container bash shell
shell-web:
	@docker exec -it $(web-id) bash

shell-db:
	@docker exec -it $(db-id) bash

shell-django:
	@docker exec -it $(web-id) python manage.py shell

run-all-tests: build run-back
	-docker exec -it $(web-id) pytest tests/
	@docker compose stop

# make migrations appname=posts
migrations:
	@docker exec -it $(web-id) python manage.py makemigrations $(appname)

migrate:
	@docker exec -it $(web-id) python manage.py migrate

dumpdata:
	@docker exec -it $(web-id) python manage.py dumpdata $(appname)

collectstatic:
	@docker exec -it $(web-id) python manage.py collectstatic


logs:
	@docker compose logs

# Django commands
# make cmd=migrate manage
# make cmd="startapp accounts" manage
manage:
	@docker exec -t $(web-id) python manage.py $(cmd)

# make  startapp app="pages"
startapp:
	@docker exec -t $(web-id) python manage.py startapp $(appname)

volumes:
	@docker volume ls


#make volname=books_postgres_data remove-volume
remove-volume:
	@docker volume rm $(volname)

superuser:
	-docker exec -it $(web-id) python manage.py createsuperuser

deploy-checklist:
	@docker exec -t $(web-id) python manage.py check --deploy

generate-secret-key:
	@docker exec -t $(web-id) python -c 'import secrets; print(secrets.token_urlsafe(38))'

