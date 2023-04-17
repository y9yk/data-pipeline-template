#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "${CURR_DIR}")"

# vars
RELEASE_NAME=${INGRESS_RELEASE_NAME:-ingress-nginx}

# validation
if [[ -z "${CLUSTER}" ]]; then
    echo "Error: CLUSTER not set"
    exit 1
fi

# set k8s-context
kubectl config use-context ${CLUSTER}

# install
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && helm repo update
helm upgrade \
    --install \
    --wait \
    --set rbac.create=true \
    --set controller.service.externalTrafficPolicy=Local \
    ${RELEASE_NAME} ingress-nginx/ingress-nginx