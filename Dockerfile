# syntax=docker/dockerfile:1

ARG NODE_VERSION=20
ARG NODE_VARIANT=trixie

FROM node:${NODE_VERSION}-${NODE_VARIANT}

LABEL org.opencontainers.image.title="Pterodactyl Node.js"
LABEL org.opencontainers.image.description="Production Node.js runtime for Pterodactyl"

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
    npm_config_update_notifier=false \
    npm_config_fund=false \
    npm_config_audit=false

WORKDIR /home/container

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        openssh-client \
        tini \
        wget \
        unzip \
        zip \
        file \
        jq \
        procps \
        netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable

RUN mkdir -p /home/container \
    && chown -R node:node /home/container

USER node

WORKDIR /home/container

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["bash"]