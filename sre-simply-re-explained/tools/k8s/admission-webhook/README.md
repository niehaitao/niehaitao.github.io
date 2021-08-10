# K8S Admission Webhook

## Purpose

<hr/>

K8S Admission Webhook allows to validate/mutate K8S API requests before the persistance.

<details close="">

![workflow](https://sysdig.com/wp-content/uploads/Kubernetes-Admission-controllers-01-flow-diagram-1930x580.jpg)

</details><br>

**Synopsis:**

1. K8S Creation Request from [demo-pod.yaml](data/demo-pod.yaml)

    <details close="">

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: demo-pod
      labels:
        example-webhook-enabled: "true"
    spec:
      containers:
      - name: nginx
        image: nginx
    ```

    ```bash
    kubectl apply -f data/demo-pod.yaml
    ```

    </details close="">

2. K8S Webhook Mutation

    <details close="">

    ![workflow](https://sysdig.com/wp-content/uploads/Kubernetes-Admission-controllers-02-image-scanner-webhook.png)

    </details>

3. K8S Persistance

    <details close="">

    ```bash
    kubectl get pod demo-pod -o yaml
    ```

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: demo-pod
      labels:
        example-webhook-enabled: "true"
        foo: bar  # injected by the webhook
    spec:
      containers:
      - name: nginx
        image: nginx
    ```

    </details>

## Prerequisites

<hr/>

### TLS certificate

```bash
tmpdir=$(mktemp -d)

PRJ_DIR=/home/haitao/ET/03_Workspace/05_EXT/k8s-webhook/k8s-mutating-webhook
# Create certificates and secrets

SCRIPTS_DIR=${PRJ_DIR}/scripts/

```

## References

<hr/>

- [K8S Admission Webhook](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#what-are-admission-webhooks)
