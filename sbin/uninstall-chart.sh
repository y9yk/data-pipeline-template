#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${CURR_DIR}/common.sh

# vars
RELEASE_NAME=${AIRFLOW_RELEASE_NAME:-$CLUSTER}

# validation
if [[ -z "${CLUSTER}" ]]; then
    echo "Error: CLUSTER not set"
    exit 1
fi

# set k8s-context
kubectl config use-context ${CLUSTER}

# delete
helm delete ${RELEASE_NAME}
