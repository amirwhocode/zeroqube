# Preparation
Ubuntu 25 ARM on WMWare Fusion

### Install Required Dependencies
```bash
sudo apt update
sudo apt upgrade
sudo apt install -y curl apt-transport-https ca-certificates
```

### Install a Container Runtime (Docker)
```bash
sudo apt install -y docker.io
sudo usermod -aG docker $USER
newgrp docker
```

### Download and Install Minikube
```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64
```

### Start Minikube with Resource Allocation
```bash
minikube start \
--kubernetes-version stable \
--nodes 2 \
--cpus 4 \
--memory 8192 \
--cni calico
```

### Test if your cluster is initialized. The response should list two running nodes
```bash
minikube kubectl get node
```

### Install Helm (Kubernetes Package Manager)
```bash
curl https://raw.githubusercontent.com/helm/helm/HEAD/scripts/get-helm-3 | bash
helm version
```

### Make Helm aware of the JupyterHub Helm chart repository
```bash
helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
helm repo update
```

# Deploying JupyterHub on Minikube with Helm

This guide shows how to install and manage JupyterHub on a Minikube Kubernetes cluster using Helm.

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Helm](https://helm.sh/docs/)
- Kubernetes CLI (`kubectl`)
- `config.yaml` file with your JupyterHub configuration

## Installation

Run the following Helm command to install or upgrade JupyterHub:

```bash
helm upgrade --cleanup-on-fail \
  --install redspot jupyterhub/jupyterhub \
  --namespace 02jh \
  --create-namespace \
  --values hub.yaml \
  --timeout 30m0s
```

```bash
minikube kubectl -- get pods -n 02jh
```-

```bash
minikube kubectl -- get service proxy-public -n 02jh
```

```bash
minikube service list
minikube ip
minikube kubectl cluster-info
minikube kubectl -- get service --namespace 02jh
```

## install ngshare
```bash
helm repo add ngshare https://libretexts.github.io/ngshare-helm-repo/
helm repo update
```

```bash
helm install ngshare ngshare/ngshare -f ngshare.yaml --namespace 02jh
```

```bash
helm upgrade --cleanup-on-fail \
  redspot jupyterhub/jupyterhub \
  --namespace 02jh \
  --values hub.yaml \
  --timeout 30m0s
  ```

## Debug

```bash
minikube kubectl -- logs hub-69794884d5-d5vrz -n 02jh
```

```bash
minikube kubectl -- describe pod hub-69794884d5-d5vrz -n 02jh
```



helm upgrade