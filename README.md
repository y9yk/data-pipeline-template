# data-pipeline-template

Airflow를 Google Kubernetes Engine 위에서 실행하고, 데이터 프로세싱과 관련한 Dag 코드를 생성 및 운영할 수 있는 코드 템플릿입니다.

## Prerequisite

아래 프로그램이 실행되는 것을 전제하고 있습니다.

만약 설치되어 있지 않다면, 아래 링크를 토대로 설치해주세요.

- [Docker](https://docs.docker.com/engine/install)
- [Helm](https://helm.sh/docs/intro/install)
- [gcloud CLI](https://cloud.google.com/sdk/docs/install)

## Configuration

### Cluster Settings

GCP 클러스터 [사용자 설정](/sbin)을 참고하세요.

> **Warning**
> 
> Google Kubernetes Engine에 대한 리소스 접근제어가 가능한 서비스 계정이 생성되어 있고, 이를 이용한다고 가정합니다.<br/>
> 서비스 계정의 위치는 `credential/service-account.json`입니다.<br/>
> Google Cloud Platform에서의 서비스 계정의 생성 및 삭제는 [서비스 계정 생성](https://cloud.google.com/iam/docs/keys-create-delete)을 참고하세요.

### Airflow Settings

Airflow [사용자 설정](/config)을 참고하세요.

## How to deploy

### Dockerization

아래의 스크립트를 이용해서 Airflow가 사용할 수 있는 Docker 이미지를 빌드 및 배포할 수 있습니다.

```bash
$ ./sbin/build-docker.sh
```

### Deploy Airflow Chart

아래의 스크립트를 이용해서 Airflow를 Kubernetes에 배포할 수 있습니다.

```bash
$ ./sbin/install-chart.sh
$ ./sbin/install-ingress.sh
```

### Undeploy Airflow Chart

아래의 스크립트를 이용해서 Airflow를 Kubernetes에서 제거할 수 있습니다.

```bash
$ ./sbin/uninstall-chart.sh
```