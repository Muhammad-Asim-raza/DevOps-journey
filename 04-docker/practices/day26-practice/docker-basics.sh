#!/bin/bash
# ================================================
# docker-basics.sh
# Docker Fundamentals Reference
# Author: Asim Raza
# Day 26 of DevOps Journey
# ================================================

echo "============================================"
echo "   DOCKER FUNDAMENTALS REFERENCE"
echo "   Author: Asim Raza - Day 26"
echo "============================================"

echo ""
echo "[ DOCKER SYSTEM INFO ]"
docker --version
docker info 2>/dev/null | \
    grep -E "Version|Containers|Images|OS|Arch" | \
    sed 's/^/  /'

echo ""
echo "[ IMAGES COMMANDS ]"
echo "  docker images              = list all images"
echo "  docker pull image:tag      = download image"
echo "  docker rmi image:tag       = remove image"
echo "  docker image prune -a      = remove unused"
echo "  docker history image       = see layers"
echo "  docker inspect image       = detailed info"
echo "  docker search term         = search Docker Hub"

echo ""
echo "[ CONTAINER COMMANDS ]"
echo "  docker run image           = create + start"
echo "  docker run -d image        = run in background"
echo "  docker run -it image bash  = interactive"
echo "  docker run --name X image  = with name"
echo "  docker run -p H:C image    = port mapping"
echo "  docker run -v H:C image    = volume mount"
echo "  docker run -e VAR=val img  = environment var"
echo "  docker ps                  = running containers"
echo "  docker ps -a               = all containers"
echo "  docker stop container      = graceful stop"
echo "  docker start container     = start stopped"
echo "  docker restart container   = stop + start"
echo "  docker rm container        = remove container"
echo "  docker rm -f container     = force remove"
echo "  docker exec -it X bash     = exec in container"
echo "  docker logs container      = view logs"
echo "  docker logs -f container   = follow logs"

echo ""
echo "[ SYSTEM COMMANDS ]"
echo "  docker system df           = disk usage"
echo "  docker system prune -a     = remove all unused"
echo "  docker container prune     = remove stopped"
echo "  docker image prune -a      = remove unused imgs"

echo ""
echo "[ KEY CONCEPTS ]"
echo "  Image = read-only template (recipe)"
echo "  Container = running instance (meal)"
echo "  Registry = storage for images (Docker Hub)"
echo "  Dockerfile = instructions to build image"
echo "  Layer = each instruction creates a layer"
echo "  Volume = persistent storage"
echo "  Network = container communication"
echo "  Tag = version label for image"

echo ""
echo "[ CURRENT STATUS ]"
echo "  Running containers: $(docker ps -q 2>/dev/null | wc -l)"
echo "  All containers: $(docker ps -aq 2>/dev/null | wc -l)"
echo "  Local images: $(docker images -q 2>/dev/null | wc -l)"
echo "  Disk usage:"
docker system df 2>/dev/null | tail -4 | sed 's/^/  /'

echo ""
echo "[ IMAGE NAMING FORMAT ]"
echo "  nginx                = official latest"
echo "  nginx:1.25           = official specific"
echo "  nginx:alpine         = alpine variant (tiny)"
echo "  python:3.11-slim     = slim variant"
echo "  username/myapp:v1.0  = your image on Hub"
echo "  registry/repo:tag    = private registry"

echo ""
echo "============================================"
echo "   REFERENCE COMPLETE"
echo "============================================"
