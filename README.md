# Laravel CI Tools

Docker images for building, testing, and deploying Laravel applications in CI/CD pipelines. Supports multiple PHP and Node.js version combinations with all essential Laravel tools pre-installed.

**Docker Hub:** [drahosistvan/laravel-ci-tools](https://hub.docker.com/r/drahosistvan/laravel-ci-tools)

## 🚀 Quick Start

```bash
# Pull the latest image
docker pull drahosistvan/laravel-ci-tools:latest

# Or use in your CI/CD pipeline
image: drahosistvan/laravel-ci-tools:php8.5-node24
```

## 📦 What's Included

- **PHP**: 8.2, 8.3, 8.4, 8.5
- **Node.js**: 24 (Active LTS), 25 (Latest)
- **Package Managers**: Composer (latest), NPM (bundled), Yarn (latest)
- **Laravel Tools**: Envoy, Vapor CLI
- **PHP Extensions**: zip, gd, exif, sodium, intl, bcmath, mcrypt
- **System Tools**: Git, rsync, SSH client

## 🏷️ Available Tags

### Latest (Newest Versions)
- `latest` → PHP 8.5 + Node 25

### PHP Version Tags (with Node 24, Active LTS)
- `php8` → PHP 8.5 + Node 24
- `php8.2` → PHP 8.2 + Node 24
- `php8.3` → PHP 8.3 + Node 24
- `php8.4` → PHP 8.4 + Node 24
- `php8.5` → PHP 8.5 + Node 24

### Node Version Tags (with PHP 8.5, Latest)
- `node24` → PHP 8.5 + Node 24
- `node25` → PHP 8.5 + Node 25

### Specific Combinations
Format: `php{VERSION}-node{VERSION}`

**All 8 combinations available:**
- PHP 8.2: `php8.2-node24`, `php8.2-node25`
- PHP 8.3: `php8.3-node24`, `php8.3-node25`
- PHP 8.4: `php8.4-node24`, `php8.4-node25`
- PHP 8.5: `php8.5-node24`, `php8.5-node25`

## 💻 Usage Examples

### GitLab CI/CD

```yaml
image: drahosistvan/laravel-ci-tools:php8.5-node24

stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - composer install --no-interaction --prefer-dist --optimize-autoloader
    - npm install
    - npm run build

test:
  stage: test
  script:
    - php artisan test

deploy:
  stage: deploy
  script:
    - ~/.composer/vendor/bin/vapor deploy production
  only:
    - main
```

### GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: drahosistvan/laravel-ci-tools:php8.5-node24
    steps:
      - uses: actions/checkout@v4
      
      - name: Install dependencies
        run: |
          composer install
          npm ci
      
      - name: Build assets
        run: npm run build
      
      - name: Run tests
        run: php artisan test
```

### Bitbucket Pipelines

```yaml
image: drahosistvan/laravel-ci-tools:php8.5-node24

pipelines:
  default:
    - step:
        name: Build and Test
        caches:
          - composer
          - node
        script:
          - composer install
          - npm ci
          - npm run build
          - php artisan test
```

## 🛠️ Local Development

### Pull and Use an Image

```bash
# Pull specific version
docker pull drahosistvan/laravel-ci-tools:php8.5-node24

# Run interactive shell
docker run -it --rm drahosistvan/laravel-ci-tools:latest bash

# Run specific commands
docker run --rm drahosistvan/laravel-ci-tools:latest php -v
docker run --rm drahosistvan/laravel-ci-tools:latest node -v
docker run --rm drahosistvan/laravel-ci-tools:latest composer --version
```

### Build Custom Image Locally

```bash
# Using the build script
./build/build.sh 8.5 24

# Or manually with Docker
docker build \
  --build-arg PHP_VERSION=8.5 \
  --build-arg NODE_VERSION=24 \
  -t laravel-ci-tools:php8.5-node24 \
  -f src/Dockerfile \
  .

# Build all combinations
./build/build-all.sh

# Build and push to Docker Hub
./build/build-all.sh --push
```

### Test an Image

```bash
# Test a specific combination
./build/test.sh 8.5 24
```

## 🔄 Automated Builds

All images are automatically rebuilt:

- ✅ **On push to main branch** - Triggered by code changes
- ✅ **On tagged releases** - Version-specific builds
- ✅ **Monthly schedule** - 1st of every month at 2 AM UTC for security updates
- ✅ **Manual dispatch** - On-demand builds via GitHub Actions

### Manual Workflow Trigger

1. Go to the repository's **Actions** tab
2. Select "Build and Push Docker Images"
3. Click **Run workflow**
4. Optionally specify PHP and Node versions
5. Click **Run workflow**

## 📊 Support Matrix

**Total Combinations:** 8 images (4 PHP × 2 Node.js versions)

| PHP  | Node 24 (Active LTS) | Node 25 (Latest) |
|------|----------------------|------------------|
| 8.2  | ✅                   | ✅               |
| 8.3  | ✅                   | ✅               |
| 8.4  | ✅                   | ✅               |
| 8.5  | ✅                   | ✅               |

## 📚 Examples

More CI/CD examples available in the `examples/` folder:

- **GitLab CI** - Laravel Vapor deployment
- **GitHub Actions** - Complete workflow with testing
- **Bitbucket Pipelines** - Pipeline configuration

## 🤝 Contributing

Contributions are welcome! You can help by:

- Adding new tools to the Docker image
- Providing CI/CD templates for other platforms
- Reporting issues or suggesting improvements
- Improving documentation

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This project is free and unencumbered software released into the public domain. See the [LICENSE](LICENSE) file for details.

---
