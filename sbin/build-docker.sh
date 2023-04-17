#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${CURR_DIR}/common.sh

# vars
PROJECT_VERSION=${PROJECT_VERSION:-latest}

# validation
if [[ -z "${GCP_PROJECT}" ]]; then
    echo "Error: GCP_PROJECT not set"
    exit 1
fi

if [[ -z "${PROJECT_NAME}" ]]; then
    echo "Error: PROJECT_NAME not set"
    exit 1
fi

# build and push
IMAGE=gcr.io/${GCP_PROJECT}/${PROJECT_NAME}:${PROJECT_VERSION}

docker build -f ${PROJECT_ROOT}/Dockerfile \
    -t ${IMAGE} \
    --build-arg GCP_PROJECT=${GCP_PROJECT} \
    .
docker push ${IMAGE}