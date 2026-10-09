output "sns_topic_arn" {
  description = "ARN of the IAM Sentinel SNS notification topic"
  value       = module.iam_sentinel.sns_topic_arn
}

output "lambda_function_name" {
  description = "Name of the IAM Sentinel Lambda function"
  value       = module.iam_sentinel.lambda_function_name
}

output "eventbridge_rule_name" {
  description = "Name of the IAM policy-change detection rule"
  value       = module.iam_sentinel.eventbridge_rule_name
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail trail"
  value       = module.iam_sentinel.cloudtrail_name
}
