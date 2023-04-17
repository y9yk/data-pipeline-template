FROM apache/airflow:2.2.1-python3.8

LABEL maintainer="Yong Ki Lee <andrew.yk82@gmail.com>"

ARG GCP_PROJECT=gcp-project

# set environment
ENV AIRFLOW_USER_HOME=/opt/airflow
ENV SERVICE_ACCOUNT_FILEPATH=credential/service-account.json
ENV GOOGLE_APPLICATION_CREDENTIALS=/opt/airflow/${SERVICE_ACCOUNT_FILEPATH}

# set python specific environment
ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.2.2

# set user and workdir
USER root
WORKDIR ${AIRFLOW_USER_HOME}

# source installation
COPY poetry.lock pyproject.toml ${AIRFLOW_USER_HOME}/
COPY ${SERVICE_ACCOUNT_FILEPATH} ${AIRFLOW_USER_HOME}/credential/

# poetry installation and initialization
RUN pip install "poetry==$POETRY_VERSION"
RUN poetry config virtualenvs.create false \
  && poetry install --no-dev --no-interaction --no-ansi

# gcloud installation and authentication
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN gcloud auth activate-service-account \
    --key-file=${SERVICE_ACCOUNT_FILEPATH} && \
    gcloud config set project ${GCP_PROJECT}

# Change user
USER ${AIRFLOW_UID}