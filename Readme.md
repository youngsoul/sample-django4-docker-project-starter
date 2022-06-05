# Simple Sample Django4 Docker Project Starter


## Setup

* clone this repo and in terminal window run:

* `docker-compose build term`

* `docker-compose run term`

In the docker terminal window run:

* `django-admin startproject myproject .`
* `python manage.py migrate`

In terminal window run:

* `docker-compose build web`
* `docker-compose up web`


## PyCharm

You can now create a PyCharm project and set the Python Interpreter to the docker-compose.yml files selecting 'web' as the service

This will keep you from having to create a local venv just to install Django and call startproject.

## Settings.py

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'djangodb',
        'USER': 'postgres',
        'PASSWORD': 'postgres',
        'HOST': 'django-db', # set in docker-compose.yml
        'PORT': 5432
    }
}

```

Docker compose commands:

```shell
docker-compose build term
docker-compose run term
django-admin startproject django_project .
docker-compose up -d --build
docker-compose exec web django-admin startproject django_project .
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser

```
