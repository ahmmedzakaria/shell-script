#!/bin/bash
set -e

echo "==============================================="
echo " 🚀 Installing RabbitMQ Server on Ubuntu 24.04 "
echo "==============================================="

# Step 1: Clean old installations
echo "🧹 Removing old RabbitMQ & Erlang packages..."
sudo apt remove --purge -y rabbitmq-server erlang* || true
sudo apt autoremove -y
sudo apt update -y

# Step 2: Install prerequisites
echo "📦 Installing dependencies..."
sudo apt install -y curl gnupg apt-transport-https lsb-release

# Step 3: Import signing keys
echo "🔑 Adding GPG keys for Erlang and RabbitMQ..."
curl -1sLf 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x69475BA0DFB692E6' \
  | sudo gpg --dearmor -o /usr/share/keyrings/com.rabbitmq.team.gpg

curl -1sLf 'https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey' \
  | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq.gpg

# Step 4: Add repositories
echo "🗂️ Adding official RabbitMQ and Erlang repositories..."
echo "deb [signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-erlang/deb/ubuntu noble main" \
  | sudo tee /etc/apt/sources.list.d/rabbitmq-erlang.list > /dev/null

echo "deb [signed-by=/usr/share/keyrings/rabbitmq.gpg] https://ppa1.novemberain.com/rabbitmq/rabbitmq-server/deb/ubuntu noble main" \
  | sudo tee /etc/apt/sources.list.d/rabbitmq.list > /dev/null

# Step 5: Update package list
sudo apt update -y

# Step 6: Install Erlang & RabbitMQ
echo "⚙️ Installing Erlang and RabbitMQ..."
sudo apt install -y erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-inets \
erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key erlang-runtime-tools \
erlang-ssl erlang-syntax-tools erlang-tools erlang-xmerl rabbitmq-server

# Step 7: Enable and start service
echo "🔁 Enabling and starting RabbitMQ service..."
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# Step 8: Enable management dashboard
echo "📊 Enabling RabbitMQ Management Plugin..."
sudo rabbitmq-plugins enable rabbitmq_management

# Step 9: Display access info
echo "✅ RabbitMQ installation complete!"
echo ""
echo "-----------------------------------------------"
echo " 🌐 Management Dashboard: http://localhost:15672"
echo " 👤 Username: guest"
echo " 🔒 Password: guest"
echo "-----------------------------------------------"
echo ""
sudo systemctl status rabbitmq-server --no-pager
