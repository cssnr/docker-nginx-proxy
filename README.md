[![Image Size](https://badges.cssnr.com/ghcr/size/cssnr/docker-nginx-proxy)](https://github.com/cssnr/docker-nginx-proxy/pkgs/container/docker-nginx-proxy)
[![Image Latest](https://badges.cssnr.com/ghcr/tags/cssnr/docker-nginx-proxy/latest)](https://github.com/cssnr/docker-nginx-proxy/pkgs/container/docker-nginx-proxy)
[![Image Tags](https://badges.cssnr.com/ghcr/tags/cssnr/docker-nginx-proxy)](https://github.com/cssnr/docker-nginx-proxy/pkgs/container/node-badges)
[![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/docker-nginx-proxy?sort=semver&filter=!*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/docker-nginx-proxy/tags)
[![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/docker-nginx-proxy?sort=semver&filter=!*.*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/docker-nginx-proxy/releases)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/docker-nginx-proxy?logo=github)](https://github.com/cssnr/docker-nginx-proxy/releases/latest)
[![Workflow Build](https://img.shields.io/github/actions/workflow/status/cssnr/docker-nginx-proxy/build.yaml?logo=cachet&label=build)](https://github.com/cssnr/docker-nginx-proxy/actions/workflows/build.yaml)
[![Workflow Lint](https://img.shields.io/github/actions/workflow/status/cssnr/docker-nginx-proxy/lint.yaml?logo=cachet&label=lint)](https://github.com/cssnr/docker-nginx-proxy/actions/workflows/lint.yaml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/cssnr/docker-nginx-proxy?logo=github&label=updated)](https://github.com/cssnr/docker-nginx-proxy/pulse)
[![GitHub Contributors](https://img.shields.io/github/contributors-anon/cssnr/docker-nginx-proxy?logo=github)](https://github.com/cssnr/docker-nginx-proxy/graphs/contributors)
[![GitHub Repo Size](https://img.shields.io/github/repo-size/cssnr/docker-nginx-proxy?logo=bookstack&logoColor=white&label=repo%20size)](https://github.com/cssnr/docker-nginx-proxy?tab=readme-ov-file#readme)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/docker-nginx-proxy?logo=htmx)](https://github.com/cssnr/docker-nginx-proxy/tree/master/src)
[![GitHub Discussions](https://img.shields.io/github/discussions/cssnr/docker-nginx-proxy?logo=github)](https://github.com/cssnr/docker-nginx-proxy/discussions)
[![GitHub Forks](https://img.shields.io/github/forks/cssnr/docker-nginx-proxy?style=flat&logo=github)](https://github.com/cssnr/docker-nginx-proxy/forks)
[![GitHub Repo Stars](https://img.shields.io/github/stars/cssnr/docker-nginx-proxy?style=flat&logo=github)](https://github.com/cssnr/docker-nginx-proxy/stargazers)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github&label=org%20stars)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-72a5f2?logo=kofi&label=support)](https://ko-fi.com/cssnr)

# Docker Nginx Proxy

Docker Nginx Proxy Container.

This works quite well as is...

## Examples

If your app container is called `app` and listens on `3000` this will reverse proxy it to the `PORT` exposed on nginx.

```yaml
services:
  nginx:
    image: ghcr.io/cssnr/docker-nginx-proxy:latest
    environment:
      - SERVICE_NAME=app
      - SERVICE_PORT=3000
    ports:
      - '${PORT:-80}:80'

  app:
    image: ghcr.io/smashedr/node-badges:latest
    command: 'npm start'

  redis:
    image: redis:6-alpine
    command: 'redis-server --appendonly yes'
```

With the healthcheck:

```yaml
services:
  nginx:
    image: ghcr.io/cssnr/docker-nginx-proxy:latest
    environment:
      - SERVICE_NAME=app
      - SERVICE_PORT=3000
    healthcheck:
      test: ['CMD-SHELL', 'curl -sf localhost:80/health-check || exit 1']
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    ports:
      - '${PORT:-80}:80'
```

First example, but deployed to a [Docker Swarm](https://docs.docker.com/engine/swarm/) cluster using [Traefik](https://github.com/traefik/traefik).

```yaml
version: '3.8'

services:
  nginx:
    image: ghcr.io/cssnr/docker-nginx-proxy:latest
    environment:
      - SERVICE_NAME=app
      - SERVICE_PORT=3000
    deploy:
      mode: global
      resources:
        limits:
          cpus: '1.0'
          memory: 64M
      labels:
        - traefik.enable=true
        - traefik.docker.network=traefik-public
        - traefik.constraint-label=traefik-public
        - traefik.http.routers.node-badges-http.rule=Host(`badges.cssnr.com`)
        - traefik.http.routers.node-badges-http.entrypoints=http
        - traefik.http.routers.node-badges-http.middlewares=https-redirect
        - traefik.http.routers.node-badges-https.rule=Host(`badges.cssnr.com`)
        - traefik.http.routers.node-badges-https.entrypoints=https
        - traefik.http.routers.node-badges-https.tls=true
        - traefik.http.services.node-badges-https.loadbalancer.server.port=80
    healthcheck:
      test: ['CMD-SHELL', 'curl -sf localhost:80/health-check || exit 1']
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    depends_on:
      - app
    networks:
      - internal
      - traefik-public

  app:
    image: ghcr.io/smashedr/node-badges:latest
    command: 'npm start'
    deploy:
      mode: global
      resources:
        limits:
          cpus: '2.0'
          memory: 256M
    healthcheck:
      test: ['CMD-SHELL', 'curl -sf localhost:3000/app-health-check || exit 1']
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
    depends_on:
      - redis
    networks:
      - internal

  redis:
    image: redis:6-alpine
    command: 'redis-server --appendonly yes'
    deploy:
      replicas: 1
      resources:
        limits:
          cpus: '1.0'
          memory: 128M
    volumes:
      - redis_data:/data
    networks:
      - internal

volumes:
  redis_data:

networks:
  internal:
    driver: overlay
  traefik-public:
    external: true
```

## Support

Please let us know if you run into any [issues](https://github.com/cssnr/docker-nginx-proxy/issues)
or want to see [new features](https://github.com/cssnr/docker-nginx-proxy/discussions/categories/feature-requests)...

For general help or to request a feature:

- Q&A Discussion: https://github.com/cssnr/docker-nginx-proxy/discussions/categories/q-a
- Request a Feature: https://github.com/cssnr/docker-nginx-proxy/discussions/categories/feature-requests

If you are experiencing an issue/bug or getting unexpected results:

- Report an Issue: https://github.com/cssnr/docker-nginx-proxy/issues
- Chat with us on Discord: https://discord.gg/wXy6m2X8wY
- Provide General Feedback: [https://cssnr.github.io/feedback/](https://cssnr.github.io/feedback/)

# Contributing

Please consider making a donation to support the development of this project
and [additional](https://cssnr.com/) open source projects.

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/cssnr)

If you would like to submit a PR, please review the [CONTRIBUTING.md](#contributing-ov-file).

For a full list of current projects visit: [https://cssnr.github.io/](https://cssnr.github.io/)
