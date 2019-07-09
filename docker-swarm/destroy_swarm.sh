#!/bin/bash

# If docker-machines exist only for this swarm, num of workers equals machines
# Otherwise needs num as input
machines=$(docker-machine ls | wc -l)
machines=$(( machines - 1 ))
num_workers="${1:-$machines}"
echo "${num_workers}"
for((i=1; i<="$num_workers"; i++)); do
  docker-machine kill worker${i}
  docker-machine rm worker${i} --force
done

# Kill visualizer
visualizer=$(docker ps | grep dockersamples/visualizer)
visualizer_id=$(cut -d' ' -f1 <<<"$visualizer")
docker kill ${visualizer_id}

docker swarm leave --force
