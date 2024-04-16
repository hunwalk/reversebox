#!/bin/bash

current_dir=$(pwd)

# Check if the current folder has a Node.js Docker Compose service
if docker compose ps 2>/dev/null | grep -qE 'app|node'; then
    # Extract container name from docker-compose ps output
    container_name=$(docker compose ps | grep -E 'app|node' | awk '{print $1}')
    echo "Using container: $container_name"
    # Pass through the command to the container
    docker exec -ti "$container_name" "$@"
else
    # Use default container name 'reversebox-nodejs'
    echo "No Node.js Docker Compose service found. Using default container 'reversebox-nodejs'."
    docker exec -ti reversebox-nodejs bash -c "cd '$current_dir' && $*"
fi