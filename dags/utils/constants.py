import os

PROJECT_ROOT = os.path.dirname(os.path.abspath(os.path.dirname(__file__)))

BRANCH_TRIGGER_KWARGS = {"x": "{{ dag_run.conf['TRIGGER_BRANCH'] | d('trigger') }}"}
BRANCH_END_KWARGS = {"x": "{{ dag_run.conf['TRIGGER_BRANCH'] | d('end') }}"}

GOOGLE_PROJECT_ID = os.environ.get("GCP_PROJECT")
GOOGLE_REPOSITORY = f"gcr.io/{GOOGLE_PROJECT_ID}"
