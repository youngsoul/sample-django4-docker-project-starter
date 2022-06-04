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
