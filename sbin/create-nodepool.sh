#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${CURR_DIR}/common.sh

# vars
ZONE=${ZONE:-asia-northeast3-a}
NUM_NODES=${NUM_NODES:-1}
MIN_NODES=${MIN_NODES:-1}
MAX_NODES=${MAX_NODES:10}
MACHINE_TYPE=${MACHINE_TYPE:-e2-medium}
NODE_POOL_NAME=${NODE_POOL_NAME:-nodepool-1}
DISK_SIZE=${DISK_SIZE:-30GB}

# validation
if [[ -z "${CLUSTER}" ]]; then
    echo "Error: CLUSTER not set"
    exit 1
fi

gcloud container node-pools create ${NODE_POOL_NAME} \
    --cluster ${CLUSTER} \
    --zone ${ZONE} \
    --enable-autoscaling \
    --num-nodes ${NUM_NODES} \
    --min-nodes ${MIN_NODES} \
    --max-nodes ${MAX_NODES} \
    --machine-type ${MACHINE_TYPE} \
    --disk-size ${DISK_SIZE}