#!/bin/bash
set -e
HOST=${DB_HOST:-${MYSQLHOST:-localhost}}
PORT=${DB_PORT:-${MYSQLPORT:-3306}}
DBUSER=${DB_USER:-${MYSQLUSER:-root}}
PASS=${DB_PASS:-${MYSQLPASSWORD}}
echo "Waiting for MySQL @ $HOST:$PORT..."
until mysql -h "$HOST" -P "$PORT" -u "$DBUSER" "-p${PASS}" --connect-timeout=3 -e "SELECT 1" 2>/dev/null; do
  sleep 3
done
echo "MySQL ready. Running schema..."
mysql -h "$HOST" -P "$PORT" -u "$DBUSER" "-p${PASS}" < /schema.sql
echo "Schema OK."
exec catalina.sh run
