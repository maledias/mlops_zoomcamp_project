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
  bucket = "mlops-zoomcamp-proj-mlflow-artifacts-bucket-20240724-pitaya"

  tags = {
    Proj = "mlops-zoomcamp-proj"
  }
}

output "mlflow_artifacts_bucket_name" {
  value = aws_s3_bucket.mlflow_artifacts_bucket.id
}

resource "aws_iam_role" "sagemaker_role" {
  name = "my_test_sagemaker_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "AmazonSageMakerFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonSageMakerFullAccess-policy-attach" {
  role       = "${aws_iam_role.sagemaker_role.name}"
  policy_arn = "${data.aws_iam_policy.AmazonSageMakerFullAccess.arn}"
}

output "sagemaker_role_arn" {
  value = aws_iam_role.sagemaker_role.arn
}