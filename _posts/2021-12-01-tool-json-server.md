---
title: "Tool - API with json-server"
date: 2021-12-31
categories:
  - Tool
tags:
  - api
  - test
header:
  overlay_color: "#333"
excerpt: In <30 seconds, we can mock a full REST API using the [json-server](https://github.com/typicode/json-server) over a simple json file
intro:
  - image_path: /assets/tool/json-server.png
    title: "REST API in local environment"
    excerpt: 'In <30 seconds, we can use [json-server](https://github.com/typicode/json-server) to mock a full REST API over a simple JSON file'
---

{% include feature_row id="intro" type="left" %}


<div class="notice--primary" markdown="1">

**Spin-up the API**

```bash
npm install -g json-server
json-server --watch rest-api.json-server.data.json --port 5001
```

<details><summary><b>Input</b></summary>

{% gist 433431f6ae3a3c5dad94975653b0a508 rest-api.json-server.data.json %}

</details>

</div>

<div class="notice--primary" markdown="1">

**Write API**

```bash
curl -X POST 'http://localhost:5001/activities?user=a' \
  -H "Content-type: application/json" \
  -d "@/tmp/a.json"
```

<details markdown="1"><summary><b>Input</b></summary>

```json
{ "user": "a", "action": "update", "date": "2012-08-01" }
```

</details>

</div>

<div class="notice--primary" markdown="1">

**Read API**

```bash
curl -X GET 'http://localhost:5001/activities?user=a&action=update&date=2012-08-01'

```
<details markdown="1"><summary><b>Output</b></summary>

```json
[ { "user": "a", "action": "update", "date": "2012-08-01", "id": 7 } ]
```
</details>
</div>

---

<div class="notice--warning" markdown="1">

## Routing *(optional)*

**Spin-up the API with the routes**

```bash
json-server --port 8081 --delay 750   \
  --watch   hlr.json-server.data.json \
  --routes  hlr.json-server.route.json
```

<details markdown="1"><summary><b>Inputs</b></summary>
{% gist 433431f6ae3a3c5dad94975653b0a508 hlr.json-server.route.json %}
{% gist 433431f6ae3a3c5dad94975653b0a508 hlr.json-server.data.json %}
</details><br>

**Sample Query 1 - default result** 

```bash
curl -X GET 'http://localhost:8081/helm-releases/foo/bar'
```

<details markdown="1"><summary><b>Output</b></summary>

```json
[ { "namespace": "default", "name": "xxx", "chart": "xxx", "version": "1.0.0", "status": { "code": 0, "desc": "failed" } } ]
```

</details><br>

**Sample Query 2 - custom result** 

```bash
curl -X GET 'http://localhost:8081/helm-releases/cluster-1/ns-x'
```

<details markdown="1"><summary><b>Output</b></summary>

```json
[
  {
    "namespace": "ns-x", "name": "foo", "chart": "foo", "version": "1.0.1", "status": { "code": 1, "desc": "deployed" },
    "resources": { "workloads": [
      { "kind": "Deployment", "namespace": "ns-x", "name": "foo-api" },
      { "kind": "Deployment", "namespace": "ns-x", "name": "foo-web" }] }
  }
]
```

</details>
</div>
