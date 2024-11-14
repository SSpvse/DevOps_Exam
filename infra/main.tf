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

resource "aws_sqs_queue" "image_generation_queue" {
  name                      = "${var.prefix}_image-generation-queue"
  visibility_timeout_seconds = 20
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.prefix}_lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_sqs_s3_policy" {
  name        = "${var.prefix}_lambda_sqs_s3_policy"
  description = "Policy for Lambda to access SQS and S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = aws_sqs_queue.image_generation_queue.arn
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Resource = [
          "arn:aws:s3:::pgr301-2024-terraform-state",
          "arn:aws:s3:::pgr301-2024-terraform-state/*",
          "arn:aws:s3:::pgr301-couch-explorers",
          "arn:aws:s3:::pgr301-couch-explorers/*"
        ]
      },
      {
      "Effect": "Allow",
      "Action": "bedrock:InvokeModel",
      "Resource": "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_sqs_s3_policy.arn
}

resource "aws_lambda_function" "image_generation_lambda" {
  function_name = "${var.prefix}_image-generation-function"
  role          = aws_iam_role.lambda_execution_role.arn
  runtime       = "python3.12"
  handler       = "lambda_sqs.lambda_handler"
  timeout       = 15

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

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}
