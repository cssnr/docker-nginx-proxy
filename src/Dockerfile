ARG VERSION=1
FROM nginx:${VERSION}-alpine-slim

ARG VERSION

ENV TZ=UTC

LABEL org.opencontainers.image.source="https://github.com/cssnr/docker-nginx-proxy"
LABEL org.opencontainers.image.description="Docker Nginx Proxy"
LABEL org.opencontainers.image.authors="smashedr"
LABEL org.opencontainers.image.version="${VERSION}"

RUN apk add --no-cache curl

COPY nginx.conf /etc/nginx/nginx.conf

COPY --chmod=0755 10-update-config.sh /docker-entrypoint.d
