#!/bin/bash
set -e

# ── Parse DATABASE_URL (Neon format) or individual vars ──────────────────────
if [ -n "$DATABASE_URL" ]; then
    # DATABASE_URL = postgresql://user:pass@host:port/dbname?sslmode=require
    # Extract components for psql
    DB_PARSED="${DATABASE_URL#postgresql://}"
    DB_PARSED="${DB_PARSED#postgres://}"
    PGUSER="${DB_PARSED%%:*}"
    DB_PARSED="${DB_PARSED#*:}"
    PGPASSWORD="${DB_PARSED%%@*}"
    DB_PARSED="${DB_PARSED#*@}"
    PGHOST="${DB_PARSED%%/*}"
    # Handle port in host
    if echo "$PGHOST" | grep -q ":"; then
        PGPORT="${PGHOST##*:}"
        PGHOST="${PGHOST%%:*}"
    else
        PGPORT="5432"
    fi
    DB_PARSED="${DB_PARSED#*/}"
    PGDATABASE="${DB_PARSED%%\?*}"
    export PGPASSWORD
else
    PGHOST="${DB_HOST:-localhost}"
    PGPORT="${DB_PORT:-5432}"
    PGUSER="${DB_USER:-postgres}"
    PGPASSWORD="${DB_PASS}"
    PGDATABASE="${DB_NAME:-sms_db}"
    export PGPASSWORD
fi

echo "Waiting for PostgreSQL @ $PGHOST:$PGPORT..."
until psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" \
      --connect-timeout=5 -c "SELECT 1" > /dev/null 2>&1; do
    echo "  ...not ready yet, retrying in 3s"
    sleep 3
done

echo "PostgreSQL ready. Running schema..."
psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -f /schema.sql
echo "Schema OK."

exec catalina.sh run
