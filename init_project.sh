docker-compose build web
docker-compose exec web django-admin startproject django_project .
docker-compose up -d --build
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser

