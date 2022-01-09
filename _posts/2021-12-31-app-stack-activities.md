---
title: "Application Stack - Activities"
date: 2021-12-31
categories:
  - DEV
tags:
  - application stack
  - docker
  - helm
header:
  overlay_color: "#333"
---

**Activities** is an ***application stack*** composed of front-back-database to show the create-update-delete activities.

*[application stack]: a suite or set of applications that work together to achieve a common goal

<div class="notice--primary" markdown="1">

<img src="{{ site.url }}{{ site.baseurl }}/assets/activities/activities.gif"  width=400>{: .align-left}

<ins>**Architecture**</ins><br>

<img src="{{ site.url }}{{ site.baseurl }}/assets/activities/architecture.png" width=700 >{: .align-center}

**Front End Web** [activities-web](https://github.com/niehaitao/activities-web)<br>{: style="text-align: center;"}

**Back End API** [activities-api](https://github.com/niehaitao/activities-api)<br>{: style="text-align: center;"}

**Database** [activities-db](https://hub.docker.com/_/postgres)<br>{: style="text-align: center;"}


</div>

## TL;DR

To spin-up your stack on _[http://localhost:8082/](http://localhost:8082/)_


<div class="notice--primary" markdown="1">

**Option 1: run the stack on Docker**

```bash
docker-compose -f act.docker-compose.yml up --force-recreate --abort-on-container-exit --build
```

<details><summary>Inputs</summary>
  <script src="https://gist.github.com/niehaitao/7e6937c01abce64c41a1c5b7dd299983.js"></script>
</details>

</div>

<div class="notice--primary" markdown="1">

**Option 2: run the stack on K8S**

```bash
helm upgrade -i act activities-stack --version 1.0.0 --repo https://pop-cloud.github.io/helm-charts -f act.helm-chart.values.yaml
```

<details><summary>Inputs</summary>
  <script src="https://gist.github.com/niehaitao/689e05e308d3fbb49e5174b748b38612.js"></script>
</details>

</div>



## Build Up

To build the stack's applications one by one.

<div class="notice--primary" markdown="1">

**Application 1: Database PostgreSQL**
<details>
  <script src="https://gist.github.com/niehaitao/bca401f91b3d1169b71096f1bc4510cc.js"></script>
</details>
</div>

<div class="notice--primary" markdown="1">

**Application 2: Backend API**
<details>
  <script src="https://gist.github.com/niehaitao/170d72027606c3a906bf63eec8055c50.js"></script>
</details>
</div>

<div class="notice--primary" markdown="1">

**Application 3: Frontend Web**
<details>
  <script src="https://gist.github.com/niehaitao/e2bcd90eaa74231312324b7213533f26.js"></script>
</details>
</div>
