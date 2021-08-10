#!/bin/bash

set -e

title(){
  # echo -e "\n\n\e[1m\e[47m\e[96m$1\e[49m\e[39m\e[0m"
  BOLD="\e[1m"
  BG="\e[43m"
  FG="\e[30m"
  END="\e[0m"

  echo -e "\n${BOLD}${BG}${FG}$1${END}"
}

usage() {
    cat <<EOF
Generate certificate suitable for use with an sidecar-injector webhook service.

This script uses k8s' CertificateSigningRequest API to a generate a
certificate signed by k8s CA suitable for use with sidecar-injector webhook
services. This requires permissions to create and approve CSR. See
https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster for
detailed explanation and additional instructions.

The server key/cert k8s CA cert are stored in a k8s secret.

usage: ${0} [OPTIONS]

The following flags are required.

       --service          Service name of webhook.
       --namespace        Namespace where webhook service and secret reside.
       --secret           Secret name for CA certificate and server certificate/key pair.
EOF
    exit 1
}

while [[ $# -gt 0 ]]; do
    case ${1} in
        --service)
            service="$2"
            shift
            ;;
        --secret)
            secret="$2"
            shift
            ;;
        --namespace)
            namespace="$2"
            shift
            ;;
        --temp)
            temp="$2"
            shift
            ;;
        *)
            usage
            ;;
    esac
    shift
done

[ -z "${service}" ]     && service=sidecar-injector-webhook-svc
[ -z "${secret}" ]      && secret=sidecar-injector-webhook-certs
[ -z "${namespace}" ]   && namespace=default
[ -z "${temp}" ]        && temp='/tmp'

if [ ! -x "$(command -v openssl)" ]; then
    echo "openssl not found"
    exit 1
fi

csrName=${service}.${namespace}
tmpdir=$(mktemp -d -p ${temp})

title  "CSR TLS csr.conf > server-key.pem > server.csr"

cat <<EOF >> "${tmpdir}"/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${service}
DNS.2 = ${service}.${namespace}
DNS.3 = ${service}.${namespace}.svc
DNS.4 = ${service}.${namespace}.svc.cluster.local
EOF

openssl genrsa -out "${tmpdir}"/server-key.pem 2048
openssl req -new -key "${tmpdir}"/server-key.pem -subj "/CN=${service}.${namespace}.svc" \
  -config   "${tmpdir}"/csr.conf \
  -out      "${tmpdir}"/server.csr 

title  "CSR K8S Creation csr.yaml > ${csrName}"

# create  server cert/key CSR and  send to k8s API
cat <<EOF >> "${tmpdir}"/csr.yaml
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${csrName}
spec:
  groups:
  - system:authenticated
  request: $(< "${tmpdir}"/server.csr base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
# clean-up any previously created CSR for our service. Ignore errors if not present.
kubectl delete csr ${csrName} 2>/dev/null || true
kubectl create -f "${tmpdir}"/csr.yaml

# verify CSR has been created
while true; do
    if kubectl get csr ${csrName}; then
        break
    else
        sleep 1
    fi
done

title  "CSR K8S approved & signed ${csrName} > server-cert.pem"

# approve and fetch the signed certificate
kubectl certificate approve ${csrName}
# verify certificate has been signed
for _ in $(seq 10); do
    serverCert=$(kubectl get csr ${csrName} -o jsonpath='{.status.certificate}')
    if [[ ${serverCert} != '' ]]; then
        break
    fi
    sleep 1
done
if [[ ${serverCert} == '' ]]; then
    echo "ERROR: After approving csr ${csrName}, the signed certificate did not appear on the resource. Giving up after 10 attempts." >&2
    exit 1
fi
echo "${serverCert}" | openssl base64 -d -A -out "${tmpdir}"/server-cert.pem
echo "certificate ${csrName} has been signed & saved in ${tmpdir}/server-cert.pem"

title  "K8S secret secret.yaml > ${secret}"

# create the secret with CA cert and server cert/key
kubectl create secret generic ${secret} \
        --from-file=key.pem="${tmpdir}"/server-key.pem \
        --from-file=cert.pem="${tmpdir}"/server-cert.pem \
        --dry-run=client -o yaml > "${tmpdir}"/secret.yaml
kubectl -n ${namespace} delete secret ${secret} 2>/dev/null || true
kubectl -n ${namespace} create -f "${tmpdir}"/secret.yaml
