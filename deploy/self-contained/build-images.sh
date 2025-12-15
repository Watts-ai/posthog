#!/bin/bash
set -e

# Script to build all self-contained PostHog images
# These images can then be pushed to ghcr.io/watts-ai/posthog-*

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Building self-contained PostHog images..."
echo "Repository root: $REPO_ROOT"

# Set image tag (default to 'latest' if not provided)
IMAGE_TAG="${IMAGE_TAG:-latest}"
POSTHOG_BASE_TAG="${POSTHOG_BASE_TAG:-latest}"
REGISTRY="${REGISTRY:-ghcr.io/watts-ai}"

echo "Using tag: $IMAGE_TAG"
echo "Using registry: $REGISTRY"

# 1. Build ClickHouse image
echo ""
echo "==> Building ClickHouse image..."
docker build \
  -f "$SCRIPT_DIR/clickhouse/Dockerfile" \
  -t "$REGISTRY/posthog-clickhouse:$IMAGE_TAG" \
  "$REPO_ROOT"
echo "✓ ClickHouse image built: $REGISTRY/posthog-clickhouse:$IMAGE_TAG"

# 2. Build Temporal image
echo ""
echo "==> Building Temporal image..."
docker build \
  -f "$SCRIPT_DIR/temporal/Dockerfile" \
  -t "$REGISTRY/posthog-temporal:$IMAGE_TAG" \
  "$REPO_ROOT"
echo "✓ Temporal image built: $REGISTRY/posthog-temporal:$IMAGE_TAG"

# 3. Build Postgres image
echo ""
echo "==> Building Postgres image..."
docker build \
  -f "$SCRIPT_DIR/postgres-init/Dockerfile" \
  -t "$REGISTRY/posthog-postgres:$IMAGE_TAG" \
  "$REPO_ROOT"
echo "✓ Postgres image built: $REGISTRY/posthog-postgres:$IMAGE_TAG"

# 4. Build PostHog image with embedded compose scripts
echo ""
echo "==> Building PostHog web image..."
# This one uses the directory as context directly as it only depends on files in it
docker build \
  --build-arg POSTHOG_IMAGE="posthog/posthog:$POSTHOG_BASE_TAG" \
  -t "$REGISTRY/posthog:$IMAGE_TAG" \
  "$SCRIPT_DIR/compose-scripts"
echo "✓ PostHog web image built: $REGISTRY/posthog:$IMAGE_TAG"

# 5. Build Rust services (using existing build contexts)
echo ""
echo "==> Building Rust services..."

# These services are built from the rust/ directory in the main repo
RUST_SERVICES=(
  "capture"
  "property-defs-rs"
  "feature-flags"
  "cyclotron-janitor"
  "cymbal"
)

for service in "${RUST_SERVICES[@]}"; do
  echo "Building $service..."
  docker build \
    -f "$REPO_ROOT/rust/Dockerfile" \
    --build-arg BIN="$service" \
    -t "$REGISTRY/posthog-$service:$IMAGE_TAG" \
    "$REPO_ROOT/rust"
  echo "✓ $service image built: $REGISTRY/posthog-$service:$IMAGE_TAG"
done

# Build livestream image
echo ""
echo "==> Building Livestream image..."
docker build \
  -f "$REPO_ROOT/livestream/Dockerfile" \
  -t "$REGISTRY/posthog-livestream:$IMAGE_TAG" \
  "$REPO_ROOT/livestream"
echo "✓ Livestream image built: $REGISTRY/posthog-livestream:$IMAGE_TAG"
