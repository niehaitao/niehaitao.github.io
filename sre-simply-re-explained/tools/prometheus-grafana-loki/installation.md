# Monitoring Installation

You can either install

- components one by one (see [2. Components](#2-components))
- stacks comprising several components (see [1. Stacks](#1-stacks))

## 1. Stacks

### 1.1. Prometheus-Grafana

`hunter` is a deployment of

- the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- with the [additional values](data/stack.prom.values.yaml.j2)

<details close=""> <summary>installations</summary>

including components

- [prometheus operator](README.md#1-prometheus-operator)
- [prometheus server](README.md#2-prometheus)
- [alertmanager](./README.md#3-prometheus-alertmanager)
- [grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana)

```bash
do-jinja data/stack.prom.values.yaml.j2 data/.stack.values.yaml /tmp/

helm repo add prom https://prometheus-community.github.io/helm-charts

helm template hunter prom/kube-prometheus-stack \
helm upgrade  hunter prom/kube-prometheus-stack \
  --version     14.0.0                      \
  --namespace   monitoring                  \
  -f            data/.stack/0.yaml          \
  -f            data/.stack/1.prom-op.yaml  \
  --install --dry-run --debug
```

</details>

### 1.2. Loki-Promtail-Fluent

`tracer` is a deployment of

- the [loki-stack](https://github.com/grafana/helm-charts/tree/main/charts/loki-stack)
- with the [additional values](data/stack.loki.values.yaml.j2)

<details close=""> <summary>installations</summary>

```bash
do-jinja data/stack/5.loki.yaml.j2 data/stack/kind.values.yaml data/

helm repo add grafana https://grafana.github.io/helm-charts

monitor_ops='promtail.enabled=true,fluent-bit.enabled=true,grafana.enabled=false,prometheus.enabled=false'
persist_ops='prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false'

helm upgrade tracer grafana/loki-stack \
  --version     2.3.1                 \
  --namespace   monitoring            \
  -f            data/5.loki.yaml      \
  --set=${monitor_ops},${persist_ops} \
  --install --dry-run --debug

kubectl -n monitoring get cm tracer-promtail -o yaml | yq e '.data."promtail.yaml"' -M - | yq e -

```

</details>

## 2. Components

### 2.1. Prometheus Operator

- [prometheus operator](prometheus.md#1-prometheus-operator)
- [additional values](data/1.prom-operator.yaml)

<details close=""> <summary>installation</summary>

```bash
do-jinja data/stack/0.none.yaml.j2          data/stack/kind.values.yaml data/
do-jinja data/stack/1.prom-operator.yaml.j2 data/stack/kind.values.yaml data/

helm upgrade prom-op prom/kube-prometheus-stack \
  --version     14.0.0                    \
  --namespace   monitoring                \
  -f            data/0.none.yaml          \
  -f            data/1.prom-operator.yaml \
  --install
```

</details>

### 2.2. Prometheus Server

<details close=""> <summary>installation</summary>

```bash
helm upgrade prom-svr prom/kube-prometheus-stack \
  --version     14.0.0                    \
  --namespace   monitoring                \
  -f            data/0.none.yaml          \
  -f            data/2.prom-server.yaml  \
  --install
```

</details>

<details close=""> <summary>expose service</summary>

```bash
kubectl apply -f data/https/monitoring.prom-server.yaml
# https://prom-server.kind.io/
```

</details>

### 2.3. Prometheus AlertManager

<details close=""> <summary>installation</summary>

```bash
do-jinja data/stack/0.none.yaml.j2              data/stack/kind.values.yaml data/
do-jinja data/stack/3.prom-alertmanager.yaml.j2 data/stack/kind.values.yaml data/

helm upgrade alt-mgr prom/kube-prometheus-stack \
  --version     14.0.0                        \
  --namespace   monitoring                    \
  -f            data/0.none.yaml              \
  -f            data/3.prom-alertmanager.yaml \
  --install
```

</details>

<details close=""> <summary>expose service</summary>

```bash
kubectl apply -f data/https/monitoring.alert-manager.yaml
# https://alertmanager.kind.io/
```

</details>

### 2.4. Grafana

- [prometheus operator](prometheus.md#1-prometheus-operator)
- [additional values](data/data/4.grafana.yaml)

<details close=""> <summary>installation</summary>

```bash
helm upgrade grafana grafana/grafana  \
  --version   6.4.4                   \
  -n          monitoring              \
  -f          data/4.grafana.yaml     \
  --install
```

</details>

<details close=""> <summary>expose service</summary>

```bash
kubectl apply -f data/https/monitoring.grafana.yaml

# https://grafana.kind.io/

kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-user}"     | base64 --decode ; echo
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

</details>

### 2.5. Loki

<details close=""> <summary>installation</summary>

```bash
helm upgrade loki grafana/loki  \
  --version   2.5.0                   \
  -n          monitoring              \
  -f          data/5.loki.yaml     \
  --install
```

</details>

```sql
{container="flux"}
count_over_time({container="flux"}[1m] |= "Authentication is required")  > 1
```

### 2.6. Promtail

<details close=""> <summary>installation</summary>

```bash
helm upgrade promtail grafana/promtail  \
  --version   3.5.0                 \
  -n          monitoring            \
  -f          data/6.promtail.yaml  \
  --install
```

</details>

## 3. Third App nginx-discovery

`nginx-discovery` is a 3rd App(nginx) to audit at [Loki Test](loki.md#test).

```bash
kubectl apply -f data/nginx.discovery.yaml
```

`nginx-discovery` [uses the stub_status Module](https://www.nginx.com/blog/monitoring-nginx/#Log-Files-and-syslog) to [log files and syslog at access log and error log](https://docs.docker.com/config/containers/logging/)

```console
$ kubectl -n monitoring exec nginx-discovery-584d9b798d-cbxhv -it -- /bin/bash

$ nginx -V 2>&1 | grep --color -- --with-http_stub_status_module

$ ls -l /var/log/nginx
 access.log -> /dev/stdout
  error.log -> /dev/stderr
```

## Troubleshooting

### Internal error occurred: failed calling webhook

```bash
# 1. Prometheus Operator
helm upgrade prom-op prom/kube-prometheus-stack \
  --version     14.0.0                    \
  --namespace   monitoring                \
  -f            data/1.prom-operator.yaml \
  --set         fullnameOverride=prom-op  \
  --set         nameOverride=prom-op      \
  --install

# 2. Prometheus AlertManager
helm upgrade alt-mgr prom/kube-prometheus-stack \
  --version     14.0.0                        \
  --namespace   monitoring                    \
  -f            data/3.prom-alertmanager.yaml \
  --set         fullnameOverride=alt-mgr      \
  --set         nameOverride=alt-mgr          \
  --install

# 3. Prometheus Rule
kubectl -n monitoring apply -f data/prom/rules.yaml
# Error from server (InternalError): error when creating "data/prom/rules.yaml": 
# Internal error occurred: failed calling webhook "prometheusrulemutate.monitoring.coreos.com": 
# Post "https://alt-mgr-kube-prometheus-st-operator.monitoring.svc:443/admission-prometheusrules/mutate?timeout=10s":
# service "alt-mgr-kube-prometheus-st-operator" not found
```

- [Prometheus Operator - Admission webhooks](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/webhook.md)
- [Prometheus Operator - failed calling webhook](https://github.com/helm/charts/issues/19928)
- [Prometheus Operator - ValidatingWebhookConfiguration](https://github.com/prometheus-community/helm-charts/blob/acb625d5051ff73032cbb0e2a3275735f6113afb/charts/kube-prometheus-stack/templates/prometheus-operator/admission-webhooks/validatingWebhookConfiguration.yaml#L34)
- [K8S Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)

```bash
# Source: kube-prometheus-stack/templates/prometheus-operator/admission-webhooks/validatingWebhookConfiguration.yaml
kubectl -n monitoring get svc
# NAME                                     PORT(S)                   
# alertmanager-operated                    9093/TCP,9094/TCP,9094/UDP
# alt-mgr-kube-prometheus-st-alertmanager  9093/TCP                  
# prom-op-kube-prometheus-st-operator      443/TCP                   

# 2. Prometheus AlertManager
helm upgrade alt-mgr prom/kube-prometheus-stack \
  --version     14.0.0                        \
  --namespace   monitoring                    \
  -f            data/3.prom-alertmanager.yaml \
  --set         fullnameOverride=alt-mgr      \
  --set         nameOverride=alt-mgr          \
  --set         prometheusOperator.admissionWebhooks.enabled=false  \
  --install
```