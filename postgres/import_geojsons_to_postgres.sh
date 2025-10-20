#!/bin/bash
set -e

# ===========================================
# 🚀 Bulk Import GeoJSON Files to PostgreSQL
# ===========================================

# 🔧 Database connection config
DB_HOST="localhost"
DB_PORT="5432"
DB_USER="postgres"
DB_PASS="123"
DB_NAME="gisdb"

# 📁 Directory containing GeoJSON files
GEOJSON_DIR="../gis/administrative"

# 🧭 Optional schema (leave empty to use 'public')
SCHEMA_NAME="public"

# ===========================================
echo "🌍 Starting import of GeoJSON files from: $GEOJSON_DIR"
echo "➡️ Target database: $DB_NAME ($DB_USER@$DB_HOST:$DB_PORT)"
echo "=========================================="

# Export password for non-interactive mode
export PGPASSWORD=$DB_PASS

# Loop through all GeoJSON files
for file in "$GEOJSON_DIR"/*.geojson; do
  if [ -f "$file" ]; then
    # Derive table name from filename (remove extension and path)
    table_name=$(basename "$file" .geojson | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

    echo "📥 Importing: $file → Table: $table_name"

    ogr2ogr -f "PostgreSQL" \
      PG:"host=$DB_HOST user=$DB_USER password=$DB_PASS dbname=$DB_NAME port=$DB_PORT" \
      "$file" \
      -nln "$SCHEMA_NAME.$table_name" \
      -nlt PROMOTE_TO_MULTI \
      -lco GEOMETRY_NAME=geom \
      -lco FID=gid \
      -lco precision=NO \
      -overwrite

    echo "✅ Imported: $table_name"
    echo "------------------------------------------"
  fi
done

echo "🎉 All GeoJSON files imported successfully!"
