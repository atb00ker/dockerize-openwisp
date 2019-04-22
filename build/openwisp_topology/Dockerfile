FROM python:3.7-alpine AS BASE

WORKDIR /opt/openwisp
RUN apk add  --update --no-cache build-base postgresql-dev gettext python3-dev linux-headers
RUN pip install openwisp-network-topology psycopg2 uwsgi

FROM BASE

ENV DB_ENGINE django.db.backends.postgresql
ENV DB_NAME openwisp_db
ENV DB_USER admin
ENV DB_PASS admin
ENV DB_HOST postgres
ENV DB_PORT 5432
ENV DJANGO_LANGUAGE_CODE=en-gb
ENV DJANGO_TIME_ZONE UTC
ENV DJANGO_MEDIA_VOLUME_LOCATION ./media
ENV DJANGO_ALLOWED_HOSTS *
ENV DJANGO_DEBUG False
ENV DJANGO_DEFAULT_FROM_EMAIL example@email.com
ENV DJANGO_SECRET_KEY DEFAULT_BAD_KEY
ENV DJANGO_EMAIL_PORT 1025
ENV CONTAINER_PORT 8003
ENV DJANGO_EMAIL_BACKEND django.core.mail.backends.console.EmailBackend
ENV OPENWISP_DASHBOARD_PROTOCOL http
ENV OPENWISP_DASHBOARD_HOST dashboard
ENV OPENWISP_DASHBOARD_LISTEN_PORT 8000
ENV MODULE_NAME topology

COPY ./common/ /opt/openwisp/
COPY ./openwisp_topology/module_settings.py /opt/openwisp/openwisp/module_settings.py
COPY ./openwisp_topology/urls.py /opt/openwisp/openwisp/urls.py


RUN chmod +x /opt/openwisp/init_command.sh

EXPOSE ${TOPOLOGY_APP_PORT}

CMD /opt/openwisp/init_command.sh
