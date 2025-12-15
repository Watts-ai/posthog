#!/bin/bash

set -e
set -u

echo "Checking if database 'temporal' exists..."
DB_EXISTS=$(psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='temporal'")

if [ -z "$DB_EXISTS" ]; then
    echo "Creating database 'temporal'..."
    psql -U "$POSTGRES_USER" -c "CREATE DATABASE temporal;"
    
    # Create user if it doesn't exist
    USER_EXISTS=$(psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_roles WHERE rolname='temporal'")
    if [ -z "$USER_EXISTS" ]; then
        echo "Creating user 'temporal'..."
        psql -U "$POSTGRES_USER" -c "CREATE USER temporal WITH PASSWORD 'temporal';"
    fi
    
    psql -U "$POSTGRES_USER" -c "GRANT ALL PRIVILEGES ON DATABASE temporal TO temporal;"
    # Also grant to posthog user just in case
    psql -U "$POSTGRES_USER" -c "GRANT ALL PRIVILEGES ON DATABASE temporal TO $POSTGRES_USER;"
    
    echo "Database 'temporal' created successfully"
else
    echo "Database 'temporal' already exists"
fi
