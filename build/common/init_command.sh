#!/bin/sh
# OpenWISP common module init script

if [ "$MODULE_NAME" = 'dashboard' ];
then 
    python services_status.py database redis
    python manage.py migrate --settings=openwisp.migrate_settings --noinput
    python load_init_data.py
else 
    python services_status.py database dashboard
fi
python manage.py collectstatic --noinput
# python manage.py runserver 0.0.0.0:${CONTAINER_PORT}

envsubst < uwsgi.conf.ini > uwsgi.ini
uwsgi --ini uwsgi.ini
