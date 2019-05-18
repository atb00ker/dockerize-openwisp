FROM python:3.7-alpine

WORKDIR /opt/openwisp/

RUN apk add certbot openssl

ENV ORCHESTRATION_CERT_MODE=False \
    PYTHONUNBUFFERED=1

COPY ./openwisp_orchestration/utils.sh \ 
    ./openwisp_orchestration/init_command.sh \
    /opt/openwisp/
RUN chmod +x /opt/openwisp/init_command.sh
CMD /opt/openwisp/init_command.sh
