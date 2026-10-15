# ---------------------------------------------------------
# IAM Sentinel - CloudTrail
# ---------------------------------------------------------

resource "aws_cloudtrail" "iam_sentinel" {
  name                          = "iam-sentinel-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true

  # Record management events, including IAM API calls.
  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }

  tags = {
    Project     = "IAM-Sentinel"
    Environment = "dev"
    ManagedBy   = "Terraform"
    User        = "Unny"
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail
  ]
}