# syntax=docker/dockerfile:1

ARG NODE_VERSION=20
ARG NODE_VARIANT=trixie

FROM node:${NODE_VERSION}-${NODE_VARIANT}

LABEL org.opencontainers.image.title="Pterodactyl Node.js"
LABEL org.opencontainers.image.description="Production Node.js runtime for Pterodactyl"

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
    COREPACK_INTEGRITY_KEYS=0 \
    npm_config_update_notifier=false \
    npm_config_fund=false \
    npm_config_audit=false

RUN if grep -q bullseye /etc/os-release; then \
    sed -i 's|deb.debian.org|archive.debian.org|g; /security.debian.org/d; /bullseye-updates/d' /etc/apt/sources.list; \
    fi

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

RUN NODE_MAJOR="$(node -p "process.versions.node.split('.')[0]")" \
    && if [ "$NODE_MAJOR" -ge 20 ]; then npm install -g corepack@latest; fi \
    && (corepack enable || true)

RUN useradd -m -d /home/container -s /bin/bash container \
    && mkdir -p /home/container \
    && chown -R container:container /home/container

COPY docker/node/entrypoint.sh /entrypoint.sh

USER container
ENV USER=container \
    HOME=/home/container
WORKDIR /home/container

ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/bin/bash", "/entrypoint.sh"]