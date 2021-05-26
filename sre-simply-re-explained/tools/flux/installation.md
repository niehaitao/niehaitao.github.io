# Flux Installation

Scenario

- K8S Cluster **flight**
- GitOps Tool **flux**
- [Git Repository as Sources](https://toolkit.fluxcd.io/core-concepts/#sources) **lil-k8s**
- **flux** watches **lil-k8s** » creates `kustomization` » deploys on **flight**

## FLUX-K8S-CONFIG «» K8S-CLUSTER

configure **flux** on **flight** to watch **lil-k8s** (on the path ***ops/cluster-flight***)

```bash
export GITHUB_TOKEN=
export GITHUB_USER='niehaitao'
export FLUX_K8S_REPO='lil-k8s'
export FLUX_K8S_PATH='ops/cluster-flight'

flux bootstrap github           \
  --owner=$GITHUB_USER          \
  --repository=${FLUX_K8S_REPO} \
  --path=${FLUX_K8S_PATH}       \
  --branch=main                 \
  --personal                    \
  --components-extra=image-reflector-controller,image-automation-controller
```
