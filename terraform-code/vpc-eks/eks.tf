# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/20.4.0

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.4.0"

  cluster_name    = "${local.system_name}-eks-cluster"
  cluster_version = lookup(var.eks[var.environment], "kubernetes_version")

  # This should be improved and changed by using Github actions runners self managed 
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_addons = {
    coredns = {
      most_recent = true
      addon_version = var.eks_addons_version.coredns
    }
    kube-proxy = {
      addon_version = var.eks_addons_version.kube_proxy
    }
    vpc-cni = {
      addon_version = var.eks_addons_version.vpc_cni
    }
    aws-ebs-csi-driver = {
      addon_version            = var.eks_addons_version.aws_ebs_csi_driver
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  eks_managed_node_groups = {
    example = {
      min_size       = lookup(var.eks[var.environment], "min_size")
      max_size       = lookup(var.eks[var.environment], "max_size")
      desired_size   = lookup(var.eks[var.environment], "desired_size")
      instance_types = lookup(var.eks[var.environment], "instance_types")
      capacity_type  = lookup(var.eks[var.environment], "capacity_type")
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  # Allow an additional IAM user to be the EKS admin
  access_entries = {
    # One access entry with a policy associated
    test-eks-admin = {
      kubernetes_groups = []
      principal_arn     = var.eks_admin_user_arn
      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
  }

  tags = local.commontags
}


# https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-role-for-service-accounts-eks
# Creates the following IAM Role with the following IAM permissions for EBS CSI driver
# https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json
# The IAM Role will be used by the EBS CSI driver ServiceAccount
module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.34.0"

  role_name = "${module.eks.cluster_name}-ebs-csi-driver-role"
  attach_ebs_csi_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = local.commontags
}