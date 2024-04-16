#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install Git before running this script."
    exit 1
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker before running this script."
    exit 1
fi

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/hunwalk/reversebox ~/reversebox

# Check if .bash_aliases exists
if [ -f ~/.bash_aliases ]; then
    # Append contents of .bash_aliases from repo to ~/.bash_aliases
    echo "Appending .bash_aliases from repository to ~/.bash_aliases..."
    cat ~/reversebox/.bash_aliases >> ~/.bash_aliases
else
    # Create .bash_aliases and copy contents from repo
    echo "Creating .bash_aliases and copying from repository..."
    cp ~/reversebox/.bash_aliases ~/.bash_aliases
fi

# Create ~/.local/bin folder if it does not exist
mkdir -p ~/.local/bin

# Copy contents of bin folder from repo to ~/.local/bin
echo "Copying contents of bin folder to ~/.local/bin..."
cp -r ~/reversebox/bin/* ~/.local/bin/

# Copy .env.file contents to .env
echo "Copying .env.file contents to .env..."
cp ~/reversebox/.env.file ~/reversebox/.env

# Get directory route to ~ and update HOME_MOUNT in .env file
echo "Updating HOME_MOUNT in .env file..."
HOME_MOUNT=$(realpath ~)
if grep -q "^HOME_MOUNT=" ~/reversebox/.env; then
    sed -i "s|^HOME_MOUNT=.*|HOME_MOUNT=$HOME_MOUNT|" ~/reversebox/.env
else
    echo "HOME_MOUNT=$HOME_MOUNT" >> ~/reversebox/.env
fi

# Source .bash_aliases
echo "Sourcing .bash_aliases..."
source ~/.bash_aliases

# Run docker-compose up -d inside ~/reversebox
echo "Running docker-compose up -d inside ~/reversebox..."
cd ~/reversebox && docker-compose up -d