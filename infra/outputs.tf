output "sqs_queue_url" {
  description = "URL of the SQS Queue"
  value       = aws_sqs_queue.image_generation_queue.id
}

output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.image_generation_lambda.arn
}

output "lambda_execution_role_arn" {
  description = "IAM role ARN for Lambda execution"
  value       = aws_iam_role.lambda_execution_role.arn
}

# Archive file data source to create the zip file for the Lambda function
data "archive_file" "lambda_sqs" {
  type        = "zip"
  source_file = "${path.module}/../eksamen-2024/lambda_sqs.py"  # Path of the Lambda file
  output_path = "${path.module}/lambda_sqs.zip"  # Path where the zip will be stored
}

