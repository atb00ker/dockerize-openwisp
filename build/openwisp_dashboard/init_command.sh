#!/bin/sh
# Container init commands for openwisp-dashboard

python services_status.py database redis
python manage.py collectstatic --noinput
python manage.py migrate --noinput
python load_init_data.py
python manage.py runserver 0.0.0.0:${CONTAINER_PORT}
