#!/bin/bash
set -e

echo "======================================"
echo "   🐳 Installing Docker on Ubuntu"
echo "======================================"

# Step 1: Update existing packages
echo "[1/7] Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Step 2: Remove old Docker versions (if any)
echo "[2/7] Removing old Docker versions (if any)..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Step 3: Install required dependencies
echo "[3/7] Installing dependencies..."
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https

# Step 4: Add Docker’s official GPG key
echo "[4/7] Adding Docker’s GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Step 5: Set up the Docker repository
echo "[5/7] Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 6: Install Docker Engine and Compose
echo "[6/7] Installing Docker Engine and Compose..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 7: Enable and start Docker
echo "[7/7] Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group
sudo usermod -aG docker $USER

# Verify installation
echo
echo "✅ Docker installation completed successfully!"
echo "--------------------------------------"
docker --version
docker compose version
echo
echo "To use Docker without 'sudo', please log out and back in (or run 'newgrp docker')."
echo "--------------------------------------"
