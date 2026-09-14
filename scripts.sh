#! /bin/bash
docker load -i teste-alan-iso.tar
mv docker-compose-prod.yaml docker-compose-yaml
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
