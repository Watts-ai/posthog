# Dockerfile that extends PostHog image with compose scripts
ARG POSTHOG_IMAGE=posthog/posthog:latest
FROM ${POSTHOG_IMAGE}

# Copy compose scripts
COPY start /compose/start
COPY start-plugins /compose/start-plugins
COPY temporal-django-worker /compose/temporal-django-worker
COPY wait /compose/wait

# Make scripts executable
RUN chmod +x /compose/start /compose/start-plugins /compose/temporal-django-worker /compose/wait
RUN chmod +x /code/bin/docker-plugins /code/bin/plugin-server
