#!/bin/bash

clear
echo "=============================================="
echo "    STUDENT MANAGEMENT SYSTEM"
echo "=============================================="
echo ""

TOMCAT="/Users/ankit_ghosh/tomcat"

# ── STEP 1: Check Java ──────────────────────────
echo "[ 1/4 ] Checking Java..."
if ! command -v java &>/dev/null; then
  echo "  ERROR: Java not installed."
  read -p "Press Enter to exit..."
  exit 1
fi
echo "         Java found."

# ── STEP 2: Start MySQL ─────────────────────────
echo ""
echo "[ 2/4 ] Starting MySQL..."

# Try starting MySQL multiple ways
sudo /usr/local/mysql/support-files/mysql.server start 2>/dev/null
if [ $? -ne 0 ]; then
  # Try via launchctl
  sudo launchctl load /Library/LaunchDaemons/com.oracle.oss.mysql.mysqld.plist 2>/dev/null
fi

sleep 4

# Test if MySQL is actually running
if mysql -u root -padmin123 -e "SELECT 1;" &>/dev/null 2>&1; then
  echo "         MySQL is running."
else
  echo "         MySQL may need manual start."
  echo "         Go to: Apple Menu > System Settings > MySQL > Start"
  echo ""
  read -p "Press Enter once MySQL is started from System Settings..."
fi

# ── STEP 3: Stop any existing Tomcat ───────────
echo ""
echo "[ 3/4 ] Preparing Tomcat..."
PID=$(lsof -ti:8080)
if [ ! -z "$PID" ]; then
  echo "         Clearing port 8080..."
  kill -9 $PID 2>/dev/null
  sleep 2
fi

# ── STEP 4: Start Tomcat ────────────────────────
echo ""
echo "[ 4/4 ] Starting web server..."
chmod +x "$TOMCAT/bin/"*.sh 2>/dev/null
"$TOMCAT/bin/startup.sh" > /dev/null 2>&1
sleep 6

echo ""
echo "=============================================="
echo "  Opening browser..."
echo "=============================================="
echo ""
echo "  URL      : http://localhost:8080/SMS/LoginServlet"
echo "  Username : admin"
echo "  Password : admin123"
echo ""
echo "  Run STOP.command to stop the server."
echo "=============================================="

open "http://localhost:8080/SMS/LoginServlet"
