terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mlflow_artifacts_bucket" {
  bucket = "mlops-zoomcamp-proj-mlflow-artifacts-bucket-20240724"

  tags = {
    Proj = "mlops-zoomcamp-proj"
  }
}

output "mlflow_artifacts_bucket_name" {
  value = aws_s3_bucket.mlflow_artifacts_bucket.id
}
