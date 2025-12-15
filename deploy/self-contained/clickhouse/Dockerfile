# Dockerfile for ClickHouse with embedded configuration
FROM clickhouse/clickhouse-server:25.8.12.129

# Copy configuration from source
COPY docker/clickhouse/config.xml /etc/clickhouse-server/config.xml
COPY docker/clickhouse/config.d/default.xml /etc/clickhouse-server/config.d/default.xml

# Use the custom users.xml from self-contained dir
COPY docker/clickhouse/users.xml /etc/clickhouse-server/users.xml

# Use the custom user_defined_function.xml from self-contained dir
COPY docker/clickhouse/user_defined_function.xml /etc/clickhouse-server/user_defined_function.xml

COPY docker/clickhouse/docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

# Copy IDL files
COPY posthog/idl/ /idl/

# Copy user scripts
COPY posthog/user_scripts/ /var/lib/clickhouse/user_scripts/

# Ensure proper permissions
RUN chmod +x /docker-entrypoint-initdb.d/*.sh || true
