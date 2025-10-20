#!/bin/bash

# Variables - edit these as needed
DB_NAME="gisdb"
DB_USER="postgres"
PG_VERSION="15"  # Change this to your actual PostgreSQL version

# Update and install PostgreSQL + PostGIS
echo "Updating package list..."
sudo apt update

echo "Installing PostgreSQL and PostGIS..."
sudo apt install -y postgresql postgresql-contrib postgis postgresql-$PG_VERSION-postgis-3

# Start PostgreSQL service
echo "Starting PostgreSQL service..."
sudo service postgresql start

# Create the database
echo "Creating database: $DB_NAME..."
sudo -u postgres createdb $DB_NAME

# Enable PostGIS extensions in the database
echo "Enabling PostGIS extensions in $DB_NAME..."
sudo -u postgres psql -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS postgis;"
sudo -u postgres psql -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;"

# Verify installation
echo "Checking PostGIS version..."
sudo -u postgres psql -d $DB_NAME -c "SELECT PostGIS_Full_Version();"

echo "✅ PostGIS installation complete and enabled on database '$DB_NAME'"
