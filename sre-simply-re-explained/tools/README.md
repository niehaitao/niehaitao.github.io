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
  template=
  values=
  output=
  while :; do
    case $1 in
      -t|--template)  shift 
                  template=$1         
                  ;;
      -v|--values)   shift 
                  values=$1
                  ;;
      -o|--output)  shift 
                  output=$1
                  ;; 
      *) break
    esac
    shift
  done

  src=$template 
  val=$values
  dst_dir=$output

  folder="/"
  dst_dir=${dst_dir%"$folder"}
  dst_file=$(echo $src | sed "s|.*${folder}||")

  suffix=".j2"
  dst_file=${dst_file%"$suffix"}

  dst=$dst_dir/$dst_file
  title "$src + $val = $dst"
  jinja2 $src $val | tee $dst
}

do-jinja -t data/your-template.yaml.j2 -v your-values.yaml -o /tmp/

ls /tmp/your-template.yaml
```

## Git

```bash
git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
```

## Kind

see [Kind](kind/README.md)

## Traefik

see [Traefik](traefik/README.md)

## K8S Dashboard

see [K8S Dashboard](k8s-dashboard/README.md)

## Prometheus Grafana Loki

See [Prometheus Grafana Loki](prometheus-grafana-loki/README.md)

## Flux

See [Flux](flux/README.md)

## Jenkins

See [Jenkins](flux/README.md)

## GitHub Action

See [GitHub Action](github-action/README.md)