# ---------------------------------------------------------
# IAM Sentinel - CloudTrail S3 Bucket
# ---------------------------------------------------------

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "iam-sentinel-cloudtrail-${data.aws_caller_identity.current.account_id}"

  tags = {
    Project     = "IAM-Sentinel"
    Environment = "dev"
    ManagedBy   = "Terraform"
    User        = "Unny"

  }
}

# ---------------------------------------------------------
# Block All Public Access
# ---------------------------------------------------------

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------
# Enable Bucket Versioning
# ---------------------------------------------------------

resource "aws_s3_bucket_versioning" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ---------------------------------------------------------
# Enable Server-Side Encryption
# ---------------------------------------------------------

#These are the sub resources of s3
#To handle specific security, lifecycle, and access features independently (avoiding configuration drift),
#Terraform uses dedicated sub-resources:

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------------------------------------
# CloudTrail Bucket Policy
# ---------------------------------------------------------

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = [
          "s3:GetBucketAcl"
        ]

        Resource = aws_s3_bucket.cloudtrail.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = [
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.cloudtrail
  ]
}