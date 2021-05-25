# Jenkins

Use [data/values.yaml](data/values.yaml) to install [Jenkins Helm Chart](https://github.com/jenkinsci/helm-charts/tree/main/charts/jenkins)

## Check plugins upgrade

Use [data/check-plugins-upgrade.sh](data/check-plugins-upgrade.sh) to check the upgrade of Jenkins Plugins

```bash
./data/check-plugins-upgrade.sh   \
  -f data/values.yaml             \
  -p controller.installPlugins    \
  -v 3.2.5

./data/check-plugins-upgrade.sh   \
  -f data/values.yaml             \
  -p controller.additionalPlugins \
  -v 3.2.1
```

## Jenkins Helm Chart

Use [data/values.yaml](data/values.yaml) to install Jenkins Helm Chart

```bash
helm upgrade -n app -i contractor jenkins  \
  --repo https://charts.jenkins.io  \
  --version 3.2.5 \
  -f data/values.mvp.yaml

kubectl wait pod        \
  --namespace app       \
  --for condition=ready \
  --timeout 90s         \
  --selector app.kubernetes.io/instance=contractor

kubectl exec          \
  --namespace app     \
  -it svc/contractor  \
  -c jenkins          \
  -- /bin/cat /run/secrets/chart-admin-password && echo
```

Use [data/ingress.yaml](data/ingress.yaml) to expose HTTP & HTTPs routes

```bash
kubectl apply -f data/ingress.yaml

wget https://jenkins.kind.io --no-check-certificate --spider 
wget  http://jenkins.kind.io --no-check-certificate --spider 

curl https://jenkins.kind.io -ikL 
curl  http://jenkins.kind.io -ikL 
```
