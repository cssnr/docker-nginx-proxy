#!/usr/bin/env bash

set -e

REGISTRY_HOST="ghcr.io"
REGISTRY_USER="cssnr"
REGISTRY_REPO="docker-nginx-proxy"

DEFAULT_VERSION="mainline"
BUILD_CONTEXT="src"


if [ -f ".env" ];then
    echo "Sourcing Environment: .env"
    set -a
    source ".env"
    set +a
fi

VERSION="${1}"
#if [ -z "${VERSION}" ];then
#    if [ -n "${1}" ];then
#        VERSION="${1}"
#    else
#        read -rp "Version (${DEFAULT_VERSION}): " VERSION
#    fi
#fi

[[ -z "${VERSION}" ]] && VERSION="${DEFAULT_VERSION}"

echo "${REGISTRY_HOST}/${REGISTRY_USER}/${REGISTRY_REPO}:latest"


#if [ -z "${USERNAME}" ];then
#    read -rp "Username: " USERNAME
#fi
#if [ -z "${PASSWORD}" ];then
#    read -rp "Password: " PASSWORD
#fi
#
#docker login --username "${USERNAME}" --password "${PASSWORD}" "${REGISTRY_HOST}"
#docker login "${REGISTRY_HOST}"


#docker buildx create --use
#docker buildx build -t "${REGISTRY_HOST}/${REGISTRY_USER}/${REGISTRY_REPO}:${VERSION}" \
#    --platform linux/amd64,linux/arm64 \
#    --build-arg VERSION="${VERSION}" \
#    "${BUILD_CONTEXT}"

docker build -t "${REGISTRY_HOST}/${REGISTRY_USER}/${REGISTRY_REPO}:latest" \
    --build-arg VERSION="latest" \
    --build-arg NGINX_VERSION="${VERSION}" \
    "${BUILD_CONTEXT}"

# --build-arg VERSION="${VERSION}" \

#docker push "${REGISTRY_HOST}/${REGISTRY_USER}/${REGISTRY_REPO}:${VERSION}"
