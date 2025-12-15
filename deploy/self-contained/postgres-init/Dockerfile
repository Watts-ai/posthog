# Dockerfile for Postgres with embedded init scripts
FROM postgres:15.12-alpine

# Copy init scripts
COPY docker/postgres-init-scripts/ /docker-entrypoint-initdb.d/
COPY deploy/self-contained/postgres-init/scripts/ /docker-entrypoint-initdb.d/

# Ensure proper permissions
RUN chmod +x /docker-entrypoint-initdb.d/*.sh
