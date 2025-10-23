#!/bin/bash
set -e

echo "======================================"
echo "   🚀 Installing AnyDesk on Ubuntu"
echo "======================================"

# Step 1: Update system
echo "[1/6] Updating system..."
sudo apt update -y && sudo apt upgrade -y

# Step 2: Import AnyDesk GPG key
echo "[2/6] Adding AnyDesk GPG key..."
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | gpg --dearmor | sudo tee /usr/share/keyrings/anydesk.gpg > /dev/null

# Step 3: Add AnyDesk repository
echo "[3/6] Adding AnyDesk repository..."
echo "deb [signed-by=/usr/share/keyrings/anydesk.gpg] http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list

# Step 4: Update package list
echo "[4/6] Updating repositories..."
sudo apt update -y

# Step 5: Install AnyDesk
echo "[5/6] Installing AnyDesk..."
sudo apt install anydesk -y

# Step 6: Enable and start AnyDesk service
echo "[6/6] Enabling AnyDesk service..."
sudo systemctl enable anydesk
sudo systemctl start anydesk

# Verify installation
echo
echo "✅ AnyDesk installation completed successfully!"
echo "--------------------------------------"
anydesk --version || echo "⚠️  AnyDesk version not detected — please check manually."
echo
echo "You can launch it from the app menu or run 'anydesk &' in terminal."
echo "--------------------------------------"
