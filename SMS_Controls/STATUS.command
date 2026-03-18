#!/bin/bash

clear
echo "=============================================="
echo "    STUDENT MANAGEMENT SYSTEM — STATUS"
echo "=============================================="
echo ""

# Check Java
echo "Java:"
if command -v java &>/dev/null; then
  echo "  INSTALLED — $(java -version 2>&1 | head -1)"
else
  echo "  NOT INSTALLED"
fi

echo ""

# Check MySQL
echo "MySQL:"
if command -v mysql &>/dev/null; then
  echo "  INSTALLED"
  DB=$(mysql -u root -p"" -e "SHOW DATABASES LIKE 'sms_db';" 2>/dev/null | grep sms_db || \
       mysql -u root -e "SHOW DATABASES LIKE 'sms_db';" 2>/dev/null | grep sms_db)
  if [ ! -z "$DB" ]; then
    echo "  Database sms_db: FOUND"
  else
    echo "  Database sms_db: NOT FOUND (will be imported on first run)"
  fi
else
  echo "  NOT INSTALLED"
fi

echo ""

# Check if server is running
echo "Web Server:"
PID=$(lsof -ti:8080)
if [ ! -z "$PID" ]; then
  echo "  RUNNING on port 8080"
  echo "  URL: http://localhost:8080/SMS/LoginServlet"
else
  echo "  NOT RUNNING (run START.command to start)"
fi

echo ""
echo "=============================================="
echo ""
read -p "Press Enter to close..."
