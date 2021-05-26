# SRE Simply-Re-Explained


## K8S Cluster

Various tools can be used to automate the cluster lifecycle management for platform operators or on local.

|                                                          Tool | Purpose                                                        |
| ------------------------------------------------------------: | :------------------------------------------------------------- |
|                             [kind](tools/kind/README.md) | create K8S cluster on **LOCAL** using Docker container *nodes* |
|                                  [eksctl](https://eksctl.io/) | create K8S cluster on **AWS EKS** in CLI                       |
| [aws-k8s-flight](https://github.com/niehaitao/aws-k8s-flight) | create K8S cluster on **AWS EKS** in Terraform                 |

## DEV

> [lil-app](https://github.com/niehaitao/lil-app) is a simple application following the [CI/CD](#cicd) approach of DevOps

See [LIL-APP](https://github.com/niehaitao/lil-app)

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

TODO

## Tools

> What problem is it designed to resolve?

See [Tools](tools/README.md)
