#!/bin/bash

# ============================================================
#   STUDENT MANAGEMENT SYSTEM — ONE CLICK LAUNCHER
# ============================================================

clear
echo "=============================================="
echo "    STUDENT MANAGEMENT SYSTEM"
echo "=============================================="
echo ""

DISK="/Volumes/Hard Disk/StudentManagementSystem"
TOMCAT="$DISK/tomcat"

# ── STEP 1: Check Java ──────────────────────────
echo "[ 1/5 ] Checking Java..."
if ! command -v java &>/dev/null; then
  echo ""
  echo "  ERROR: Java is not installed."
  echo "  Please install Java from:"
  echo "  https://www.oracle.com/java/technologies/downloads/"
  echo ""
  read -p "Press Enter to exit..."
  exit 1
fi
echo "         Java found: $(java -version 2>&1 | head -1)"

# ── STEP 2: Start MySQL ─────────────────────────
echo ""
echo "[ 2/5 ] Starting MySQL..."

# Try different MySQL locations
if [ -f /usr/local/mysql/support-files/mysql.server ]; then
  sudo /usr/local/mysql/support-files/mysql.server start 2>/dev/null
elif [ -f /opt/homebrew/bin/mysql ]; then
  brew services start mysql 2>/dev/null
elif command -v mysqld &>/dev/null; then
  sudo mysqld_safe &>/dev/null &
fi

sleep 3

# Check if MySQL is running
if mysql -u root -p"" -e "SELECT 1;" &>/dev/null 2>&1 || \
   mysql -u root -e "SELECT 1;" &>/dev/null 2>&1; then
  echo "         MySQL is running."
else
  echo "         MySQL started (enter password if prompted)."
fi

# ── STEP 3: Check Database ──────────────────────
echo ""
echo "[ 3/5 ] Checking database..."

DB_EXISTS=$(mysql -u root -p"" -e "SHOW DATABASES LIKE 'sms_db';" 2>/dev/null | grep sms_db || \
            mysql -u root -e "SHOW DATABASES LIKE 'sms_db';" 2>/dev/null | grep sms_db)

if [ -z "$DB_EXISTS" ]; then
  echo "         Database not found. Importing now..."
  echo "         (Enter your MySQL root password when asked)"
  mysql -u root -p < "$DISK/sms_db_backup.sql"
  if [ $? -eq 0 ]; then
    echo "         Database imported successfully."
  else
    echo ""
    echo "  WARNING: Could not import database automatically."
    echo "  Please run this manually:"
    echo "  mysql -u root -p < \"$DISK/sms_db_backup.sql\""
    echo ""
  fi
else
  echo "         Database sms_db found and ready."
fi

# ── STEP 4: Stop any existing Tomcat ───────────
echo ""
echo "[ 4/5 ] Preparing Tomcat..."

# Kill any running Tomcat on port 8080
PID=$(lsof -ti:8080)
if [ ! -z "$PID" ]; then
  echo "         Stopping existing server on port 8080..."
  kill -9 $PID 2>/dev/null
  sleep 2
fi

# Set permissions
chmod +x "$TOMCAT/bin/"*.sh 2>/dev/null

# ── STEP 5: Start Tomcat ────────────────────────
echo ""
echo "[ 5/5 ] Starting web server..."
export CATALINA_HOME="$TOMCAT"
export CATALINA_BASE="$TOMCAT"
"$TOMCAT/bin/startup.sh" > /dev/null 2>&1

echo ""
echo "         Waiting for server to start..."
sleep 6

# ── Check if server started ─────────────────────
HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/SMS/LoginServlet 2>/dev/null)

echo ""
echo "=============================================="
if [ "$HTTP" = "200" ] || [ "$HTTP" = "302" ]; then
  echo "  SUCCESS! Website is running."
  echo "=============================================="
  echo ""
  echo "  URL      : http://localhost:8080/SMS/LoginServlet"
  echo "  Username : admin"
  echo "  Password : admin123"
  echo ""
  echo "  Opening in browser..."
  open "http://localhost:8080/SMS/LoginServlet"
else
  echo "  Website started. Opening browser..."
  echo "=============================================="
  echo ""
  echo "  URL      : http://localhost:8080/SMS/LoginServlet"
  echo "  Username : admin"
  echo "  Password : admin123"
  echo ""
  open "http://localhost:8080/SMS/LoginServlet"
fi

echo ""
echo "  To STOP the server, run STOP.command"
echo "  or close this window and run:"
echo "  $TOMCAT/bin/shutdown.sh"
echo ""
echo "=============================================="
echo ""
echo "  Press Ctrl+C to stop watching logs"
echo "  (Server keeps running even if you close this)"
echo ""

# Show live logs
tail -f "$TOMCAT/logs/catalina.out"
