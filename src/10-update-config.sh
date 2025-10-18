#!/usr/bin/env sh

set -e

echo "${0} - Starting as: $(whoami)"

SERVICE_NAME=${SERVICE_NAME:-app}
SERVICE_PORT=${SERVICE_PORT:-80}

echo "SERVICE_NAME: ${SERVICE_NAME}"
echo "SERVICE_PORT: ${SERVICE_PORT}"

sed "s/SERVICE_PORT/${SERVICE_PORT}/g" -i /etc/nginx/nginx.conf
sed "s/SERVICE_NAME/${SERVICE_NAME}/g" -i /etc/nginx/nginx.conf

if [ -n "${GZIP_TYPES}" ];then
echo "GZIP_TYPES: ${GZIP_TYPES}"
cat <<EOF > /etc/nginx/conf.d/http.gzip.conf
gzip            on;
gzip_proxied    any;
gzip_min_length ${GZIP_LENGTH:-1000};
gzip_types      ${GZIP_TYPES};
EOF
fi

if [ -n "${BASIC_AUTH}" ];then
echo "BASIC_AUTH: ${BASIC_AUTH}"
printf '%s' "${BASIC_AUTH}" > /etc/nginx/auth.users
cat <<EOF > /etc/nginx/conf.d/location.auth.conf
auth_basic            "${BASIC_REALM:-Unauthorized}";
auth_basic_user_file  /etc/nginx/auth.users;
EOF
fi

echo "${0} - Done"

nginx -version ||:
curl --version | awk 'NR==1{print "curl version: "$2}' ||:
