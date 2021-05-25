#!/usr/bin/env bash
function title() {

  BOLD="\e[1m"
  BG="\e[43m"
  FG="\e[30m"
  END="\e[0m"

  echo -e "\n${BOLD}${BG}${FG}$1${END}"
}

function init_kind_cluster() {
  echo ${KUBECONFIG}
  kind create cluster --name ${cluster_name} --config $1
  sleep 5s
}

function config_layer2_protocol() {
  kubectl create namespace metallb-system
  kubectl create secret generic memberlist --namespace metallb-system --from-literal secretkey="$(openssl rand -base64 128)"
  kubectl apply -f $1
  sleep 5s
  kubectl wait pod --namespace metallb-system --selector app=metallb --for condition=ready --timeout 90s
  kubectl apply -f $2
  sleep 5s
}

function install_lb_echo() {
  kubectl run foo --image=hashicorp/http-echo:0.2.3 --labels=app=echo -- "-text=foo"
  kubectl run bar --image=hashicorp/http-echo:0.2.3 --labels=app=echo -- "-text=bar"
  sleep 5s
  kubectl wait pod --selector app=echo --for condition=ready --timeout 90s
  kubectl expose pod foo --name foo-bar-echo --type=LoadBalancer --external-ip '172.19.255.202' --selector=app=echo --port=$1 --target-port=5678
  sleep 5s
  LB=$(kubectl get svc/foo-bar-echo -o=jsonpath='{.status.loadBalancer.ingress[0].ip}:{.spec.ports[0].port}')
  for i in {1..10}; do curl ${LB}; done
}

function install_lb_traefik_v2() {
  helm upgrade -i traefik traefik --repo https://helm.traefik.io/traefik --version 9.14.2 -f $1
  sleep 5s
  kubectl wait pod --for condition=ready --timeout 90s --selector app.kubernetes.io/instance=traefik
}

function install_traefik_v2_demo() {
  kubectl run kind-echo --image=hashicorp/http-echo:0.2.3 --labels=app=kind -- "-text=kind"
  kubectl expose pod kind-echo --name kind-echo --port 1234 --target-port 5678 --labels app=kind
  kubectl apply -f $1
  sleep 5s
  kubectl wait pod --selector app=kind --for condition=ready --timeout 90s
}

while :; do
  case $1 in
  --cluster-name)
    shift
    cluster_name=$1
    ;;

  --kind-config)
    shift
    kind_config=$1
    ;;

  --metallb-manifest)
    shift
    metallb_manifest=$1
    ;;

  --metallb-ip-ctl)
    shift
    metallb_ip_ctl=$1
    ;;

  --lb-echo-port)
    shift
    lb_echo_port=$1
    ;;

  --traefik-values)
    shift
    traefik_values=$1
    ;;

  --ingress-echo)
    shift
    ingress_echo=$1
    ;;

  *) break ;;
  esac
  shift
done

title 'Install kind cluster'
if [ -z "${kind_config}" ]; then
  echo "skipped"
else
  init_kind_cluster ${kind_config}
fi

title 'Config Layer2 protocol'
if [ -z "${metallb_manifest}" ]; then
  echo "skipped"
else
  config_layer2_protocol ${metallb_manifest} ${metallb_ip_ctl}
fi

title 'Install LoadBalancer lb-echo'
if [ -z "${lb_echo_port}" ]; then
  echo "skipped"
else
  install_lb_echo ${lb_echo_port}
fi

title 'Install LoadBalancer Traefik V2'
if [ -z "${traefik_values}" ]; then
  echo "skipped"
else
  install_lb_traefik_v2 ${traefik_values}
fi

title 'Install Traefik V2 Demo'
if [ -z "${ingress_echo}" ]; then
  echo "skipped"
else
  install_traefik_v2_demo ${ingress_echo}
fi

title '______test-1______'
wget https://echo.kind.io --no-check-certificate --spider
title '______test-2______'
wget http://echo.kind.io --no-check-certificate --spider
title '______test-3______'
curl https://echo.kind.io -ikL
title '______test-4______'
curl http://echo.kind.io -ikL

# kind delete cluster --name play
