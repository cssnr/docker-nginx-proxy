#!/usr/bin/env sh

set -e

echo "${0} - Starting as: $(whoami)"

SERVICE_NAME=${SERVICE_NAME:-app}
SERVICE_PORT=${SERVICE_PORT:-80}

echo "SERVICE_NAME: ${SERVICE_NAME}"
echo "SERVICE_PORT: ${SERVICE_PORT}"

sed "s/SERVICE_NAME/${SERVICE_NAME}/g" -i /etc/nginx/nginx.conf
sed "s/SERVICE_PORT/${SERVICE_PORT}/g" -i /etc/nginx/nginx.conf

echo "${0} - Done"
