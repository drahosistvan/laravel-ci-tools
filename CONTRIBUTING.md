# Contributing to Laravel CI Tools

Thank you for your interest in contributing to Laravel CI Tools! This document provides guidelines for contributing to the project.

## Ways to Contribute

- **Bug Reports:** Report issues with existing images
- **Feature Requests:** Suggest new tools or improvements
- **CI/CD Examples:** Share templates for different platforms
- **Documentation:** Improve README and guides
- **Code:** Fix bugs or add features

## Adding New PHP or Node.js Versions

To add support for new PHP or Node.js versions:

1. Edit `.github/workflows/docker-build.yml`
2. Add the new version to the matrix in the `generate-matrix` job
3. Update the README.md with the new version
4. Test locally first:
   ```bash
   ./build.sh 8.5 20  # Example for PHP 8.5
   ```
5. Submit a pull request

## Adding New Tools

To add new tools to the Docker image:

1. Edit the `Dockerfile`
2. Add installation commands in the appropriate section
3. Test the build locally
4. Update the README with the new tool
5. Submit a pull request

Example:
```dockerfile
# Install new tool
RUN composer global require "vendor/package"
```

## Testing Changes

### Local Testing

Test your changes locally before submitting:

```bash
# Build a specific combination
./build/build.sh 8.3 20

# Test the image
docker run --rm drahosistvan/laravel-ci-tools:php8.3-node20 php -v
docker run --rm drahosistvan/laravel-ci-tools:php8.3-node20 node -v
docker run --rm drahosistvan/laravel-ci-tools:php8.3-node20 composer --version
```

### Pull Request Testing

When you submit a pull request:
- GitHub Actions will automatically build all images
- Images are built but NOT pushed to Docker Hub
- Check the Actions tab for build status

## Submitting Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test locally
5. Commit with clear messages: `git commit -m "Add feature X"`
6. Push to your fork: `git push origin feature/my-feature`
7. Open a pull request

## Code Style

- Use clear, descriptive comments
- Follow existing formatting in Dockerfile and scripts
- Keep changes focused and atomic

## Commit Message Guidelines

- Use present tense: "Add feature" not "Added feature"
- Use imperative mood: "Move cursor to..." not "Moves cursor to..."
- Start with a capital letter
- Keep first line under 72 characters
- Reference issues and pull requests when relevant

Examples:
```
Add support for PHP 8.5
Fix Node.js installation for version 27
Update README with new examples
```

## Questions?

Feel free to open an issue for any questions or discussions.

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
