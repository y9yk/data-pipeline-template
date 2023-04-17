FROM apache/airflow:2.2.1-python3.8

LABEL maintainer="Yong Ki Lee <andrew.yk82@gmail.com>"

ARG GCP_PROJECT=gcp-project

# set environment
ENV AIRFLOW_USER_HOME=/opt/airflow
ENV SERVICE_ACCOUNT_FILEPATH=credential/service-account.json
ENV GOOGLE_APPLICATION_CREDENTIALS=/opt/airflow/${SERVICE_ACCOUNT_FILEPATH}

# set user and workdir
USER root
WORKDIR ${AIRFLOW_USER_HOME}

# source installation
COPY requirements.txt ${AIRFLOW_USER_HOME}/
COPY ${SERVICE_ACCOUNT_FILEPATH} ${AIRFLOW_USER_HOME}/credential/

# gcloud installation and authentication
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN gcloud auth activate-service-account \
    --key-file=${SERVICE_ACCOUNT_FILEPATH} && \
    gcloud config set project ${GCP_PROJECT}

# change user
USER ${AIRFLOW_UID}

# install dependencies
RUN pip install \
    -r ${AIRFLOW_USER_HOME}/requirements.txt \
    --use-deprecated=legacy-resolver