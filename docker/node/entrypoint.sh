#!/bin/bash

cd /home/container || exit 1

echo "[NodeJS] Node.js: $(node --version)"
echo "[NodeJS] npm: $(npm --version)"

if [ -n "${STARTUP}" ]; then
    echo "[NodeJS] Starting: ${STARTUP}"

    RAW_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')

    eval "MODIFIED_STARTUP=\"${RAW_STARTUP}\""

    echo "[NodeJS] Resolved: ${MODIFIED_STARTUP}"

    exec bash -c "${MODIFIED_STARTUP}"
fi

echo "[NodeJS] No STARTUP command provided."
exec bash