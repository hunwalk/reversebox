#!/bin/bash

current_dir=$(pwd)

# Check if the current folder has a PHP Docker Compose service
if docker compose ps 2>/dev/null | grep -qE 'app|php'; then
    # Extract container name from docker-compose ps output
    container_name=$(docker compose ps | grep -E 'app|php' | awk '{print $1}')
    echo "Using container: $container_name"
    # Pass through the command to the container
    docker exec -ti "$container_name" bash -c "cd '$current_dir' && $*"
else
    # Use default container name 'php'
    echo "No PHP Docker Compose service found. Using default container 'reversebox-php'."
    docker exec -ti reversebox-php bash -c "cd '$current_dir' && $*"
fi