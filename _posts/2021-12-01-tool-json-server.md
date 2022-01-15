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
---

{% capture notice-2 %}

In < 30 seconds, we can mock a full REST API using the [json-server](https://github.com/typicode/json-server) over a simple json file
<img src="{{ site.url }}{{ site.baseurl }}/assets/tool/json-server.png">

{% endcapture %}

<div class="notice--primary">
{{ notice-2 | markdownify }}
</div>



## TL;DR

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
