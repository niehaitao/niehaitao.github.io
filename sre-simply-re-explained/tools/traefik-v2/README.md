# Traefik V2

## Install on kind

- enabling the permanent redirection https, see [Redirection Https](redirection.md)

```bash
helm upgrade -i traefik traefik              \
  --repo    https://helm.traefik.io/traefik  \
  --version 9.14.2                           \
  -f        data/values.kind.yaml

kubectl wait  pod             \
  --for       condition=ready \
  --timeout   90s             \
  --selector  app.kubernetes.io/instance=traefik

kubectl get svc
# NAME         TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                            
# traefik      LoadBalancer   10.96.199.240   172.19.255.201   80:30410/TCP,443:30173/TCP
```

- [ingress router](data/traefik.v2.ingress.yaml.j2)

```bash
kubectl apply -f data/traefik.https.yaml
```
