---
title: "Application Stack - Helm Resources"
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

**Helm Resources** is an ***application stack*** for the *cross-cluster monitoring* on the releases of *helm charts*.

It observes not only the status of *helm release* itself but also its *helm resources*.

*[application stack]: a suite or set of applications that work together to achieve a common goal
*[cross-cluster monitoring]: a single monitoring request against one or more remote clusters
*[helm charts]: the Kubernetes YAML manifests combined into a single package that can be advertised to your Kubernetes clusters
*[helm release]: the release of Helm Chart
*[helm resources]: the workloads declared in manifests when releasing a Helm Chart


<div class="notice--primary" markdown="1">

<img src="{{ site.url }}{{ site.baseurl }}/assets/helm-resources/helm-resources.gif">

<img src="{{ site.url }}{{ site.baseurl }}/assets/helm-resources/architecture.png" width="700" height="150">{: .align-right}

<br><ins>**Architecture**<br><br></ins>
**Front End Web** [helm-resources-web](https://github.com/orgs/pop-cloud/packages/container/package/helm-resources-web)<br><br>
**Back End API** [helm-resources-api](https://github.com/orgs/pop-cloud/packages/container/package/helm-resources-api)
{: style="text-align: center;"}
</div>




## TL;DR

To spin-up your stack on _[http://localhost:8082/](http://localhost:8082/)_

<div class="notice--primary" markdown="1">

**Option 1: run the stack on Docker**

```bash
docker-compose -f helm-resources.docker-compose.yml up --force-recreate --abort-on-container-exit --build
```

<details><summary>Inputs</summary>
  <script src="https://gist.github.com/niehaitao/bf9859fe3021536d547cb21bbf852b76.js"></script>
</details>

</div>



