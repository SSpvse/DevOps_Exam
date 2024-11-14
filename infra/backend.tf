/* terraform {
  backend "s3" {
    bucket = "pgr301-2024-terraform-state"  # Your existing S3 bucket for Terraform state
    key    = "terraform.tfstate"            # Path to the state file in the S3 bucket
    region = "eu-west-1"                    # AWS region where the bucket is located
    encrypt = true                          # Enable encryption for security
    dynamodb_table = "terraform-lock-table" # Optional: DynamoDB table for state locking
  }
}
*/