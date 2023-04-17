import pendulum

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import (
    BranchPythonOperator,
)

# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator,
)
from airflow.kubernetes.pod import Resources

from utils import (
    BRANCH_TRIGGER_KWARGS,
    GOOGLE_REPOSITORY,
    on_failure_alert,
    on_success_alert,
)


# Setting Timezone and START_DATE
local_tz = pendulum.timezone("Asia/Seoul")
START_DATE = datetime.now(tz=local_tz) - timedelta(days=2)

# Create dag
default_args = {
    "owner": "y9yk",
    "start_date": START_DATE,
    "retries": 1,
    "on_failure_callback": on_failure_alert,
    "on_success_callback": on_success_alert,
}
dag = DAG(
    dag_id="dag_exmaple",
    default_args=default_args,
    schedule_interval="0 0 * * *",
    start_date=START_DATE,
)

# Repository
PROJECT_NAME = "example"
PROJECT_VERSION = "latest"
IMAGE = f"{GOOGLE_REPOSITORY}/{PROJECT_NAME}:{PROJECT_VERSION}"

# Pod resources for tasks
pod_resources = Resources()
pod_resources.request_cpu = "250m"
pod_resources.request_memory = "300Mi"
pod_resources.limit_cpu = "500m"
pod_resources.limit_memory = "1024Mi"

# Tasks
start = DummyOperator(task_id="start", dag=dag)
end = DummyOperator(task_id="end", dag=dag)

# Task Definition
analysis = KubernetesPodOperator(
    namespace="default",
    image=IMAGE,
    cmds=["/app/sbin/run.sh"],
    node_selector={"cloud.google.com/gke-nodepool": "nodepool-1"},
    name="example",
    task_id="task1",
    image_pull_policy="Always",
    is_delete_operator_pod=True,
    resources=pod_resources,
    startup_timeout_seconds=600,
    get_logs=True,
    dag=dag,
)

branch = BranchPythonOperator(
    task_id="trigger_branch",
    python_callable=lambda x: x,
    op_kwargs=BRANCH_TRIGGER_KWARGS,
    dag=dag,
)

# Workflow
start >> analysis >> branch
branch >> [end]
