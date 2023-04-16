# data-pipeline-template

Airflow를 활용해서 손쉽게 데이터 프로세싱 코드 및 스케줄링을 할 수 있는 코드 템플릿입니다.

## How to deploy

### Dockerization

아래의 스크립트를 이용해서 Airflow가 사용할 수 있는 Docker 이미지를 빌드할 수 있습니다.

```bash
$cd deploy
$./build-docker.sh
```

### Airflow Settings

Airflow에 대한 사용자 설정은 `./deploy/override-values.yaml`을 참고합니다.

### Deploy Airflow Chart

아래의 스크립트를 이용해서 Airflow를 Kubernetes에 배포할 수 있습니다.

```bash
$cd deploy
$./install-chart.sh
$./install-ingress.sh
```

Chart가 참고하는 values.yaml 파일은 `./deploy/override-values.yaml`을 참고하면 됩니다.

### Undeploy Airflow Chart

아래의 스크립트를 이용해서 Airflow를 Kubernetes에서 제거할 수 있습니다.

```bash
$cd deploy
$./uninstall-chart.sh
```

## Dags

Airflow가 구동시키는 dag 파일의 위치는 `./dags`에 있습니다. (gitsync를 사용해서 동기화되고 있습니다.)