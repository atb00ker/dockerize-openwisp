#!/bin/sh
# Nginx init script

envsubst '${DASHBOARD_APP_PORT},${CONTROLLER_APP_PORT}, \ 
${RADIUS_APP_PORT},${TOPOLOGY_APP_PORT},${OPENWISP_DASHBOARD_LISTEN_PORT}, \ 
${OPENWISP_CONTROLLER_LISTEN_PORT},${OPENWISP_RADIUS_LISTEN_PORT},\ 
${OPENWISP_TOPOLOGY_LISTEN_PORT}' < /etc/nginx/nginx.template.conf > /etc/nginx/conf.d/nginx.conf

nginx -g 'daemon off;'
