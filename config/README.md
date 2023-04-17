# Configuration

Google Kubernetes Engine 설정 및 Airflow 사용자 설정을 할 수 있는 파일들이 있습니다.

## cluster.env

Google Kubernetes Engine 클러스터를 생성 및 관리하기 위한 설정을 할 수 있습니다.

각 설정에 대한 설명은 아래와 같습니다.

| 항목       | 설명         |
|----------|------------|
| GCP_PROJECT | GCP에서 사용하는 project_id |
| CLUSTER | GKE에 배포된(될) 클러스터 이름 |
| ZONE | GKE에 배포된 클러스터의 지역 |
| NUM_NODES | 클러스터에서 사용하는 노드 수 (디폴트 1개) |
| MIN_NODES | 클러스터에서 사용하는 최소 노드 수 (디폴트 1개) |
| MAX_NODES | 클러스터에서 사용하는 최대 노드 수 (디폴트 10개) |
| MACHINE_TYPE | 클러스터에서 사용하는 머신 타입 (디폴트 e2-medium) |
| DISK_SIZE | 클러스터에서 사용하는 머신의 디스크사이즈 (디폴트 30GB) |
| NODE_POOL_NAME | 클러스터에서 사용하는 노드풀 이름 |
| AIRFLOW_RELEASE_NAME | Helm 차트로 배포되는 Airflow 릴리즈명 |
| INGRESS_RELEASE_NAME | Helm 차트로 배포되는 Ingress(Nginx) 릴리즈 명 |


### Example

```yaml
## Google Kubernetes Engine Configuration
GCP_PROJECT=gcp_project
CLUSTER=data-pipeline
ZONE=asia-northeast3-a
NUM_NODES=1
MIN_NODES=1
MAX_NODES=10
MACHINE_TYPE=e2-medium
NODE_POOL_NAME=nodepool-1
DISK_SIZE=30GB

## Helm Chart Configuration
AIRFLOW_RELEASE_NAME=data-pipeline
INGRESS_RELEASE_NAME=ingress-nginx
```

## override-values.yaml

Kubernetes에 설치된 Airflow의 사용자 설정입니다.

설정에 대한 설명은 [사용자 설정](https://github.com/apache/airflow/blob/main/chart/values.yaml)을 참고하세요.

### Example

```yaml
## Airflow Docker Repository Configuration
defaultAirflowRepository: gcr.io/project_id/project_name
defaultAirflowTag: latest

## Image Pulling Policy
images:
  airflow:
    pullPolicy: Always

## Default Ingress Configuration
ingress:
  web:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx

## Webserver Secret Key
webserverSecretKey: this-is-a-secret-key
weserverSecretKeySecretName: webserver-secret

## Airflow Executor
executor: KubernetesExecutor

## Airflow Configuration
worker:
  persistence:
    enabled: false
webserver:
  # probe setting
  livenessProbe:
    initialDelaySeconds: 30
    timeoutSeconds: 30
    failureThreshold: 10
    periodSeconds: 3
  readinessProbe:
    initialDelaySeconds: 30
    timeoutSeconds: 30
    failureThreshold: 10
    periodSeconds: 3
  # authentication configuration
  defaultUser:
    username:
    password:
  # webserver configuration
  webserverConfig: |
    CSRF_ENABLED = True # use csrf security option
# persistence for logging
logs:
  persistence:
    enabled: false
# flower
flower:
  enabled: false
# redis
redis:
  enabled: false
#
config:
  # use basic_auth
  api:
    auth_backend: airflow.api.auth.backend.basic_auth
  # not load example dags
  core:
    load_examples: "False"
  # connect to GCS
  logging:
    remote_logging: "True"
    remote_base_log_folder: gs://log_bucket_address
    remote_log_conn_id: AIRFLOW_CONN_GCP

## Dags configuration
dags:
  gitSync:
    enabled: true
    repo: https://credential@github.com/username/repository.git
    branch: develop
    subPath: dags
```
