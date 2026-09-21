#!/usr/bin/env bash
set -euo pipefail

echo "Disk usage before cleanup:"
df -h
docker system df || true

# Stop the previous deployment, if present
docker compose -f docker-compose-prod.yaml down --remove-orphans || true

# Remove unused containers, images, networks, and build cache
docker system prune -af --volumes

# Remove stale deployment archives
rm -f /home/ubuntu/ecr_project_alura.tar

# Load the new image
docker load -i /home/ubuntu/ecr_project_alura.tar

# Start the deployment
docker compose -f docker-compose-prod.yaml up -d --remove-orphans

# Remove the archive after Docker has loaded it
rm -f /home/ubuntu/ecr_project_alura.tar

echo "Disk usage after deployment:"
df -h

#! /bin/bash
docker load -i ecr_project_alura.tar
mv docker-compose-prod.yaml docker-compose.yaml
containers_id=$(docker ps -q)
if [ -z "$container_ids" ]; then
  echo "Não há containers em execução"
else
  for container_id in $container_ids; do
    echo "Parando container: $container_id"
    docker stop $container_id
  done
  echo "Todos os containers em execução foram parados."
fi

docker compose up -d
