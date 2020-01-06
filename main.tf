terraform {
  backend "remote" {
    organization = "zhangmake-dev"

    workspaces {
      name = "terraform_aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_iam_role" "terraform_test_lambda_role" {
  name               = "terraform_test_lambda_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_lambda_function" "terraform_lambda" {
  filename      = "../function_code/lambda.py.zip"
  function_name = "terraform_test_function"
  role          = aws_iam_role.terraform_test_lambda_role.arn
  handler       = "lambda.handler"
  runtime       = "python3.7"
}

output "terraform_test_lambda_role_arn" {
  value = aws_iam_role.terraform_test_lambda_role.arn
}