# Dag Utility

Dag 수행 시 아래의 기능을 제공합니다.

- Dag 수행 성공 및 실패 시 Slack을 통한 알림

## alert.py

`alert.py`를 통해 Dag 수행 성공/실패 시 `on_failure_alert`, `on_success_alert` 함수를 통해 Slack 알람을 받을 수 있습니다.

또한 Slack 알람을 사용하기 위해 아래의 변수들이 설정되어야 합니다.

- slack_token
- slack_channel
- airflow_service_host

해당 변수는 Airflow Webserver UI의 (Admin -> Variables) 메뉴에서 설정할 수 있습니다.

설정된 변수는 아래의 코드를 통해 동적으로 이용될 수 있습니다.

```python
from airflow.models import Variable

SLACK_TOKEN = Variable.get("slack_token")
SLACK_CHANNEL = Variable.get("slack_channel")

AIRFLOW_SERVICE_HOST = Variable.get("airflow_service_host")
AIRFLOW_SERVICE_URL = f"http://{AIRFLOW_SERVICE_HOST}"
```


자세한 사항은 [Managing Variables](https://airflow.apache.org/docs/apache-airflow/stable/howto/variable.html)를 참고하세요.
