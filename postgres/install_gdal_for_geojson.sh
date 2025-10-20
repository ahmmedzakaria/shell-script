#!/bin/bash

# Simple GDAL installer for Ubuntu

echo "📦 Updating package lists..."
sudo apt update

echo "🔧 Installing gdal-bin..."
sudo apt install -y gdal-bin

# Optional: install additional bindings (e.g., Python support)
# sudo apt install -y python3-gdal

# Verify installation
if command -v ogr2ogr &> /dev/null; then
    echo "✅ GDAL installed successfully!"
    echo "📌 Version:"
    ogr2ogr --version
else
    echo "❌ GDAL installation failed."
    exit 1
fi
