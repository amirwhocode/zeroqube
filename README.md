# Deploy JupyterHub and ngshare on Minikube via Helm on Ubuntu VM compatible with Apple Silicon and ARM Architecture
This guide helps you set up Minikube, Docker, and Helm on your Ubuntu system. The setup is split into two parts: the first script installs Docker, and the second script installs Minikube and Helm after a reboot.

## Quick Setup
Run the first script (install_prereqs.sh) to install Docker and required tools:
```bash
chmod +x prereqs.sh
./prereqs.sh
```
Now reboot or log out and log back in to apply Docker group changes.

After rebooting, run the second script (install.sh) to:
- Install Minikube and Helm
- Start the Minikube cluster
- Deploy JupyterHub and ngshare using Helm

```bash
chmod +x install.sh
./install.sh
```

## All done! Now go build something great! 🚀

# Debug

```bash
minikube kubectl -- logs hub-69794884d5-d5vrz -n 02jh
```

```bash
minikube kubectl -- describe pod hub-69794884d5-d5vrz -n 02jh
```


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
```

```bash
minikube kubectl -- get service proxy-public -n 02jh
```

```bash
minikube service list
minikube ip
minikube kubectl cluster-info
minikube kubectl -- get service --namespace 02jh
```

```bash
helm upgrade --cleanup-on-fail \
  redspot jupyterhub/jupyterhub \
  --namespace 02jh \
  --values hub.yaml \
  --timeout 30m0s
  ```
### Start Minikube with Resource Allocation
```bash
minikube start \
--kubernetes-version stable \
--nodes 3 \
--cpus 3 \
--memory 6144 \
--cni calico
```

### Test if your cluster is initialized. The response should list two running nodes
```bash
minikube kubectl get node
```

Links:
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Helm](https://helm.sh/docs/)


