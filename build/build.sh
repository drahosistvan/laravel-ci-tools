#!/bin/bash

# Build script for laravel-ci-tools Docker images
# Usage: ./build.sh [php_version] [node_version] [--push]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PHP_VERSION=${1:-8.3}
NODE_VERSION=${2:-20}
DOCKER_REPO="drahosistvan/laravel-ci-tools"
PUSH=false

# Check for --push flag in any position
for arg in "$@"; do
    if [[ "$arg" == "--push" ]]; then
        PUSH=true
    fi
done

echo -e "${GREEN}Building Laravel CI Tools Docker Image${NC}"
echo -e "PHP Version: ${YELLOW}${PHP_VERSION}${NC}"
echo -e "Node Version: ${YELLOW}${NODE_VERSION}${NC}"
if [[ "$PUSH" == true ]]; then
    echo -e "Push mode: ${YELLOW}enabled${NC}"
fi
echo ""

# Build the image
echo -e "${GREEN}Building image...${NC}"
docker build \
  --build-arg PHP_VERSION=${PHP_VERSION} \
  --build-arg NODE_VERSION=${NODE_VERSION} \
  -t ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} \
  -f src/Dockerfile \
  .

echo ""
echo -e "${GREEN}✓ Build complete!${NC}"
echo ""
echo -e "Image tagged as: ${YELLOW}${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION}${NC}"
echo ""

# Push if requested
if [[ "$PUSH" == true ]]; then
    echo -e "${YELLOW}Pushing image to Docker Hub...${NC}"
    docker push ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION}
    echo -e "${GREEN}✓ Image pushed successfully!${NC}"
    echo ""
else
    echo "To test the image:"
    echo "  docker run --rm ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} php -v"
    echo "  docker run --rm ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} node -v"
    echo ""
    echo -e "${YELLOW}To push to Docker Hub, run:${NC}"
    echo "  ./build.sh ${PHP_VERSION} ${NODE_VERSION} --push"
    echo ""
fi
