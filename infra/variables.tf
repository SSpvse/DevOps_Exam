variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default = "stsp_71"
}

variable "s3_bucket_name" {
  type        = string
  description = "The S3 bucket where images are stored"
  default     = "pgr301-couch-explorers"
}

