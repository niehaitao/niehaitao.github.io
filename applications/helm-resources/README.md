# Helm Resources Stack

## API

`kube=$HOME/ET/03_LIL/helm-resources/k8s/config`

### K3D

<details>

```bash
k3d cluster create cluster-1 --network act
k3d kubeconfig write cluster-1 -o ${kube}
# server: https://k3d-cluster-1-serverlb:6443

kubectl --kubeconfig ${kube} config get-contexts
kubectl --kubeconfig ${kube} --context k3d-cluster-1 get ns
kubectl --kubeconfig ${kube} --context k3d-cluster-1 get deploy -A
```
</details>

### Build & RUN

<details>

`port=8081 git=1234 build='2021-11-11 15:30:00' kube=${kube} go run server.go`

```bash
cd api
docker build . -f ./ops/docker/app.dockerfile -t helm-resources-api
docker run --rm \
  --name api    \
  --network act \
  -p 8081:8081  \
  -e port=8081  \
  -e git=1234   \
  -e build=5678 \
  -e kube=/app/kubeconfig \
  -v ${kube}.docker:/app/kubeconfig \
  helm-resources-api:latest
docker exec -it api /bin/sh
```

</details>

## Protocols

### `/clusters`

<details>

```bash
curl -X GET 'http://localhost:8081/clusters'
```

```json
[{"name":"k3d-cluster-1","namespaces":["default","kube-system","kube-public","kube-node-lease"]}]
```

</details>



### `/helm-releases/{cluster}/{namespace}`

<details>

```bash
curl -X GET 'http://localhost:8081/helm-releases/k3d-cluster-1/kube-system'
```

```json
[
  {
    "namespace": "kube-system", "name": "traefik-crd", "chart": "traefik-crd", "version": "9.18.2", "status": { "code": 1, "desc": "deployed" }, "resources": {}
  },
  {
    "namespace": "kube-system", "name": "traefik", "chart": "traefik", "version": "9.18.2", "status": { "code": 1, "desc": "deployed" },
        "resources": { "workloads": [{ "kind": "Deployment", "namespace": "kube-system", "name": "traefik" }] }
  }
]

```
</details>


### `/deploy-status/{cluster}/{namespace}/{name}`

<details>

```bash
curl -X GET 'http://localhost:8081/deploy-status/k3d-cluster-1/kube-system/traefik'
```

```json
{"code":1,"desc":"ready 1/1"}
```
</details>
