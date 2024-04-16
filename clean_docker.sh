#!/bin/bash

# https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes

# Function to ask for confirmation before executing a command
ask_confirmation() {
    echo "$2"
    read -p "Do you want to execute this command? (yes/no): " answer
    case $answer in
        [Yy]* ) eval "$1";;
        * ) echo "Skipping...";;
    esac
}

# Command to clean up dangling resources
ask_confirmation "docker system prune" \
"---> Clean up any dangling resources (images, containers, volumes, and networks)."

# Command to additionally remove stopped containers and all unused images
ask_confirmation "docker system prune -a" \
"--->  Remove stopped containers and all unused images (not just dangling images)."

# Command to list all containers
# ask_confirmation "docker ps -a" \
# "List all containers, including stopped ones."

echo "---------------------------------------------------"
docker ps -a

# Command to remove containers (commented out to prevent accidental execution)
# ask_confirmation "docker rm ID_or_Name ID_or_Name"

# Command to stop and remove all containers
ask_confirmation "docker stop \$(docker ps -a -q)" \
"--->  Stop and remove all containers."

ask_confirmation "docker rm \$(docker ps -a -q)" \
"---> Remove all stopped containers."

# Command to list all images
# ask_confirmation "docker images" \
# "List all Docker images." 

echo "---------------------------------------------------"
docker images -a

# Command to remove dangling images
ask_confirmation "docker image prune" \
"---> Remove dangling (untagged) images."

# Command to remove all images
ask_confirmation "docker rmi \$(docker images -a -q)" \
"---> Remove all Docker images."

# Command to list all volumes
# ask_confirmation "docker volume ls" \
# "List all Docker volumes."
echo "---------------------------------------------------"
docker volume ls

# Command to remove volume (commented out to prevent accidental execution)
# ask_confirmation "docker volume rm volume_name volume_name"

# Command to remove all dangling volumes
ask_confirmation "docker volume prune" \
"---> Remove all dangling volumes."

# Command to remove all volumes
ask_confirmation "docker volume prune -a" \
"---> Remove all Docker volumes."
