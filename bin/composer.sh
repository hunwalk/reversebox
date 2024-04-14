#!/bin/bash

# Check if the current folder has a PHP Docker Compose service
if docker compose ps | grep -qE 'app|php'; then
    # Extract container name from docker-compose ps output
    container_name=$(docker compose ps | grep -E 'app|php' | awk '{print $1}')
    echo "Using container: $container_name"
    # Pass through the command to the container
    docker exec -ti "$container_name" composer "$@"
else
    # Use default container name 'php'
    echo "No PHP Docker Compose service found. Using default container 'php'."
    docker exec -ti php composer "$@"
fi
