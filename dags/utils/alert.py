from dateutil.relativedelta import relativedelta
from airflow.models import Variable
from airflow.operators.slack_operator import SlackAPIPostOperator


SLACK_TOKEN = Variable.get("slack_token")
SLACK_CHANNEL = Variable.get("slack_channel")

AIRFLOW_SERVICE_HOST = Variable.get("airflow_service_host")
AIRFLOW_SERVICE_URL = f"http://{AIRFLOW_SERVICE_HOST}"

FAILURE_TEMPLATE = """
- DAG: _{dag_id}_
- Task: _{task_id}_
- Execution Date (KST): _{execution_date}_
- Next Execution Date (KST): _{next_execution_date}_
```{exception}```
"""


def on_failure_alert(context):
    # get task's information
    task_instance = context.get("task_instance")
    task_id = task_instance.task_id
    dag_id = task_instance.dag_id
    log_url = task_instance.log_url.replace("localhost:8080", AIRFLOW_SERVICE_HOST)
    exception = str(context.get("exception"))[:50]
    execution_date = (context.get("execution_date") + relativedelta(hours=9)).strftime(
        "%Y-%m-%d %H:%M:%S"
    )
    next_execution_date = (
        context.get("next_execution_date") + relativedelta(hours=9)
    ).strftime("%Y-%m-%d %H:%M:%S")

    # message template
    message = FAILURE_TEMPLATE.format(
        dag_id=dag_id,
        task_id=task_id,
        execution_date=execution_date,
        next_execution_date=next_execution_date,
        exception=exception,
    )
    attachments = [
        {
            "mrkdwn_in": ["text", "pretext"],
            "pretext": ":boom: *Failure*",
            "text": message,
            "actions": [
                {
                    "type": "button",
                    "name": "view log",
                    "text": "View log",
                    "url": log_url,
                    "style": "primary",
                },
            ],
            "color": "danger",
            "fallback": "details",
        }
    ]

    #
    alert = SlackAPIPostOperator(
        task_id="slack_failed",
        channel=SLACK_CHANNEL,
        token=SLACK_TOKEN,
        attachments=attachments,
        text=f"Batch failure ({dag_id} - {task_id})",
    )

    return alert.execute(context=context)


def on_success_alert(context):
    # get task's information
    task_instance = context.get("task_instance")
    dag_id = task_instance.dag_id

    # message
    attachments = [
        {
            "mrkdwn_in": ["text", "pretext"],
            "pretext": ":relaxed: *Success*",
            "text": "Success",
            "actions": [
                {
                    "type": "button",
                    "name": "Go to airflow",
                    "text": "Go to airflow",
                    "url": AIRFLOW_SERVICE_URL,
                    "style": "primary",
                },
            ],
            "color": "good",
            "fallback": "details",
        }
    ]

    #
    alert = SlackAPIPostOperator(
        task_id="slack_success",
        channel=SLACK_CHANNEL,
        token=SLACK_TOKEN,
        attachments=attachments,
        text=f"Batch success ({dag_id})",
    )

    return alert.execute(context=context)
