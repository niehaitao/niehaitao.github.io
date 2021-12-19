# SRE Simply-Re-Explained


## K8S Cluster

Various tools can be used to automate the cluster lifecycle management for platform operators or on local.

| Tool                                                          | Purpose                                                        |
|---------------------------------------------------------------|----------------------------------------------------------------|
| [k3d](tools/kind/README.md)                                   | create K8S cluster on **LOCAL** using Docker container *nodes* |
| [kind](tools/k3d/README.md)                                   | create K8S cluster on **LOCAL** using Docker container *nodes* |
| [eksctl](https://eksctl.io/)                                  | create K8S cluster on **AWS EKS** in CLI                       |
| [aws-k8s-flight](https://github.com/niehaitao/aws-k8s-flight) | create K8S cluster on **AWS EKS** in Terraform                 |

## DEV

> [Activities application stack](https://github.com/niehaitao/niehaitao.github.io/tree/main/applications/activities) is composed of front/back/database to show the create/update/delete activities.

See [Activities application stack](https://github.com/niehaitao/niehaitao.github.io/tree/main/applications/activities)

## CI/CD

> Integrating and Deploying new code can cause **time-consuming problems** for development and operations teams.

See [CI/CD](cicd/README.md)

## Networking

> What problem is it designed to resolve?

See [Networking](networking/README.md)

## Monitoring

> What problem is it designed to resolve?

See [Monitoring](monitoring/README.md)

## Security

> What problem is it designed to resolve?

See [Security](security/README.md)

## Tools

> What problem is it designed to resolve?

See [Tools](tools/README.md)
