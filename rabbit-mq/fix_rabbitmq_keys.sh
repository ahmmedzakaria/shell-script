#!/bin/bash
set -e

echo "🧹 Cleaning up old RabbitMQ and Erlang setup..."

# Remove old keys and repos
sudo rm -f /etc/apt/sources.list.d/rabbitmq*.list /etc/apt/sources.list.d/erlang*.list
sudo rm -f /usr/share/keyrings/rabbitmq.gpg /usr/share/keyrings/erlang.gpg
sudo apt-key del E495BB49CC4BBE5B 2>/dev/null || true
sudo apt-key del 9F4587F226208342 2>/dev/null || true

# --- Add trusted keys ---
echo "🔑 Adding trusted keys..."
curl -fsSL https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/rabbitmq.gpg
curl -fsSL https://packagecloud.io/rabbitmq/erlang/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/erlang.gpg

# --- Use Jammy (22.04) repo for Erlang (works on 24.04 too) ---
echo "📦 Adding RabbitMQ + Erlang repositories..."
echo "deb [signed-by=/usr/share/keyrings/erlang.gpg] https://packagecloud.io/rabbitmq/erlang/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list.d/erlang.list
echo "deb [signed-by=/usr/share/keyrings/rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list

# --- Update + install ---
echo "⚙️ Updating apt and installing dependencies..."
sudo apt update -y
sudo apt install -y curl gnupg apt-transport-https lsb-release ca-certificates
sudo apt install -y erlang-base erlang-ssl erlang-public-key erlang-crypto rabbitmq-server

# --- Enable & start RabbitMQ ---
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# --- Optional: enable management UI ---
sudo rabbitmq-plugins enable rabbitmq_management

echo "✅ RabbitMQ installed successfully!"
echo "🌐 Access management UI: http://localhost:15672 (default user/pass: guest/guest)"
sudo systemctl status rabbitmq-server --no-pager
