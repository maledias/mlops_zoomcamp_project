MLFLOW_ARTIFACES_BUCKET_NAME := $(shell terraform -chdir=terraform/dev output -raw mlflow_artifacts_bucket_name)

download_data:
	@echo installing dependencies
	poetry install --with setup
	@echo downloading data
	poetry run python -m src.utils.download_raw_data --path ./data/raw/

create_dev_setup:
	@terraform -chdir=terraform/dev init
	@terraform -chdir=terraform/dev plan
	@terraform -chdir=terraform/dev apply -auto-approve

copy_data_to_s3:
	@aws s3 cp ./data/raw "s3://${MLFLOW_ARTIFACES_BUCKET_NAME}/data/raw/" --recursive

start_mlflow_server:
	@echo "s3://${MLFLOW_ARTIFACES_BUCKET_NAME}/mlflow_artifacts"
	@poetry run mlflow server --backend-store-uri=sqlite:///mlruns.db --port=5001 --default-artifact-root="s3://${MLFLOW_ARTIFACES_BUCKET_NAME}/mlflow_artifacts"

setup_airflow:
	mkdir airflow
	cd airflow; astro dev init;