# Grafana

## 1. Sidecars

### 1.1. Sidecar for dashboards

Objective: load dynamically dashboards from configmaps or secrets

Steps

- active `sidecar.dashboards.enabled` to deploy a `sidecar container` in the grafana pod
- create configmaps or secrets
  - with a label as defined in `sidecar.dashboards.label`
  - define the dashboard config
    <details close=""> <summary>Example dashboard config</summary>

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: sample-grafana-dashboard
      labels:
        grafana_dashboard: "1"
    data:
      k8s-dashboard.json: |-
      [...]
    ```

    </details>
- What the `sidecar container` does
  - watches all configmaps (or secrets) in the cluster
  - filters out with a label as defined in `sidecar.dashboards.label`.
  - The files defined in those configmaps are written to a folder and accessed by grafana.

Changes to the configmaps are monitored and the imported dashboards are deleted/updated.

> A recommendation is to use one configmap per dashboard, as a reduction of multiple dashboards inside one configmap is currently not properly mirrored in grafana.

see [Sidecar for dashboards](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md#sidecar-for-dashboards)

### 1.2. Sidecar for datasources

Objective: load dynamically datasources from configmaps or secrets at **on startup**

Steps

- active `sidecar.datasources.enabled` to deploy a `init container` in the grafana pod

- create configmaps or secrets before startup the grafana
  - with a label as defined in `sidecar.datasources.label`
  - define the datasource config
    <details close=""> <summary>Example datasource config</summary>

    ```yaml
    datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
          # <string, required> name of the datasource. Required
        - name: Graphite
          # <string, required> datasource type. Required
          type: graphite
          # <string, required> access mode. proxy or direct (Server or Browser in the UI). Required
          access: proxy
          # <int> org id. will default to orgId 1 if not specified
          orgId: 1
          # <string> url
          url: http://localhost:8080
          # <string> database password, if used
          password:
          # <string> database user, if used
          user:
          # <string> database name, if used
          database:
          # <bool> enable/disable basic auth
          basicAuth:
          # <string> basic auth username
          basicAuthUser:
          # <string> basic auth password
          basicAuthPassword:
          # <bool> enable/disable with credentials headers
          withCredentials:
          # <bool> mark as default datasource. Max one per org
          isDefault:
          # <map> fields that will be converted to json and stored in json_data
          jsonData:
            graphiteVersion: "1.1"
            tlsAuth: true
            tlsAuthWithCACert: true
          # <string> json object of data that will be encrypted.
          secureJsonData:
            tlsCACert: "..."
            tlsClientCert: "..."
            tlsClientKey: "..."
          version: 1
          # <bool> allow users to edit datasources from the UI.
          editable: false
      ```

    </details>

- What the `init container` does
  - lists all secrets (or configmaps, though not recommended) in the cluster
  - filters out the ones with a label as defined in `sidecar.datasources.label`.
  - The files defined in those secrets are written to a folder and accessed by grafana on startup. 
  
> Secrets are recommended over configmaps for this usecase because datasources usually contain private data like usernames and passwords. Secrets are the more appropriate cluster resource to manage those.

Example values to add a datasource adapted from [Grafana](http://docs.grafana.org/administration/provisioning/#example-datasource-config-file):

see [Sidecar for datasources](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md#sidecar-for-datasources)

### 1.3. Sidecar for notifiers

Objective: load dynamically notifiers from configmaps or secrets **on startup**

Steps

- active `sidecar.notifiers.enabled` to deploy a `init container` in the grafana pod
- create configmaps or secrets before startup the grafana
  - with a label as defined in `sidecar.dashboards.label`
  - define the notifier config
    <details close=""> <summary>Example notifier config</summary>

    ```yaml
    notifiers:
      - name: notification-channel-1
        type: slack
        uid: notifier1
        # either
        org_id: 2
        # or
        org_name: Main Org.
        is_default: true
        send_reminder: true
        frequency: 1h
        disable_resolve_message: false
        # See `Supported Settings` section for settings supporter for each
        # alert notification type.
        settings:
          recipient: 'XXX'
          token: 'xoxb'
          uploadImage: true
          url: https://slack.com

    delete_notifiers:
      - name: notification-channel-1
        uid: notifier1
        org_id: 2
      - name: notification-channel-2
        # default org_id: 1
    ```

    </details>
- What the `init container` does
  - watches all configmaps (or secrets) in the cluster
  - filters out with a label as defined in `sidecar.notifiers.label`.
  - The files defined in those configmaps are written to a folder and accessed by grafana.

> Secrets are recommended over configmaps for this usecase because alert notification channels usually contain private data like SMTP usernames and passwords. Secrets are the more appropriate cluster resource to manage those.

see [Sidecar for notifiers](https://github.com/grafana/helm-charts/blob/main/charts/grafana/README.md#sidecar-for-notifiers)

## Resources

- [Dynamic Configuration Discovery in Grafana](https://johnharris.io/2019/03/dynamic-configuration-discovery-in-grafana/)
- [Provision dashboards and data sources](https://grafana.com/tutorials/provision-dashboards-and-data-sources/)
- [Collecter et afficher les logs avec Grafana Loki](https://www.aukfood.fr/collecter-et-afficher-les-logs-avec-grafana-loki/)
