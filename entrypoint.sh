#!/usr/bin/env bash
set -euo pipefail

# Controlli minimi su credenziali
: "${MINIO_ROOT_USER:?MINIO_ROOT_USER non impostata}"
: "${MINIO_ROOT_PASSWORD:?MINIO_ROOT_PASSWORD non impostata}"

# Avvia MinIO in background
# /data deve essere montata come disco persistente su Render
/usr/local/bin/minio server /data \
  --address "${MINIO_ADDRESS:-:9000}" \
  --console-address "${MINIO_CONSOLE_ADDRESS:-:9001}" \
  >/var/log/minio/minio.log 2>&1 &

# Prepara nginx.conf sostituendo $PORT (che Render fornisce) nel template
export PORT="${PORT:-8080}"
envsubst '\$PORT' </etc/nginx/templates/nginx.conf.template >/etc/nginx/nginx.conf

# Avvia Nginx in foreground
exec nginx -g 'daemon off;'
