# Traefik V1

[values](releases/traefik.v1.values.yaml)

```bash
helm upgrade -i traefik-one traefik     \
  --repo https://charts.helm.sh/stable  \
  --version 1.87.1                      \
  -f releases/traefik.v1.values.yaml
```

## Install

```bash
kubectl run echo-root --image=hashicorp/http-echo:0.2.3 --labels=app=echo-root -- "-text=root"
kubectl run echo-foo  --image=hashicorp/http-echo:0.2.3 --labels=app=echo-foo  -- "-text=foo"
kubectl run echo-bar  --image=hashicorp/http-echo:0.2.3 --labels=app=echo-bar  -- "-text=bar"

kubectl -n app expose pod echo-root  --name echo-root  --type=ClusterIP --selector=ref=root  --port=1234 --target-port=5678
kubectl -n app expose pod echo-foo   --name echo-foo   --type=ClusterIP --selector=ref=foo   --port=1234 --target-port=5678
kubectl -n app expose pod echo-bar   --name echo-bar   --type=ClusterIP --selector=ref=bar   --port=1234 --target-port=5678

kubectl apply -f echo-ing.yaml # credential
```

## Check

```bash
kubectl -n app describe ing echo-ing 
# Name:             echo-ing
# Namespace:        app
# Address:          xxx.us-east-1.elb.amazonaws.com
# Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)
# Rules:
#   Host                           Path  Backends
#   ----                           ----  --------
#   echo.app.xxx.com  
#                                  /       echo-root:1234 (10.223.73.227:5678)
#                                  /foo/   echo-foo:1234 (10.223.67.67:5678)
#                                  /bar/   echo-bar:1234 (10.223.74.187:5678)
# Annotations:                     traefik.ingress.kubernetes.io/rule-type: PathPrefixStrip
# Events:                          <none>

curl https://echo.app.xxx.com -kL
# root
curl https://echo.app.xxx.com/foo/ -kL
# foo
curl https://echo.app.xxx.com/bar/ -kL
# bar
```

## Resources
  
- [Traefik V1: Routing App in K8S](https://www.alibabacloud.com/blog/how-to-configure-traefik-for-routing-applications-in-kubernetes_594720)
