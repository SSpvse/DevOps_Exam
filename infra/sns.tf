

resource "aws_sns_topic" "alarm_notifications" {
  name = "sqs-age-alarm-notification-71"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}


