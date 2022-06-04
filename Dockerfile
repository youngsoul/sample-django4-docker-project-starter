# Pull base image
FROM python:3.10.4-slim-bullseye

# Set environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install nano
RUN apt-get -y update
RUN apt-get -y install apt-file
RUN apt-file update
RUN apt-get install -y nano


# Set working directory inside container
WORKDIR /code

# Install Dependencies
COPY ./requirements.in .
RUN pip install pip-tools
RUN pip-compile
RUN pip install -r requirements.txt

# copy local project code to container code
# first '.' is where the Dockerfile is, the second '.' is to the WORKDIR
COPY . .

RUN echo "django-admin startproject projname ."
RUN echo "python manage.py migrate"
RUN echo "python manage.py startapp firstapp"
RUN echo "update settings.py to update INSTALLED_APPS"
RUN echo "add: firstapp.apps.FirstappConfig"
