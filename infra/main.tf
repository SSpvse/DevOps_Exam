terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "71/71_lambda_sqs.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_lambda_function" "image_generation_lambda" {
  function_name = "${var.prefix}_image-generation-function"
  role          = aws_iam_role.lambda_execution_role.arn
  runtime       = "python3.12"
  handler       = "lambda_sqs.lambda_handler"
  timeout       = 15 # if function takes longer than 15 secs to execute ,terminate

  environment {
    variables = {
      bucket_name     = var.s3_bucket_name
      candidate_number = "71"
    }
  }
  filename = "${path.module}/lambda_sqs.zip"

  depends_on = [aws_iam_role_policy_attachment.lambda_execution_role_attachment]
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.image_generation_queue.arn
  function_name    = aws_lambda_function.image_generation_lambda.arn
  batch_size       = 10
  enabled          = true
}

