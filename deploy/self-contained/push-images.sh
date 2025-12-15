#!/bin/bash
set -e

# Script to push all self-contained PostHog images to the registry

IMAGE_TAG="${IMAGE_TAG:-latest}"
REGISTRY="${REGISTRY:-ghcr.io/watts-ai}"

echo "Pushing images with tag: $IMAGE_TAG to registry: $REGISTRY"

IMAGES=(
  "posthog"
  "posthog-clickhouse"
  "posthog-temporal"
  "posthog-postgres"
  "posthog-geoip"
  "posthog-capture"
  "posthog-property-defs-rs"
  "posthog-feature-flags"
  "posthog-cyclotron-janitor"
  "posthog-cymbal"
  "posthog-livestream"
)

for image in "${IMAGES[@]}"; do
  echo "Pushing $REGISTRY/$image:$IMAGE_TAG..."
  docker push "$REGISTRY/$image:$IMAGE_TAG"
  echo "✓ Pushed $image"
done

echo ""
echo "==> All images pushed successfully!"
