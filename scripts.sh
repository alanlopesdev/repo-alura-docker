#!/usr/bin/env bash
set -euo pipefail

echo "Disk usage before cleanup:"
df -h
docker system df || true

# Stop the previous deployment, if present
docker compose -f docker-compose-prod.yaml down --remove-orphans || true

# Remove unused containers, images, networks, and build cache
docker system prune -af --volumes

# Load the new image
docker load -i /home/ubuntu/ecr_project_alura.tar

# Start the deployment
docker compose -f docker-compose-prod.yaml up -d --remove-orphans

# Remove the archive after Docker has loaded it
rm -f /home/ubuntu/ecr_project_alura.tar

echo "Disk usage after deployment:"
df -h
