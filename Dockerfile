# Container con Nginx + MinIO
FROM ubuntu:22.04

# Non-interattivo
ENV DEBIAN_FRONTEND=noninteractive

# Dipendenze: nginx, curl, ca-certificates, dumb-init
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx curl ca-certificates dumb-init \
  && rm -rf /var/lib/apt/lists/*

# Scarica il binario di MinIO (server)
# Nota: puoi bloccare una versione specifica sostituendo "latest" con una release.
RUN curl -fsSL https://dl.min.io/server/minio/release/linux-amd64/minio \
    -o /usr/local/bin/minio \
 && chmod +x /usr/local/bin/minio

# Directory dati e log
RUN mkdir -p /data /var/log/minio

# Nginx: abilita variabili d'ambiente nei template
ENV PORT=8080
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template

# Entrypoint per avviare MinIO + Nginx
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# MinIO: porte interne
ENV MINIO_ADDRESS=:9000
ENV MINIO_CONSOLE_ADDRESS=:9001

# Render imposta PORT automaticamente; useremo envsubst per far ascoltare Nginx su $PORT
EXPOSE 8080

# Dati persistenti
VOLUME ["/data"]

# Avvio
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
