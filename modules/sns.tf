# ---------------------------------------------------------
# IAM Sentinel - SNS Notification Topic
# ---------------------------------------------------------

resource "aws_sns_topic" "iam_sentinel" {
  name         = "iam-sentinel-alerts"
  display_name = "IAM Sentinel Security Alerts"

  tags = {
    Project     = "IAM-Sentinel"
    ManagedBy   = "Terraform"
    User        = "Unny"
  }
}

# ---------------------------------------------------------
# IAM Sentinel - Email Subscription
# ---------------------------------------------------------

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.iam_sentinel.arn
  protocol  = "email"
  endpoint  = var.notification_email
}