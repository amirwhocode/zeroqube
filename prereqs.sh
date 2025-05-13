#!/bin/bash
set -e  # Stop the script immediately if any command fails

# ================================
# 🔄 System Preparation
# ================================

echo "🔄 System wird aktualisiert..."
# ✅ Needs sudo: updating system packages
sudo apt update && sudo apt upgrade -y

echo "📦 Notwendige Pakete werden installiert..."
# ✅ Needs sudo: installing required system packages
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git

# ================================
# 🐳 Docker Installation
# ================================

echo "🐳 Docker wird installiert..."
# ✅ Needs sudo: Docker installation and configuration
sudo apt install -y docker.io

# ✅ Needs sudo: Add current user to the Docker group for non-root access
sudo usermod -aG docker "$USER"

# newgrp docker       IDK

# ℹ️ Inform the user to re-login for Docker group to take effect
echo "➡️ Du musst dich ab- und wieder anmelden, damit die Docker-Gruppe aktiv wird."