#!/bin/bash

set -e

export APP_ROOT=${APP_ROOT:-'/var/www/html/'}
export PHP_BACKEND_ADDR=${PHP_BACKEND_ADDR:-'localhost'}
export PHP_BACKEND_PORT=${PHP_BACKEND_PORT:-'9000'}

export FCGI_HTTPS=${FCGI_HTTPS:-'on'}

export NGINX_STATUS_ALLOW=${NGINX_STATUS_ALLOW:-'all'}
export NGINX_STATUS_DENY=${NGINX_STATUS_DENY:-'all'}
export ACCESS_LOG_FORMAT=${ACCESS_LOG_FORMAT:-'access_format'}

/usr/local/bin/confd -onetime -backend env;

nginx -g 'daemon off;'
