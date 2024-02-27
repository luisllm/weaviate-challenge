terraform {
  required_version = "~> 1.7.0"

  backend "s3" {
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.36.0"
    }
    #kubernetes = {
    #  source  = "hashicorp/kubernetes"
    #  version = "= 2.24.0"
    #}
  }
}