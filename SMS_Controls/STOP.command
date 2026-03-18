#!/bin/bash

clear
echo "=============================================="
echo "    STOPPING STUDENT MANAGEMENT SYSTEM"
echo "=============================================="
echo ""

TOMCAT="/Volumes/Hard Disk/StudentManagementSystem/tomcat"

echo "Stopping Tomcat..."
"$TOMCAT/bin/shutdown.sh" 2>/dev/null

sleep 2

# Force kill if still running
PID=$(lsof -ti:8080)
if [ ! -z "$PID" ]; then
  echo "Force stopping server..."
  kill -9 $PID 2>/dev/null
fi

echo ""
echo "  Server stopped successfully."
echo ""
echo "=============================================="
echo ""
read -p "Press Enter to close..."
