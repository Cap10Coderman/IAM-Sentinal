variable "aws_region" {
  description = "AWS region where IAM Sentinel will be deployed"
  type        = string
  default     = "ap-south-1"
}

variable "notification_email" {
  description = "Email address for IAM Sentinel alerts"
  type        = string
}