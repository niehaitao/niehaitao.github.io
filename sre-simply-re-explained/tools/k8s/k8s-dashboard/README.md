# k8s-dashboard

[doc](https://github.com/kubernetes/dashboard/tree/master/aio/deploy/helm-chart/kubernetes-dashboard)

Deploy a **Helm Release `k8s-dashboard-big`** in the **Cluster Namespace `kube-dashboard`** using:

- the **Helm Chart `kubernetes-dashboard`** ***version `4.0.0`***
- the **Docker Image `dashboard`** ***version `v2.1.0`*** and
- the [additional values](releases/k8s-dashboard.values.yaml)

```bash
do-jinja install/k8s-dashboard.values.yaml.j2 .secret/k8s-dashboard.values.yaml /tmp/

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

helm upgrade -i k8s-dashboard-big -n kube-dashboard         \
  kubernetes-dashboard/kubernetes-dashboard --version=4.0.0 \
  -f /tmp/k8s-dashboard.values.yaml
```
