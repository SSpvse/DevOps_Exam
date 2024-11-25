# So i can tag my name when naming stuff
variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default = "stsp_71"
}

variable "s3_bucket_name" {
  description = "The S3 bucket where images are stored"
  type        = string
  default     = "pgr301-couch-explorers"
}

# Mail adress for the notification from sns
variable "notification_email" {
  description = "The email address to send alarm notifications to."
  type        = string
  default = "stsp003@student.kristiania.no"     # E-Mail for the notifications when threshold is exceeded  (4th exersice)
}

variable "alarm_threshold" {
  description = "The threshold (in seconds) for waiting time of images in the queue"
  type        = number
  default     = 5  # Threshold for the oldest messages queue metrics, in seconds (4th exersice)
}