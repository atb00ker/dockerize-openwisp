#!/bin/sh
# Container init commands for all containers 
# except openwisp-dashboard `init_command.sh` 
# for dashboard is in openwisp-dashboard/ directory

python services_status.py database
python manage.py collectstatic --noinput
python services_status.py dashboard
python manage.py runserver 0.0.0.0:${CONTAINER_PORT}
