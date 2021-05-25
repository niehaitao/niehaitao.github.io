# Load Balancing Traffics on kind

## Config Layer2 protocol

- Install Metallb from [data/metallb.manifests.yaml](data/metallb.manifests.yaml) or [the default manifest](https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml)

```bash
kubectl create namespace metallb-system

kubectl create secret generic memberlist  \
  --namespace     metallb-system          \
  --from-literal  secretkey="$(openssl rand -base64 128)" 

kubectl apply -f data/metallb.manifests.yaml

kubectl wait  pod             \
  --namespace metallb-system  \
  --selector  app=metallb     \
  --for       condition=ready \
  --timeout   90s
```

- Config Metallb to control the range of IP addresses on the docker kind network from [data/metallb.ip-control.yaml](data/metallb.ip-control.yaml) or [the default config](https://kind.sigs.k8s.io/examples/loadbalancer/metallb-configmap.yaml)

```bash
# Inspect the range of the docker kind network
docker network inspect -f '{{.IPAM.Config}}' kind
# [{172.19.0.0/16  172.19.0.1 map[]} {fc00:f853:ccd:e793::/64  fc00:f853:ccd:e793::1 map[]}]

# Setup address pool used by loadbalancers
kubectl apply -f data/metallb.ip-control.yaml
```

## Install LoadBalancer Service

See [Networking » k8s-service » LoadBalancer service](../../networking/k8s-service.md#loadbalancer-service)

## Install LoadBalancer Traefik V2

- Prerequisite: [Setup local wildcard domain resolution](dnsmasq.md#steps)

- Step: [Install the Traefik V2 LoadBalancer on kind](../traefik-v2/README.md#install-on-kind)

- Option: [Permanent redirecting http to https](../traefik-v2/README.md#redirection-https)

- Request
  
  ```bash
  wget https://echo.kind.io --no-check-certificate --spider
  curl https://echo.kind.io -ikL 

  wget  http://echo.kind.io --no-check-certificate --spider 
  curl  http://echo.kind.io -ikL 
  ```

## Resources

- [How to get LoadBalancer service in a kind cluster using Metallb](https://kind.sigs.k8s.io/docs/user/loadbalancer/).
- [Kubernetes ingress on kind](https://banzaicloud.com/blog/kind-ingress/)
