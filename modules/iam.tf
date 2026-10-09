
# ---------------------------------------------------------
# IAM Sentinel - Lambda Execution Role
# ---------------------------------------------------------

resource "aws_iam_role" "lambda_execution" {
  name        = "iam-sentinel-lambda-role"
  description = "Execution role for the IAM Sentinel Lambda function"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project     = "IAM-Sentinel"
    ManagedBy   = "Terraform"
    User        = "Unny"
  }
}

# ---------------------------------------------------------
# IAM Sentinel - Lambda Permissions
# ---------------------------------------------------------

resource "aws_iam_role_policy" "lambda_execution" {
  name = "iam-sentinel-lambda-policy"
  role = aws_iam_role.lambda_execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "PublishSecurityAlerts"
        Effect = "Allow"

        Action = [
          "sns:Publish"
        ]

        Resource = aws_sns_topic.iam_sentinel.arn
      }
    ]
  })
}