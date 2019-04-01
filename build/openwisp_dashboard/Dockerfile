FROM python:3.7-alpine AS BASE

WORKDIR /opt/openwisp
RUN apk add  --update --no-cache build-base postgresql-dev
RUN pip install openwisp-users openwisp-utils psycopg2

FROM BASE

ARG CONTAINER_PORT=8003

ENV PG_ENGINE django.db.backends.postgresql
ENV PG_NAME openwisp
ENV PG_USER admin
ENV PG_PASS admin
ENV PG_HOST postgres
ENV PG_PORT 5432
ENV DJANGO_LANGUAGE_CODE=en-gb
ENV DJANGO_TIME_ZONE UTC
ENV DJANGO_MEDIA_VOLUME_LOCATION ./media
ENV DJANGO_ALLOWED_HOSTS *
ENV DJANGO_DEBUG False
ENV DJANGO_DEFAULT_FROM_EMAIL example@email.com
ENV DJANGO_SECRET_KEY DEFAULT_BAD_KEY
ENV DJANGO_EMAIL_PORT 1025
ENV DJANGO_CORS_ORIGIN_ALLOW_ALL True
ENV CONTAINER_PORT ${CONTAINER_PORT}
ENV DJANGO_EMAIL_BACKEND django.core.mail.backends.console.EmailBackend

COPY ./common/ /opt/openwisp/
COPY ./openwisp_dashboard/module_settings.py /opt/openwisp/openwisp/module_settings.py
COPY ./openwisp_dashboard/urls.py /opt/openwisp/openwisp/urls.py

RUN chmod +x /opt/openwisp/init_command.sh

EXPOSE ${CONTAINER_PORT}

CMD /opt/openwisp/init_command.sh