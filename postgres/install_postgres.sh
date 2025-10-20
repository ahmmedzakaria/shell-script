#!/bin/bash

# PostgreSQL Installation Script for Ubuntu 24.04
# Includes prompt for setting the password for the 'postgres' user

# CONFIGURATION
USE_OFFICIAL_REPO=true  # Set to false to use Ubuntu default repo

# FUNCTIONS
install_from_ubuntu_repo() {
    echo "Installing PostgreSQL from Ubuntu default repository..."
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
}

install_from_official_repo() {
    echo "Installing PostgreSQL from the official PostgreSQL repository..."

    # Install required tools
    sudo apt update
    sudo apt install -y curl gnupg2 lsb-release ca-certificates

    # Add PostgreSQL signing key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
        gpg --dearmor | sudo tee /etc/apt/keyrings/postgresql.gpg > /dev/null

    # Add PostgreSQL APT repo
    echo "deb [signed-by=/etc/apt/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | \
        sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null

    # Update and install PostgreSQL
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
}

set_postgres_password() {
    echo
    echo "🔐 Set a password for the PostgreSQL 'postgres' user:"
    read -s -p "Enter password: " pg_pass
    echo
    read -s -p "Confirm password: " pg_pass_confirm
    echo

    if [ "$pg_pass" != "$pg_pass_confirm" ]; then
        echo "❌ Passwords do not match. Exiting."
        exit 1
    fi

    echo "✅ Setting password for 'postgres' user..."

    # Use sudo -u postgres to run psql and change password
    sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$pg_pass';"
}

verify_installation() {
    echo
    echo "✅ Checking PostgreSQL service status..."
    sudo systemctl status postgresql --no-pager
    echo
    echo "🎉 PostgreSQL installed and configured successfully!"
    echo "You can switch to the postgres user using: sudo -i -u postgres"
    echo "Or connect with: psql -U postgres -W"
}

# MAIN EXECUTION
if $USE_OFFICIAL_REPO; then
    install_from_official_repo
else
    install_from_ubuntu_repo
fi

set_postgres_password
verify_installation
