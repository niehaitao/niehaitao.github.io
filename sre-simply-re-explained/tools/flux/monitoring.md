# Flux Monitoring

[manifests/monitoring](https://github.com/fluxcd/flux2/tree/main/manifests/monitoring)

```bash
export K8S_GIT_CONFIG='lil-k8s/ops/cluster-flight/flux-deploy/kust.git.monitor.yaml'

flux create source git monitoring \
  --interval=30m \
  --url=https://github.com/fluxcd/flux2 \
  --branch=main \
  --export >> ${K8S_GIT_CONFIG}

flux create kustomization monitoring \
  --interval=1h \
  --prune=true \
  --source=monitoring \
  --path="./manifests/monitoring" \
  --health-check="Deployment/prometheus.flux-system" \
  --health-check="Deployment/grafana.flux-system" \
  --export >> ${K8S_GIT_CONFIG}
```

TODO: Kustomize the traffic to Prometheus and Grafana services
