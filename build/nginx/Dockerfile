FROM nginx:alpine

WORKDIR /etc/nginx/

COPY ./common/services_status.py \
    ./nginx/init_command.sh \ 
    ./nginx/openwisp.ssl.template.conf \ 
    ./nginx/openwisp.template.conf \ 
    /etc/nginx/

RUN chmod +x /etc/nginx/init_command.sh
CMD /etc/nginx/init_command.sh

ENV MODULE_NAME=nginx \
    PYTHONUNBUFFERED=1 \
    DOLLAR=$ \
    ORCHESTRATION_CERT_MODE=False \
    NGINX_CLIENT_BODY_SIZE=5M \
    NGINX_GZIP=off \
    NGINX_IP6=True \
    # USWGI pass_port
    DASHBOARD_APP_PORT=8000 \
    CONTROLLER_APP_PORT=8001 \
    RADIUS_APP_PORT=8002 \
    TOPOLOGY_APP_PORT=8003 \
    # Application Service Name
    DASHBOARD_APP_SERVICE=dashboard \
    CONTROLLER_APP_SERVICE=controller \
    RADIUS_APP_SERVICE=radius \
    TOPOLOGY_APP_SERVICE=topology \
    # Listen domains
    DASHBOARD_DOMAIN=dashboard.openwisp.org \
    CONTROLLER_DOMAIN=controller.openwisp.org \
    RADIUS_DOMAIN=radius.openwisp.org \
    TOPOLOGY_DOMAIN=topology.openwisp.org

EXPOSE 80 443
