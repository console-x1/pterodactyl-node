#!/bin/bash

cd /home/container || exit 1

case "${NODE_JITLESS:-true}" in
    true)
        case " ${NODE_OPTIONS:-} " in
            *" --jitless "*) ;;
            *) export NODE_OPTIONS="${NODE_OPTIONS:+${NODE_OPTIONS} }--jitless" ;;
        esac
        echo "[NodeJS] V8 JIT-less mode enabled."
        ;;
    false)
        echo "[NodeJS] V8 JIT-less mode disabled."
        ;;
    *)
        echo "[NodeJS] ERROR: NODE_JITLESS must be true or false (got '${NODE_JITLESS}')." >&2
        exit 1
        ;;
esac

echo "[NodeJS] Node.js: $(node --version)"
echo "[NodeJS] npm: $(npm --version)"

if [ -n "${STARTUP}" ]; then

    RAW_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')

    eval "MODIFIED_STARTUP=\"${RAW_STARTUP}\""

    echo "[NodeJS] Starting: ${MODIFIED_STARTUP}"

    exec bash -c "${MODIFIED_STARTUP}"
fi

echo "[NodeJS] No STARTUP command provided."
exec bash