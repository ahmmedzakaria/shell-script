#!/bin/bash
set -e

echo "======================================"
echo "🐳 Installing Docker Desktop for Ubuntu"
echo "======================================"

# Step 1: Update system
echo "[1/7] Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Step 2: Install dependencies
echo "[2/7] Installing required dependencies..."
sudo apt install -y ca-certificates curl gnupg apt-transport-https software-properties-common lsb-release

# Step 3: Install Docker Engine (Docker Desktop depends on it)
echo "[3/7] Installing Docker Engine..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 4: Download the latest Docker Desktop .deb package
echo "[4/7] Downloading latest Docker Desktop..."
DOWNLOAD_URL=$(curl -fsSL https://desktop.docker.com/linux/main/amd64/appcast.xml | grep -oPm1 "(?<=<enclosure url=\")[^\"]+")
wget -O docker-desktop.deb "$DOWNLOAD_URL"

# Step 5: Install Docker Desktop
echo "[5/7] Installing Docker Desktop..."
sudo apt install -y ./docker-desktop.deb

# Step 6: Enable Docker Desktop service for user
echo "[6/7] Enabling Docker Desktop services..."
systemctl --user enable docker-desktop || true

# Add user to docker group
sudo usermod -aG docker $USER

# Step 7: Clean up and finish
rm -f docker-desktop.deb
echo
echo "======================================"
echo "✅ Docker Desktop installation complete!"
echo "--------------------------------------"
docker --version
echo
echo "🌐 To start Docker Desktop, run:"
echo "   systemctl --user start docker-desktop"
echo "or open it from your App Launcher → 'Docker Desktop'"
echo
echo "⚠️ You may need to reboot once before first launch:"
echo "   sudo reboot"
echo "======================================"
