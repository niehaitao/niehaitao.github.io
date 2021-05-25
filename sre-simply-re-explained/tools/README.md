# Tooling

## Inspect Helm

  ```bash
  helm list --all -A

  helm show values    <helm-chart-name> --repo=<helm-chart-repo> --version=<helm-chart-version>
  helm get  values    --namespace=<your-release-namespace> <your-release-name> --all
  helm get  manifest  --namespace=<your-release-namespace> <your-release-name>

  # templates
  helm template <your-release-name> <helm-chart-name> \
    --namespace=<your-release-namespace>              \
    --repo=<helm-chart-repo>                          \
    --version=<helm-chart-version> 

  # install
  helm upgrade  <your-release-name> <helm-chart-name> \
    --namespace=<your-release-namespace>              \
    --repo=<helm-chart-repo>                          \
    --version=<helm-chart-version>                    \
    --install --dry-run --debug

  # uninstall
  helm uninstall --namespace=<your-release-namespace> <your-release-name>
  ```

## Jinja Templating

Use jinja2 to template configuration values

```bash
function do-jinja() {
  src=$1 
  val=$2
  dst_dir=$3

  folder="/"
  dst_dir=${dst_dir%"$folder"}
  dst_file=$(echo $src | sed "s|.*${folder}||")

  suffix=".j2"
  dst_file=${dst_file%"$suffix"}

  dst=$dst_dir/$dst_file
  title "$src + $val = $dst"
  jinja2 $src $val | tee $dst
}

do-jinja your-template.yaml.j2 your-values.yaml /tmp/

ls /tmp/your-template.yaml
```

## Kind

see [Kind](kind/README.md)

## Traefik

see [Traefik](traefik/README.md)

## k8s-dashboard

see [K8S Dashboard](k8s-dashboard/README.md)

## prometheus-grafana-loki

See [prometheus-grafana-loki](prometheus-grafana-loki/README.md)

## flux

See [flux](flux/README.md)
