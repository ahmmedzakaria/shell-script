#!/bin/bash
# =====================================================
# 🚀 Node.js, npm & Angular CLI 19.2.17 Installer
# Works on Ubuntu 22.04 / 24.04
# =====================================================

set -e  # Exit on error

echo "🔍 Checking for Node.js installation..."
if command -v node &> /dev/null; then
  echo "✅ Node.js is already installed (version $(node -v))"
else
  echo "📦 Installing Node.js (LTS v20) and npm..."
  sudo apt update -y
  sudo apt install -y curl
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt install -y nodejs
  echo "✅ Node.js installed successfully (version $(node -v))"
fi

echo "🔍 Checking for npm installation..."
if command -v npm &> /dev/null; then
  echo "✅ npm is already installed (version $(npm -v))"
else
  echo "⚙️ Installing npm..."
  sudo apt install -y npm
  echo "✅ npm installed successfully (version $(npm -v))"
fi

echo "🧱 Installing Angular CLI version 19.2.17..."
sudo npm install -g @angular/cli@19.2.17

echo "✅ Installation complete!"
echo "----------------------------------------"
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"
echo "Angular CLI version: $(ng version | grep 'Angular CLI')"
echo "----------------------------------------"
