#!/bin/bash

# Build all combinations of Laravel CI Tools Docker images
# Usage: ./build-all.sh [--push]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOCKER_REPO="drahosistvan/laravel-ci-tools"
PUSH=false

# Check for --push flag
if [[ "$1" == "--push" ]]; then
    PUSH=true
    echo -e "${YELLOW}Push mode enabled - images will be pushed to Docker Hub${NC}"
    echo ""
fi

# Define versions
PHP_VERSIONS=("8.1" "8.2" "8.3" "8.4")
NODE_VERSIONS=("20" "22" "24")

# Calculate total combinations
TOTAL=$((${#PHP_VERSIONS[@]} * ${#NODE_VERSIONS[@]}))
CURRENT=0

echo -e "${GREEN}Building ${TOTAL} Docker image combinations${NC}"
echo ""

# Build each combination
for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
    for NODE_VERSION in "${NODE_VERSIONS[@]}"; do
        CURRENT=$((CURRENT + 1))
        echo -e "${BLUE}[${CURRENT}/${TOTAL}] Building PHP ${PHP_VERSION} + Node ${NODE_VERSION}${NC}"

        # Build the image
        docker build \
            --build-arg PHP_VERSION=${PHP_VERSION} \
            --build-arg NODE_VERSION=${NODE_VERSION} \
            -t ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} \
            -f src/Dockerfile \
            . \
            || { echo -e "${RED}✗ Build failed for PHP ${PHP_VERSION} + Node ${NODE_VERSION}${NC}"; exit 1; }

        # Add convenience tags for specific combinations
        if [[ "$PHP_VERSION" == "8.4" ]] && [[ "$NODE_VERSION" == "24" ]]; then
            docker tag ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} ${DOCKER_REPO}:latest
            echo -e "${GREEN}  Tagged as: latest${NC}"
        fi

        # PHP version tags (with Node 20)
        if [[ "$NODE_VERSION" == "20" ]]; then
            PHP_MAJOR=$(echo $PHP_VERSION | cut -d. -f1)
            docker tag ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} ${DOCKER_REPO}:php${PHP_MAJOR}
            docker tag ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} ${DOCKER_REPO}:php${PHP_VERSION}
            echo -e "${GREEN}  Tagged as: php${PHP_MAJOR}, php${PHP_VERSION}${NC}"
        fi

        # Node version tags (with PHP 8.3)
        if [[ "$PHP_VERSION" == "8.3" ]]; then
            docker tag ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION} ${DOCKER_REPO}:node${NODE_VERSION}
            echo -e "${GREEN}  Tagged as: node${NODE_VERSION}${NC}"
        fi

        # Push if requested
        if [[ "$PUSH" == true ]]; then
            echo -e "${YELLOW}  Pushing images...${NC}"
            docker push ${DOCKER_REPO}:php${PHP_VERSION}-node${NODE_VERSION}

            if [[ "$PHP_VERSION" == "8.4" ]] && [[ "$NODE_VERSION" == "24" ]]; then
                docker push ${DOCKER_REPO}:latest
            fi

            if [[ "$NODE_VERSION" == "20" ]]; then
                PHP_MAJOR=$(echo $PHP_VERSION | cut -d. -f1)
                docker push ${DOCKER_REPO}:php${PHP_MAJOR}
                docker push ${DOCKER_REPO}:php${PHP_VERSION}
            fi

            if [[ "$PHP_VERSION" == "8.3" ]]; then
                docker push ${DOCKER_REPO}:node${NODE_VERSION}
            fi
        fi

        echo ""
    done
done

echo -e "${GREEN}✓ All ${TOTAL} images built successfully!${NC}"
echo ""

if [[ "$PUSH" == false ]]; then
    echo -e "${YELLOW}To push images to Docker Hub, run:${NC}"
    echo "  ./build-all.sh --push"
    echo ""
fi

echo -e "${BLUE}Available tags:${NC}"
docker images ${DOCKER_REPO} --format "table {{.Tag}}\t{{.Size}}\t{{.CreatedAt}}" | head -n 30
