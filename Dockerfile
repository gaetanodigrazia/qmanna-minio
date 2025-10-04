# Container con Nginx + MinIO
FROM ubuntu:22.04

# Non-interattivo
ENV DEBIAN_FRONTEND=noninteractive

# Dipendenze: nginx, curl, ca-certificates, dumb-init
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx curl ca-certificates dumb-init \
  && rm -rf /var/lib/apt/lists/*

mkdir -p ~/minio/data

docker run \
   -p 9000:9000 \
   -p 9001:9001 \
   --name minio \
   -v ~/minio/data:/data \
   -e "MINIO_ROOT_USER=ROOTNAME" \
   -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
   quay.io/minio/minio server /data --console-address ":9001"
