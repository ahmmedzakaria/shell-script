#!/bin/bash
set -e

# ===========================================
# 🚀 Bulk Import GeoJSON Files to PostgreSQL
# ===========================================

# 🔧 Database connection config
DB_HOST="localhost"
DB_PORT="5432"
DB_USER="postgres"
DB_PASS="123456"
DB_NAME="gisdb"
SCHEMA_NAME="public"

# 📁 Directory containing GeoJSON files
GEOJSON_DIR="./"  # change to your folder

# ===========================================
echo "🌍 Starting import of GeoJSON files from: $GEOJSON_DIR"
echo "➡️ Target database: $DB_NAME ($DB_USER@$DB_HOST:$DB_PORT)"
echo "=========================================="

export PGPASSWORD=$DB_PASS

# Loop through all GeoJSON files
for file in "$GEOJSON_DIR"/*.geojson; do
  [ -e "$file" ] || continue  # skip if no geojson files found

  # sanitize filename: lowercase + replace spaces/dashes with underscores
  base_name=$(basename "$file" .geojson)
  table_name=$(echo "$base_name" | tr '[:upper:]' '[:lower:]' | tr ' -' '__')

  echo ""
  echo "📄 Processing file: $file"
  echo "🔍 Target table: $SCHEMA_NAME.$table_name"

  TABLE_EXISTS=$(psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -tAc "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema='$SCHEMA_NAME' AND table_name='$table_name');")

  ogr_common_args=(
    -f "PostgreSQL"
    PG:"host=$DB_HOST user=$DB_USER password=$DB_PASS dbname=$DB_NAME port=$DB_PORT"
    "$file"
    -nln "$SCHEMA_NAME.$table_name"
    -nlt PROMOTE_TO_MULTI
    -lco GEOMETRY_NAME=geom
    -lco FID=gid
    -lco precision=NO
  )

  if [ "$TABLE_EXISTS" = "t" ]; then
    echo "⚠️  Table '$table_name' already exists."
    read -p "👉 Choose: [O]verride / [S]kip / [A]ppend : " choice

    case "$choice" in
      [Oo]* )
        echo "🧹 Overwriting existing table..."
        ogr2ogr "${ogr_common_args[@]}" -overwrite
        echo "✅ Table '$table_name' overwritten."
        ;;
      [Aa]* )
        echo "📎 Appending data to existing table..."
        ogr2ogr "${ogr_common_args[@]}" -append
        echo "✅ Data appended to '$table_name'."
        ;;
      [Ss]* )
        echo "⏭️ Skipped: $table_name"
        continue
        ;;
      * )
        echo "❌ Invalid option — skipping $table_name."
        continue
        ;;
    esac
  else
    echo "🆕 Creating and importing new table '$table_name'..."
    ogr2ogr "${ogr_common_args[@]}"
    echo "✅ Imported: $table_name"
  fi

  echo "------------------------------------------"
done

echo "🎉 All GeoJSON files processed successfully!"
