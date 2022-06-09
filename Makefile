# @ suppresses the normal 'echo' of the command that is executed.
# - means ignore the exit status of the command that is executed (normally, a non-zero exit status would stop that part of the build).
# + means 'execute this command under make -n' (or 'make -t' or 'make -q') when commands are not normally executed.

# Containers ids
db-id=$(shell docker ps -a -q -f "name=pg14-django4-db"  | head -n 1)
web-id=$(shell docker ps -a -q -f "name=django4-web" | head -n 1)

show-ids:
	@echo "web container id: " $(web-id)
	@echo "db container id:  " $(db-id)

# Build docker containers
build: build-web build-db

build-web:
	@docker-compose -f docker-compose.yml build web

build-db:
	@docker-compose -f docker-compose.yml build db

# Run docker containers
run:
	@docker-compose -f docker-compose.yml up

run-web:
	@docker-compose -f docker-compose.yml up web

run-db:
	@docker-compose -f docker-compose.yml up db

# restart containers with a stop then run
restart: stop run

# Stop docker containers, but not remove them nor the volumes
stop:
	@docker-compose stop
stop-db:
	-@docker stop $(db-id)
stop-web:
	-@docker stop $(web-id)

# Stop docker containers, remove them AND the named data volumes
down:
	@docker-compose down -v


# Remove docker containers
rm-all: rm-web rm-db
rm-db:
	-@docker rm $(db-id)
rm-web:
	-@docker rm $(web-id)


# Go to container bash shell
shell-web:
	@docker exec -it $(web-id) bash

shell-db:
	@docker exec -it $(db-id) bash

tests:
	@docker-compose exec web python manage.py test


migrations:
	@docker-compose exec web python manage.py makemigrations

migrate:
	@docker-compose exec web python manage.py migrate

collectstatic:
	@docker-compose exec web python manage.py collectstatic


logs:
	@docker-compose logs

# Django commands
# make cmd=migrate manage
manage:
	@docker exec -t $(web-id) python manage.py $(cmd)

volumes:
	@docker volume ls


#make volname=books_postgres_data remove-volume
remove-volume:
	@docker volume rm $(volname)

superuser:
	-docker exec -it $(web-id) python manage.py createsuperuser

deploy-checklist:
	@docker-compose exec web python manage.py check --deploy

generate-secret-key:
	@docker-compose exec web python -c 'import secrets; print(secrets.token_urlsafe(38))'


heroku-login:
	@heroku login

heroku-create:
	@heroku create

heroku-app-name=serene-bastion-37621

heroku-set-container:
	@heroku stack:set container -a $(heroku-app-name)

heroku-create-postgres:
	@heroku addons:create heroku-postgresql:hobby-dev -a $(heroku-app-name)

heroku-django-secret-key:
	@heroku config:set DJANGO_SECRET_KEY=$(shell python -c 'import secrets; print(secrets.token_urlsafe(38))')  -a $(heroku-app-name)

heroku-git-remote:
	@heroku git:remote -a $(heroku-app-name)

heroku-push-master:
	-git remote -v
	-git push heroku master

heroku-open:
	@heroku open -a $(heroku-app-name)

# Django commands
# make cmd=migrate heroku-manage
# make cmd=createsuperuser heroku-manage
heroku-manage:
	@heroku run python manage.py $(cmd)
