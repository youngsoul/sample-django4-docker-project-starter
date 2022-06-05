docker-compose build django-web
docker-compose run django-web django-admin startproject django_project .
docker-compose up -d --build
docker-compose exec django-web python manage.py migrate
docker-compose exec django-web python manage.py createsuperuser

