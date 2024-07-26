from sagemaker.sklearn.model import SKLearnModel
from src.utils.constants import MODEL_DATA, ROLE, ENTRY_POINT, FRAMEWORK_VERSION


if __name__ == "__main__":
    print(MODEL_DATA)
    print(ROLE)
    print(ENTRY_POINT)
    print(FRAMEWORK_VERSION)

    if not MODEL_DATA:
        print("No MODEL_DATA has been provided, skipping model deployment.")
        exit(0)

    sklearn_model = SKLearnModel(
        model_data=MODEL_DATA,
        role=ROLE,
        entry_point=ENTRY_POINT,
        framework_version=FRAMEWORK_VERSION,
    )

    sklearn_model.deploy(instance_type="ml.c4.xlarge", initial_instance_count=1)
