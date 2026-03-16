# Docker Notes

Basic Docker commands used during this project.

## docker build

Builds a container image.

Example:
docker build -t log-analyzer .

## docker run

Runs a container from an image.

Example:
docker run -p 8000:8000 log-analyzer

## docker ps

Shows running containers.

Example:
docker ps

## docker stop

Stops a running container.

Example:
docker stop container_id
