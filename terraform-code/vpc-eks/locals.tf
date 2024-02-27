data "aws_caller_identity" "current" {
}

locals {
  aws_region  = var.aws_region
  system_name = var.system_name
  commontags  = var.commontags
}