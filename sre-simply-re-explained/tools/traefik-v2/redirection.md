# Redirection Https

```yaml
additionalArguments:
  - --entrypoints.websecure.http.tls.certResolver=default

ports:
  web:
    redirectTo: websecure
```

[values](data/values.kind.yaml) permanent redirecting of all requests on http (80) to https (443)

```bash
helm upgrade -i traefik traefik              \
  --repo    https://helm.traefik.io/traefik  \
  --version 9.14.2                           \
  -f        data/values.kind.yaml
```

## TODO

Use [echo.https.yaml](data/echo.https.yaml)???? Doesn't work for me!!!

```yaml
additionalArguments:
  - --entrypoints.web.http.redirections.entrypoint.to=:443
  - --entrypoints.web.http.redirections.entrypoint.scheme=https
```

Use [echo.redirect.yaml](data/echo.redirect.yaml) to use extra middleware

```bash
kubectl run kind-echo               \
  --image=hashicorp/http-echo:0.2.3 \
  --labels=app=kind                 \
  -- "-text=kind"

kubectl expose pod kind-echo  \
  --name        kind-echo     \
  --port        1234          \
  --target-port 5678          \
  --labels      app=kind 

kubectl apply -f data/echo.redirect.yaml
```

## Resources
  
- [Traefik V2: Redirect HTTPS with Helm](https://traefik.io/blog/install-and-configure-traefik-with-helm/)
- [Traefik Https](https://medium.com/@alexgued3s/how-to-easily-ish-471307f276a9)