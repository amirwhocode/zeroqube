#!/bin/bash
set -e  # Stop the script immediately if any command fails

# ================================
# 📦 Minikube Installation
# ================================

echo "📦 MiniKube wird installiert..."

# 📥 Download Minikube binary (ARM64 version)
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64

# ✅ Needs sudo: Install binary to system path
sudo install minikube-linux-arm64 /usr/local/bin/minikube

# 🧹 Clean up
rm minikube-linux-arm64

# ================================
# 📦 Helm Installation
# ================================

echo "📦 Helm wird installiert..."

# ⛔ Don't use sudo here: Helm's install script handles permissions itself
curl https://raw.githubusercontent.com/helm/helm/HEAD/scripts/get-helm-3 | bash


# ================================
# 📦 To be able run ngshare on ARM64
# ================================
echo "📦 QEMU wird installiert..."

sudo apt-get install qemu-user-static

# ================================
# 🚀 Minikube Cluster Start
# ================================

echo "📦 Minikube Cluster wird gestartet..."

# Clean previous Minikube setup if it exists
minikube delete || true

# Start a new Minikube cluster
minikube start

# ================================
# 📦 Helm Repositories Setup
# ================================

echo "📦 Helm Charts werden hinzugefügt..."

# Add required Helm repositories
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo add ngshare https://LibreTexts.github.io/ngshare-helm-repo/
# TODO: it fetch amd64 compatible version and failed on arm64, try on windows laptop
# Update local Helm chart metadata
helm repo update

echo "✅ Grundinstallation abgeschlossen."

# ================================
# 🐳 Docker Image Build in Minikube
# ================================

echo "🐳 Docker-Umgebung für Minikube konfigurieren..."
# Configure Docker to use Minikube's internal Docker daemon
eval "$(minikube docker-env)"

# Build the custom singleuser Docker image if Dockerfile exists
if [[ -f Dockerfile-singleuser ]]; then
    echo "📦 Custom Docker-Image wird gebaut..."
    docker build -f Dockerfile-singleuser -t ngshare-singleuser-sample:0.0.1 .
else
    echo "⚠️ Dockerfile-singleuser nicht gefunden! Überspringe Image-Build."
fi

# Revert Docker environment back to host
eval "$(minikube docker-env -u)"

# ================================
# 🚀 Helm Deployments
# ================================

echo "🚀 JupyterHub wird mit Helm installiert..."
# ❌ Do not use sudo: Helm manages resources inside the current Kubernetes cluster as user
helm install jhub jupyterhub/jupyterhub -f hub.yaml

echo "🚀 ngshare wird mit Helm installiert..."
helm install ngshare ngshare/ngshare -f ngshare.yaml

# ================================
# 📋 Output Kubernetes Resources
# ================================

echo "📋 Aktuelle Kubernetes Pods:"
# Get list of current pods from the Minikube cluster
minikube kubectl -- get pods

echo "🌐 Verfügbare Services:"
# List available services running in Minikube
minikube service list
