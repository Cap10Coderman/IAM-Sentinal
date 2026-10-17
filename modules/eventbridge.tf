# EventBridge rule to detect IAM user policy changes
resource "aws_cloudwatch_event_rule" "iam_policy_changes" {
  name        = "iam-sentinel-policy-changes"
  description = "Detect IAM user policy changes recorded by CloudTrail"

  event_pattern = jsonencode({
    source        = ["aws.iam"]
    "detail-type" = ["AWS API Call via CloudTrail"]

    detail = {
      eventSource = ["iam.amazonaws.com"]

      eventName = [
        "PutUserPolicy",
        "DeleteUserPolicy",
        "AttachUserPolicy",
        "DetachUserPolicy"
      ]
    }
  })

  tags = {
    Project     = "IAM-Sentinel"
    Environment = "dev"
    ManagedBy   = "Terraform"
    User        = "Unny"
  }
}

# Send matching events to the IAM Sentinel Lambda function
resource "aws_cloudwatch_event_target" "iam_sentinel_lambda" {
  rule      = aws_cloudwatch_event_rule.iam_policy_changes.name
  target_id = "IAMSentinelLambda"
  arn       = aws_lambda_function.iam_sentinel.arn
}

# Allow EventBridge to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iam_sentinel.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.iam_policy_changes.arn
}