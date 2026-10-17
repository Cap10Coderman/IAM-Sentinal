# Package the Lambda Python code into a ZIP file
data "archive_file" "iam_sentinel" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda/iam-sentinel.zip"
}

# Create the IAM Sentinel Lambda function
resource "aws_lambda_function" "iam_sentinel" {
  function_name = "iam-sentinel"
  description   = "Detects IAM user policy changes and sends security alerts"

  role    = aws_iam_role.lambda_execution.arn
  runtime = "python3.12"
  handler = "handler.lambda_handler"

  filename         = data.archive_file.iam_sentinel.output_path
  source_code_hash = data.archive_file.iam_sentinel.output_base64sha256

  timeout     = 30
  memory_size = 128

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.iam_sentinel.arn
    }
  }

  tags = {
    Project     = "IAM-Sentinel"
    Environment = "dev"
    ManagedBy   = "Terraform"
    User        = "Unny"
  }
}