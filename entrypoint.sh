#!/bin/bash
set -e

echo "Running schema against Neon..."
psql "$DATABASE_URL" -f /schema.sql
echo "Schema OK."

exec catalina.sh run
