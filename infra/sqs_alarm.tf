

resource "aws_sqs_queue" "image_generation_queue" {
  name                      = "${var.prefix}_image-generation-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 60
}

resource "aws_cloudwatch_metric_alarm" "sqs_age_alarm" {
  alarm_name          = "SQS-oldest-msg-alarm-${var.prefix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 30
  statistic           = "Maximum"
  threshold           = var.alarm_threshold
  alarm_description   = "Triggered when the age of the oldest image (SQS msg) exceeds the threshold."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarm_notifications.arn]

  dimensions = {
    QueueName = aws_sqs_queue.image_generation_queue.name
  }
}
