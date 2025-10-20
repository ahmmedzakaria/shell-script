#!/bin/bash
# ============================================================
# 🧠 Simple SQL Runner for PostgreSQL
# Usage: ./execute_sql_file.sh <sql_file> [database_name] [username] [host] [port]
# Example: ./execute_sql_file.sh update_admin_hierarchy.sql gisdb postgres localhost 5432
# ============================================================

# --- Default values ---
DB_NAME=${2:-gisdb}
DB_USER=${3:-postgres}
DB_HOST=${4:-localhost}
DB_PORT=${5:-5432}
SQL_FILE=$1

# --- Check file existence ---
if [ -z "$SQL_FILE" ]; then
    echo "❌ Error: No SQL file provided."
    echo "Usage: $0 <sql_file> [database_name] [username] [host] [port]"
    exit 1
fi

if [ ! -f "$SQL_FILE" ]; then
    echo "❌ Error: File '$SQL_FILE' not found!"
    exit 1
fi

# --- Ask for password securely ---
echo "🔑 Enter password for PostgreSQL user '$DB_USER':"
read -s PGPASSWORD

# --- Execute SQL file ---
echo "🚀 Running '$SQL_FILE' on database '$DB_NAME'..."
PGPASSWORD=$PGPASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -f "$SQL_FILE"

# --- Result ---
if [ $? -eq 0 ]; then
    echo "✅ SQL script executed successfully!"
else
    echo "❌ Error: SQL execution failed."
fi
