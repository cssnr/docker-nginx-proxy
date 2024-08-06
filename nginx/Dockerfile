FROM nginx:alpine-slim

LABEL org.opencontainers.image.source="https://github.com/cssnr/docker-nginx-proxy"

ENV TZ=UTC

COPY nginx.conf /etc/nginx/nginx.conf

COPY --chmod=0755 10-update-config.sh /docker-entrypoint.d
