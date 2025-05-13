#!/bin/bash

set -e  # Stoppe bei Fehler

echo "🔄 System wird aktualisiert..."
sudo apt update && sudo apt upgrade -y

echo "📦 Notwendige Pakete werden installiert..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl

echo "🐳 Docker wird installiert..."
sudo apt install -y docker.io
sudo usermod -aG docker $USER
newgrp docker
echo "➡️ Du musst dich ab- und wieder anmelden, damit die Docker-Gruppe aktiv wird."


echo "📦 MiniKube wird installiert..."
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64


echo "✅ Installation abgeschlossen."