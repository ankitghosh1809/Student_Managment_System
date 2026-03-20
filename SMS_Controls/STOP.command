#!/bin/bash
clear
echo "=============================================="
echo "    STOPPING STUDENT MANAGEMENT SYSTEM"
echo "=============================================="
echo ""
TOMCAT="/Users/ankit_ghosh/tomcat"
echo "Stopping Tomcat..."
"$TOMCAT/bin/shutdown.sh" 2>/dev/null
sleep 2
PID=$(lsof -ti:8080)
if [ ! -z "$PID" ]; then
  kill -9 $PID 2>/dev/null
fi
echo "  Server stopped."
echo "=============================================="
echo ""
read -p "Press Enter to close..."
