# Self-Contained PostHog Deployment

This directory contains a self-contained Docker Compose deployment for PostHog. Unlike the standard development setup, this stack uses custom-built images that include all necessary configuration files, schemas, and scripts embedded directly within them.

This makes deployment significantly easier as it removes the need for mounting local configuration files or managing complex volume mappings.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1.  **Navigate to the deployment directory:**

    ```bash
    cd deploy/self-contained
    ```

2.  **Configure environment (Optional):**

    Copy the example environment file and adjust as needed. The defaults work out-of-the-box for local testing.

    ```bash
    cp .env.example .env
    ```

    *   `SECRET_KEY`: Set a secure random string for production.
    *   `SITE_URL`: The URL where PostHog will be accessible (default: `http://localhost:8000`).
    *   `IMAGE_TAG`: The tag of the images to use (default: `latest`).

3.  **Start the stack:**

    ```bash
    docker compose up -d
    ```

    PostHog will be available at `http://localhost:8000` (or your configured `SITE_URL`).

## Architecture

This stack consists of the following services, all pulling from `ghcr.io/watts-ai/posthog-*`:

*   **web**: The main Django application (PostHog).
*   **worker**: Celery worker for background tasks.
*   **plugins**: Service for handling PostHog plugins.
*   **temporal**: Temporal server for workflow orchestration.
*   **clickhouse**: Analytics database with embedded configuration and schemas.
*   **db**: PostgreSQL database with embedded initialization scripts.
*   **redis**: Redis for caching and task queues.
*   **kafka**: Redpanda (Kafka compatible) for event streaming.
*   **capture**: High-performance event ingestion service (Rust).
*   **feature-flags**: Feature flag evaluation service (Rust).

## Building Images

If you want to build the images yourself (e.g., after modifying the source code), you can use the provided build script.

**Note:** The build script must be run from `deploy/self-contained/` but it uses the repository root as the build context.

```bash
./build-images.sh
```

This will build all images and tag them locally. You can then run `docker compose up -d` to use your locally built images.
