FROM python:3.7-alpine AS BASE

WORKDIR /opt/openwisp

RUN apk add --update --no-cache build-base libffi-dev openssl-dev python3-dev zlib-dev jpeg-dev sqlite bash --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gdal-dev libspatialite-dev geos-dev
RUN wget http://download.osgeo.org/geos/geos-3.7.1.tar.bz2 && tar xjf geos-3.7.1.tar.bz2 && cd geos-3.7.1/ && ./configure && make && make install && rm -rf /opt/openwisp/geos-3.7.1.tar.bz2 /opt/openwisp/geos-3.7.1  

COPY ./openwisp_controller/requirements.txt /opt/openwisp/requirements.txt
RUN pip install -r requirements.txt

FROM BASE

ARG CONTAINER_PORT=8000

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
ENV DJANGO_REDIS_HOST redis
ENV DJANGO_DEBUG False
ENV DJANGO_X509_DEFAULT_CERT_VALIDITY 1825
ENV DJANGO_X509_DEFAULT_CA_VALIDITY 3650
ENV DJANGO_DEFAULT_FROM_EMAIL example@email.com
ENV DJANGO_SECRET_KEY DEFAULT_BAD_KEY
ENV DJANGO_EMAIL_PORT 1025
ENV DJANGO_EMAIL_BACKEND django.core.mail.backends.console.EmailBackend
ENV CONTAINER_PORT ${CONTAINER_PORT}
COPY ./common/ /opt/openwisp/
COPY ./openwisp_controller/module_settings.py /opt/openwisp/openwisp/module_settings.py
COPY ./openwisp_controller/urls.py /opt/openwisp/openwisp/urls.py

RUN chmod +x /opt/openwisp/init_command.sh

EXPOSE ${CONTAINER_PORT}

CMD /opt/openwisp/init_command.sh