#!/bin/bash
set -e

echo "=============================="
echo "🚀 Redis + RedisInsight Installer for Ubuntu 24"
echo "=============================="

# --- Step 1: Update & upgrade ---
echo "📦 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# --- Step 2: Install Redis ---
echo "🧩 Installing Redis..."
sudo apt install redis-server -y

# --- Step 3: Configure Redis for systemd ---
echo "⚙️ Configuring Redis..."
sudo sed -i 's/^supervised .*/supervised systemd/' /etc/redis/redis.conf

# # Optional: set password (edit this variable if you want)
# REDIS_PASSWORD="changeme123"
# sudo sed -i "s/^# requirepass .*/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf

# Restart and enable Redis
sudo systemctl restart redis-server
sudo systemctl enable redis-server

# --- Step 4: Verify Redis installation ---
if systemctl is-active --quiet redis-server; then
    echo "✅ Redis is running successfully!"
else
    echo "❌ Redis installation failed."
    exit 1
fi

# --- Step 5: Install RedisInsight (Redis GUI) ---
echo "🖥️ Installing RedisInsight (GUI)..."

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd $TMP_DIR

# Download RedisInsight (official)
wget -q https://downloads.redisinsight.redis.com/latest/redisinsight-linux64.deb -O redisinsight.deb

# Install it
sudo apt install ./redisinsight.deb -y

# Clean up
cd ~
rm -rf $TMP_DIR

# --- Step 6: Post-install info ---
echo ""
echo "=============================="
echo "🎉 Installation Completed!"
echo "=============================="
echo "👉 Redis is running on port 6379"
echo "👉 Redis password: $REDIS_PASSWORD"
echo "👉 RedisInsight can be launched from your app menu or via:"
echo "   redisinsight"
echo ""
echo "To connect in RedisInsight:"
echo "  Host: 127.0.0.1"
echo "  Port: 6379"
echo "  Password: $REDIS_PASSWORD"
echo ""
echo "=============================="
echo "Done ✅"
