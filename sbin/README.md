# Scripts

[Google Kubernetes Engine API](https://cloud.google.com/kubernetes-engine)과 [Helm Chart](https://helm.sh/ko/docs/topics/charts/)를 이용해서 아래의 기능을 수행합니다.

- 클러스터 생성
- 노드풀 추가
- 생성된 클러스터에 Airflow 배포
- 생성된 클러스터에 Airflow 삭제

스크립트를 수행하기 위해 필요한 설정은 [사용자 설정](/config)을 참고하세요.

각 스크립트에 대한 설명은 아래와 같습니다.

| 항목       | 설명         |
|----------|------------|
| common.sh | 환경변수 셋업 및 유틸리티를 지원하는 스크립트 |
| build-docker.sh | Airflow에 배포될 Docker 이미지를 빌드/푸시하는 스크립트 |
| create-cluster.sh | GKE에 클러스터를 생성하는 스크립트 |
| create-nodepool.sh | 클러스터가 사용하는 노드풀을 생성하는 스크립트 |
| install-chart.sh | 클러스터에 Airflow를 설치하는 스크립트 |
| install-ingress.sh | 설치된 Airflow webserver의 인그레스를 설정하는 스크립트 |
| uninstall-chart.sh | 클러스터에서 Airflow를 삭제하는 스크립트 |
