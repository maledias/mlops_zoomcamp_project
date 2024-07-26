# 1. Problem description
This project was inspired by a dataset available on [Kaggle](https://www.kaggle.com/datasets). 
The Kaggle dataset page for this dataset can be found [here](https://www.kaggle.com/datasets/anmolkumar/health-insurance-cross-sell-prediction).

## 1.1. Project Context

An insurance company that **currently offers health insurance** to its customers and now seeks assistance in **developing a model to predict whether these policyholders would also be interested in the company's vehicle insurance**.

To solve the problem, we are going to use the available data to train a binary classification model that predicts a yes/no label, indicating if the client would be interested in vehicle insurance.

## 1.2. Data Description
To build this model, the following customer data is available:
| Variable             | Definition                                                                            |
|----------------------|---------------------------------------------------------------------------------------|
| id                   | Unique ID for the customer                                                            |
| Gender               | Gender of the customer                                                                |
| Age                  | Age of the customer                                                                   |
| Driving_License      | 0: Customer does not have a driving license, 1: Customer has a driving license        |
| Region_Code          | Unique code for the region of the customer                                            |
| Previously_Insured   | 1: Customer already has vehicle insurance, 0: Customer doesn't have vehicle insurance |
| Vehicle_Age          | Age of the vehicle                                                                    |
| Vehicle_Damage       | 1: Customer's vehicle was damaged previously, 0: Customer's vehicle was not damaged   |
| Annual_Premium       | Annual premium amount paid by the customer                                            |
| Policy_Sales_Channel | Anonymized code for the sales channel (agents, mail, phone, in person, etc.)          |
| Vintage              | Number of days the customer has been associated with the company                      |
| Response             | 1: Customer is interested in vehicle insurance, 0: Customer is not interested         |

# 2. Project Evaluation information
## 2.1. Cloud Tools
For the successful development and deployment of the project, the following AWS services will be utilized:

- Amazon S3: A scalable object storage solution. Amazon S3 will be used to store and manage all artifacts generated during the model training process, including datasets, model outputs, and logs. This ensures secure, durable, and highly available storage.
- Amazon SageMaker: A fully managed machine learning (ML) service that facilitates the building, training, and deployment of ML models at scale. In this project, Amazon SageMaker will be leveraged for several critical tasks:
    - Model Training: SageMaker provides an environment for training machine learning models on large datasets using a wide range of pre-built algorithms and frameworks.
    - Model Deployment: After training, SageMaker enables seamless deployment of the trained models into a production-ready environment, allowing for real-time predictions and scaling as needed.

To provision and manage these AWS resources, the following tools will be used:
- Terraform: An IaC tool that allows for the efficient provisioning, management, and versioning of infrastructure. Terraform will be used to automate the deployment of AWS resources, ensuring consistency and reducing the potential for human error.
- Python SageMaker SDK: A Python library that simplifies the integration and management of SageMaker services within the project’s codebase. The SDK will be used to streamline the process of training and deploying machine learning models, allowing for seamless interaction with SageMaker from within Python scripts.

By leveraging these AWS services, the project aims to achieve efficient and scalable machine learning workflows, ensuring high performance and reliability.

## 2.2. Experiment tracking and model registry

For the experiment tracking and model registry portion of this project, we are going to use MLflow. MLflow provides a comprehensive platform for managing the end-to-end machine learning lifecycle, from experimentation to deployment.

- MLflow Tracking: The [experimentation notebook](notebooks/insurance_cross_sell_predition.ipynb) logs experiment details, metrics, and artifacts to the MLflow tracking system. This ensures that all aspects of the experiments, including hyperparameters, model parameters, and performance metrics, are systematically recorded. This allows for easy comparison of different runs and reproducibility of results.
- MLflow Model Registry: Additionally, the notebook leverages the MLflow Model Registry to keep track of the models generated. The Model Registry provides a central repository to store, annotate, and manage models. It facilitates the transition of models from the development stage to production by supporting model versioning, stage transitions (e.g., staging, production), and model lineage tracking.

## 2.3. Workflow Orchestration
To efficiently manage and orchestrate the project's machine learning pipeline, which encompasses both data preprocessing and model training, we will utilize [Apache Airflow](https://airflow.apache.org/). This powerful tool allows us to automate and monitor complex workflows, ensuring that each step in our pipeline is executed in a timely and reliable manner. By leveraging Airflow's capabilities, we can schedule tasks, manage dependencies, and handle any potential failures with ease. Furthermore, its user-friendly interface and extensive documentation make it an ideal choice for maintaining and scaling our machine learning operations.

## 2.4. Model deployment
The model will be deployed within an Amazon SageMaker endpoint. This approach provides a scalable and secure environment for hosting our machine learning model, enabling us to serve predictions with low latency and high availability. By using SageMaker endpoints, we can seamlessly integrate our model into production, benefiting from features such as automatic scaling, monitoring, and version control. This ensures that our deployed model performs efficiently under varying load conditions and can be easily updated or rolled back as needed.

## 2.5. Best practices
### 2.5.1. Unit tests
Unit tests are used to test the machine learning training pipeline. They are executed automatically in the project's CI/CD pipeline.
They are defined in the `airflow/tests/` directory.
### 2.5.2  Linter and code formatter
The [Black Python Code Formatter](https://github.com/psf/black) is used as a code formatter in this project. It is executed automatically through the project's pre-commit hooks.
### 2.5.4 Makefile
A [Makefile](Makefile) is used in the project to automate a couple of tasks such as the project setup and infrastructure provisioning with terraform.
### 2.5.5. pre-commit hooks
[Pre-commit hooks](.pre-commit-config.yaml) are used to run the code formatter automatically.
### 2.5.6. CI/CD pipeline
The project has a CI/CD pipeline create with GitHub Actions in order to execute tests and deploying the machine learning model automatically.
It is defined in the `.github/workflows/deploy.yml` file.

# 3. Reproducing the project
To reproduce the project, and actually deploy the trained machine learning model to a Sagemaker Endpoint, follow the step-by-step process below:

## Requirements
In order to reproduce the project, you will need to fulfill the following requirements:
- [Create an AWS account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html)
- Create an IAM user for your account and get the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, they will be necessary in order to reproduce all the project's steps.
    - Follow [these](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) instructions to create an IAM user.
    - Follow [these](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) instructions to get your credentials.
- Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configure a default profile](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html) for your user.
- Install [pyenv](https://github.com/pyenv/pyenv) and [Poetry](https://python-poetry.org/docs/) for managing the Python environment
- Install [Astro CLI](https://www.astronomer.io/docs/astro/cli/install-cli) for managing the airflow environment.
- Install [Docker](https://docs.docker.com/engine/install/)

## Step-by-step process
1. Fork the repository and `cd` to the project directory.
2. Run `poetry install` to install the project Python dependencies.
3. In the project root directory, run `make download_data` to download the data directly from Kaggle. This will create a new `data/` directory in your project's root directory.
4. Setup the development infrastructure
    - IMPORTANT: Make sure that you have a default profile conigured for the AWS CLI, otherwise the following step will not work. 
    - Edit the `terraform/dev/main.tf` file and edit line 16, to give a name to the S3 Bucket used to store the artifacts generated during the project development. You must follow the S3 Bucket [naming conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).
    - Run `make create_dev_setup`. This will create a new S3 Bucket in your AWS account, and will also copy the data files to it.
5. Start the MLFlow server by running `make start_mlflow_server`.
    - IMPORTANT: this command will only work if you have run the previous step successfully, because it depends on the S3 Bucket.
    - IMPORTANT: the command will block your terminal. To run other the next commands, you will need to create a new terminal instance.
6. Open the jupyter notebook in `notebooks/insurance_cross_sell_prediction.ipynb` and run all cells to create experiments, models, and track it using the MLFlow tracking system and model registry.
    - IMPORTANT: this command will only work if you have run the previous step successfully, because it dependes on the MLFlow server.
7. Start the Airflow server
    - `cd` to the `airflow` directory and run `astro dev start` to start the Airflow server.
8. Access the Airflow UI available at 127.0.0.1:8081 and login using the default credentials. Default login: `admin`, default password: `admin`.
9. Configure a new AWS connection using your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
    - Navigate to Admin -> Connections and click on the `+` symbol to create a new connection
    - Fill in the connection id as `my_aws_conn` (the code looks for a connection with this ID, so the it must be exactly like that)
    - Fill in the `AWS Access Key ID` field with your access key id.
    - Fill in the `AWS Secret Access Key` field with your secret access key.
    - Save the connection
10. Run the `training_pipeline` DAG to run the machine learning training pipeline. This pipeline will download the data, preprocess it, train a machine learning model and then upload its artifacts to Amazon S3.
    - Navigate to `DAGs`
    - Select the `training_pipeline` DAG and run it by clicking in the "play button" in the up right corner. 
    - When the DAG is done, you will need to access the `XCom` of the last task in order to get the S3 path to the model's artifacts. This will be needed in order to deploy the model.
        - Navigate to `Browse` -> `DAG runs`
        - Select the last DAG run
        - Navigate to `Graph`, then click on the `train_model` task. Click on the `XCom` tab and copy the S3 path for the model artifacts.
11. Deploy the model. To deploy the model, it is necessary to run its CI/CD pipeline. This is ran using GitHub Actions, meaning that in order for you to deploy the trained model, you will need to set a GitHub repository for your local forked repository.
    - After associating your local repository with a GitHub Repository, the next step is to create repository secrets for your new GitHub repository. The secrets are used to provide AWS credentials to the GitHub runner in order for it to deploy the Model to your AWS account.
        - Follow [these](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) instructions to create the following secrets:
            - MY_ACCESS_KEY_ID: the value for this secret is your `AWS_ACCESS_KEY_ID`
            - MY_AWS_SECRET_ACCESS_KEY: the value for this secret is your `AWS_SECRET_ACCESS_KEY`
        - Now, edit the `src/constants.py` file to specify the S3 key for your model artifacts. This was extracted in the previous step.
        - Finally, commit your work and push to the `main` branch. This will run the CI/CD pipeline and deploy your model to production in a Sagemaker Endpoint.

## SUPER SUPER SUPER IMPORTANT
If you followed the steps above, some resources have been created in your AWS account.
TODO: add delete resources steps.





