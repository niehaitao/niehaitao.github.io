# Kubernetes IN Docker (kind)

kind is a tool for running local Kubernetes clusters using Docker container “nodes”.

## TL;DR

[Setup local wildcard domain resolution](../local/dnsmasq.md#steps) `*.kind.io` to `172.19.255.201`

```bash
export KUBECONFIG=/tmp/kind-play

./init.sh \
  --kind-config         data/kind.config.yaml               \
  --metallb-manifest    data/metallb.manifests.yaml         \
  --metallb-ip-ctl      data/metallb.ip-control.yaml        \
  --traefik-values      ../traefik/data/traefik.values.yaml \
  --ingress-echo        data/echo.https.yaml                \
  --lb-echo-port        1234                                \
  --cluster-name        play

./init.sh --lb-echo-port 1234

./init.sh --ingress-echo data/echo.https.yaml
./init.sh
```

## Installation

see [Install kind Cluster](installation.md)

## Local Host Setup

see [Setup local wildcard domain resolution](../local/dnsmasq.md)

## Load Balance on Cluster

see [Load Balance kind Traffics](loadbalancer.md)
