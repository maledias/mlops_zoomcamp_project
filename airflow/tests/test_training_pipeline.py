from airflow.models import DagBag
from airflow.utils.db import initdb
import pytest


@pytest.fixture()
def dagbag():
    initdb()
    return DagBag()


@pytest.fixture()
def training_pipeline_dag(dagbag):
    dag_id = "training_pipeline"
    dag = dagbag.get_dag(dag_id=dag_id)
    return dag


def test_imports(dagbag):
    assert dagbag.import_errors == {}


def test_dag_loading(training_pipeline_dag):
    assert training_pipeline_dag is not None
    assert len(training_pipeline_dag.tasks) == 4


def test_dag_structure(training_pipeline_dag):
    expected_task_sequence = [
        "get_training_data",
        "prepare_data",
        "upload_training_data_to_s3",
        "train_model",
    ]
    actual_tasks = list(training_pipeline_dag.task_dict.keys())
    assert len(expected_task_sequence) == len(actual_tasks)
    for expected, actual in zip(expected_task_sequence, actual_tasks):
        assert expected == actual
