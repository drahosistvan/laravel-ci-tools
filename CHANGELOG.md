# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-10-01

### Added
- Automated GitHub Actions workflow for building all PHP/Node combinations
- Support for PHP 8.1, 8.2, 8.3, 8.4
- Support for Node.js 20, 22, 24, 25, 26
- Multi-architecture support (amd64, arm64)
- Scheduled weekly rebuilds for security updates
- Comprehensive tagging strategy
- Local build scripts (build.sh, build-all.sh)
- Automated Docker Hub README updates

### Changed
- Dockerfile now uses build arguments for PHP and Node versions
- Updated README with comprehensive documentation
- Improved caching strategy for faster builds

### Deprecated
- Manual docker build commands (replaced by automated workflows)
