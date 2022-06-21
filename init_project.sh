docker-compose build django4-web
docker-compose run django4-web django-admin startproject django_project .
docker-compose up -d --build
# NOTE you want to create a custom user FIRST, before doing a migrate and creating a super user
# the statements below are kept in the init script as an example but you should not run these before
# you create a custom user model
#docker-compose exec django-web python manage.py migrate
#docker-compose exec django-web python manage.py createsuperuser
