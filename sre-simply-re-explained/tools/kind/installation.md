# Install kind cluster

kind is a tool for running local Kubernetes clusters using Docker container “nodes”.

## Install Kind

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
chmod +x ./kind
mv ./kind ${HOME}/.local/bin/kind
```

## Install Cluster

use [kind.config.yaml](data/kind.config.yaml) to create a kind cluster with

- `extraPortMappings` allow the local host to make requests to the Ingress controller over ports `80/8443`
- `node-labels` only allow the ingress controller to run on a specific node(s) matching the label selector

```bash
export KUBECONFIG=${HOME}/.kube/kind/config
kind create cluster --name play --config data/kind.config.yaml
kind delete cluster --name play
```

```console
$ docker container ls
CONTAINER ID  NAMES               IMAGE                 PORTS
f7c6b8499f61  play-control-plane  kindest/node:v1.20.2  0.0.0.0:80->80/tcp,0.0.0.0:443->8443/tcp,127.0.0.1:43643->6443/tcp

$ docker container inspect play-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}'
172.19.0.2
```

## Check Cluster

```bash
docker container ls
# NAME                 STATUS   ROLES                  AGE     VERSION
# play-control-plane   Ready    control-plane,master   2m50s   v1.20.2
```
