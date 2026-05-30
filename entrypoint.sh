#!/bin/bash
set -e

if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL environment variable is not set."
    echo "Set it in Render → Environment → DATABASE_URL"
    exit 1
fi

echo "DATABASE_URL is set. Running schema against Neon..."
psql "$DATABASE_URL" -f /schema.sql && echo "Schema OK." || echo "Schema already exists or warning — continuing."

exec catalina.sh run
