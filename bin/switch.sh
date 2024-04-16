#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq before running this script."
    exit 1
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl before running this script."
    exit 1
fi

# Check if docker-compose or docker compose is available
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_COMMAND="docker-compose"
elif command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE_COMMAND="docker compose"
else
    echo "Error: docker-compose is not installed. Please install docker-compose before running this script."
    exit 1
fi

# Check if one argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <service>"
    exit 1
fi

service=$1

# Define available minor versions for PHP and Node.js
php_minor_versions=(
    5.6-fpm 7.0-fpm 7.1-fpm 7.2-fpm 7.3-fpm 7.4-fpm 8.0-fpm 8.1-fpm 8.2-fpm 8.3-fpm
)
nodejs_minor_versions=(
    14 15 16 17 18 19 20 21
)

# Prompt user to select a version
echo "Available $service versions:"
if [ "$service" == "php" ]; then
    for version in "${php_minor_versions[@]}"; do
        echo "$version"
    done
elif [ "$service" == "nodejs" ]; then
    for version in "${nodejs_minor_versions[@]}"; do
        echo "$version"
    done
else
    echo "Error: Unsupported service. Supported services: php, nodejs"
    exit 1
fi

read -p "Enter the $service version code (e.g., php:8.2-fpm): " version_code

# Check if the provided version code is valid for the given service
if [ "$service" == "php" ]; then
    if ! echo "${php_minor_versions[@]}" | grep -q "$version_code"; then
        echo "Error: Invalid version code for PHP. Available versions: ${php_minor_versions[*]}"
        exit 1
    fi
elif [ "$service" == "nodejs" ]; then
    if ! echo "${nodejs_minor_versions[@]}" | grep -q "$version_code"; then
        echo "Error: Invalid version code for Node.js. Available versions: ${nodejs_minor_versions[*]}"
        exit 1
    fi
fi

# Check if the tag exists on Docker Hub
echo "Checking if $service:$version_code exists on Docker Hub..."
response=$(curl -s -o /dev/null -w "%{http_code}" "https://hub.docker.com/v2/namespaces/library/repositories/$service/tags/$version_code")
if [ $response -ne 200 ]; then
    echo "Error: $service:$version_code does not exist on Docker Hub."
    exit 1
fi

# Store the selected tag in .env
selected_tag="$service:$version_code"
echo "Storing $service tag $selected_tag in .env..."

# Check if PHP_TAG already exists in .env, if so, replace it
if grep -q "^${service^^}_TAG=" ~/reversebox/.env; then
    sed -i "s|^${service^^}_TAG=.*|${service^^}_TAG=$selected_tag|" ~/reversebox/.env
else
    echo "${service^^}_TAG=$selected_tag" >> ~/reversebox/.env
fi

# Build the service in ~/reversebox
echo "Building $service in ~/reversebox..."
cd ~/reversebox && $DOCKER_COMPOSE_COMMAND build $service

# Run docker-compose up -d in ~/reversebox
echo "Running $DOCKER_COMPOSE_COMMAND up -d in ~/reversebox..."
$DOCKER_COMPOSE_COMMAND up -d
