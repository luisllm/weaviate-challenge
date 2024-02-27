variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "system_name" {
  type = string
}

variable "environment" {
  type    = string
  
  validation {
    condition     = var.environment == "prod" || var.environment == "staging" || var.environment == "develop"
    error_message = "Invalid environment value. Please choose either 'prod', 'staging', or 'develop'."
  }
}

#######
# VPC #
#######
variable "vpc_enable_nat_gateway" {
  type        = bool
  description = "If true, it will create NAT GATEWAYS in the VPC"
  default     = true
}

variable "vpc_single_nat_gateway" {
  type        = bool
  description = "If true, it will create only 1 NAT GATEWAY in one of the public subnets, which will be used by all private subnets of the VPC"
  default     = true
}


########
# Tags #
########

variable "commontags" {
  type = map(any)

  default = {
    deploymentTool = "Terraform"
  }

  description = <<-EOF
  Map of tags that all resources in the platform will have.
  In this map, the key is the name of the tag and the value is the value of the tag.
  E.g:
  commontags = {
    deploymentTool    = "Terraform"
    team              = "myteam"
    environment       = "prod"
    release           = "myrelease"
    platformName      = "myplatformname"
  }
EOF
}

#################
# EKS variables #
#################

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(any)
  description = "List of CIDRs that will be able to connect to the EKS control plane."
  # This should be changed when using self hosted github action runner
  default = [
    "0.0.0.0/0"
  ]
}

variable "eks_addons_version" {
  description = "EKS Add-on versions that will be installed"
  type        = map(string)
  default = {
    coredns            = "v1.10.1-eksbuild.7"
    kube_proxy         = "v1.28.6-eksbuild.2"
    vpc_cni            = "v1.16.3-eksbuild.2"
    aws_ebs_csi_driver = "v1.28.0-eksbuild.1"
  }
}

variable "eks" {
  type = object({
    prod = object({
      kubernetes_version    = string
      min_size              = number
      desired_size          = number
      max_size              = number
      instance_types        = list(string)
      worker_node_disk_size = number
      capacity_type         = string
    })
    staging = object({
      kubernetes_version    = string
      min_size              = number
      desired_size          = number
      max_size              = number
      instance_types        = list(string)
      worker_node_disk_size = number
      capacity_type         = string
    })
    develop = object({
      kubernetes_version    = string
      min_size              = number
      desired_size          = number
      max_size              = number
      instance_types        = list(string)
      worker_node_disk_size = number
      capacity_type         = string
    })
  })
  default = {
    prod = {
      kubernetes_version    = "1.28"
      min_size              = 2
      desired_size          = 2
      max_size              = 5
      instance_types        = ["t3.small"]
      worker_node_disk_size = 50
      capacity_type         = "SPOT"
    }
    staging = {
      kubernetes_version    = "1.28"
      min_size              = 2
      desired_size          = 2
      max_size              = 3
      instance_types        = ["t3.small"]
      worker_node_disk_size = 50
      capacity_type         = "SPOT"
    }
    develop = {
      kubernetes_version    = "1.28"
      min_size              = 2
      desired_size          = 2
      max_size              = 3
      instance_types        = ["t3.small"]
      worker_node_disk_size = 50
      capacity_type         = "SPOT"
    }
  }
}


variable public-lb-secgroup-ipv4cidrs {
  type        = list(any)
  description = "List of IPv4 CIDRs that will be allowed in the SecGroup of the public AWS LB"
  default = [
    "0.0.0.0/0"
  ]
}

variable public-lb-secgroup-ipv6cidrs {
  type        = list(any)
  description = "List of IPv6 CIDRs that will be allowed in the SecGroup of the public AWS LB"
  default = [
    "::/0"
  ]
}

variable "eks_admin_user_arn" {
  type        = string
  description = "ARN of the IAM user created beforehand that will be configured as the EKS/Kubernetes admin"
  default     = "arn:aws:iam::798842239772:user/test-eks-admin"
}
