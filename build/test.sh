#!/bin/bash

# Test script for Laravel CI Tools Docker images
# Usage: ./test.sh [php_version] [node_version]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PHP_VERSION=${1:-8.3}
NODE_VERSION=${2:-20}
IMAGE="drahosistvan/laravel-ci-tools:php${PHP_VERSION}-node${NODE_VERSION}"

echo -e "${GREEN}Testing Laravel CI Tools Docker Image${NC}"
echo -e "Image: ${YELLOW}${IMAGE}${NC}"
echo ""

# Test PHP
echo -e "${YELLOW}Testing PHP...${NC}"
docker run --rm ${IMAGE} php -v || { echo -e "${RED}✗ PHP test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ PHP working${NC}"
echo ""

# Test Node
echo -e "${YELLOW}Testing Node.js...${NC}"
docker run --rm ${IMAGE} node -v || { echo -e "${RED}✗ Node.js test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ Node.js working${NC}"
echo ""

# Test NPM
echo -e "${YELLOW}Testing NPM...${NC}"
docker run --rm ${IMAGE} npm -v || { echo -e "${RED}✗ NPM test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ NPM working${NC}"
echo ""

# Test Yarn
echo -e "${YELLOW}Testing Yarn...${NC}"
docker run --rm ${IMAGE} yarn -v || { echo -e "${RED}✗ Yarn test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ Yarn working${NC}"
echo ""

# Test Composer
echo -e "${YELLOW}Testing Composer...${NC}"
docker run --rm ${IMAGE} composer --version || { echo -e "${RED}✗ Composer test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ Composer working${NC}"
echo ""

# Test PHP Extensions
echo -e "${YELLOW}Testing PHP Extensions...${NC}"
REQUIRED_EXTENSIONS=("zip" "gd" "exif" "sodium" "mcrypt")
for ext in "${REQUIRED_EXTENSIONS[@]}"; do
    docker run --rm ${IMAGE} php -m | grep -i ${ext} > /dev/null || { echo -e "${RED}✗ PHP extension ${ext} not found${NC}"; exit 1; }
    echo -e "${GREEN}  ✓ ${ext}${NC}"
done
echo ""

# Test Envoy
echo -e "${YELLOW}Testing Laravel Envoy...${NC}"
docker run --rm ${IMAGE} sh -c "~/.composer/vendor/bin/envoy --version" || { echo -e "${RED}✗ Envoy test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ Laravel Envoy working${NC}"
echo ""

# Test Vapor CLI
echo -e "${YELLOW}Testing Laravel Vapor CLI...${NC}"
docker run --rm ${IMAGE} sh -c "~/.composer/vendor/bin/vapor --version" || { echo -e "${RED}✗ Vapor CLI test failed${NC}"; exit 1; }
echo -e "${GREEN}✓ Laravel Vapor CLI working${NC}"
echo ""

echo -e "${GREEN}✓✓✓ All tests passed! ✓✓✓${NC}"
echo ""
echo -e "Image ${YELLOW}${IMAGE}${NC} is ready to use!"
