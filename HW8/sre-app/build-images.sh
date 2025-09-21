#!/bin/bash

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Переменные
REGISTRY="kirillshakh"
FLASK_IMAGE_NAME="sre-app-flask"
GO_IMAGE_NAME="sre-app-go"
TAG="${1:-latest}"

log "Building Docker images with tag: $TAG"

# Сборка Flask образа
log "Building Flask application image..."
docker build -t $REGISTRY/$FLASK_IMAGE_NAME:$TAG -f flask-app/Dockerfile flask-app/

if [ $? -eq 0 ]; then
    log "Flask image built successfully: $REGISTRY/$FLASK_IMAGE_NAME:$TAG"
else
    error "Failed to build Flask image"
    exit 1
fi

# Сборка Go образа
log "Building Go application image..."
docker build -t $REGISTRY/$GO_IMAGE_NAME:$TAG -f go-app/Dockerfile go-app/

if [ $? -eq 0 ]; then
    log "Go image built successfully: $REGISTRY/$GO_IMAGE_NAME:$TAG"
else
    error "Failed to build Go image"
    exit 1
fi

# Push образов (опционально)
if [ "$2" == "push" ]; then
    log "Pushing images to registry..."
    
    # Логин в registry (если нужно)
    # docker login ghcr.io
    
    docker push $REGISTRY/$FLASK_IMAGE_NAME:$TAG
    docker push $REGISTRY/$GO_IMAGE_NAME:$TAG
    
    log "Images pushed successfully"
fi

log "Build completed successfully!"
echo "Images:"
echo "  Flask: $REGISTRY/$FLASK_IMAGE_NAME:$TAG"
echo "  Go:    $REGISTRY/$GO_IMAGE_NAME:$TAG"
