FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx curl ca-certificates dumb-init gettext-base \
  && rm -rf /var/lib/apt/lists/*

# MinIO server
RUN curl -fsSL https://dl.min.io/server/minio/release/linux-amd64/minio \
    -o /usr/local/bin/minio \
 && chmod +x /usr/local/bin/minio

RUN mkdir -p /data /var/log/minio
ENV PORT=8080
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV MINIO_ADDRESS=:9000
ENV MINIO_CONSOLE_ADDRESS=:9001

EXPOSE 8080
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
