module "iam_sentinel" {
  source = "./modules"

  aws_region         = var.aws_region
  notification_email = var.notification_email
}
