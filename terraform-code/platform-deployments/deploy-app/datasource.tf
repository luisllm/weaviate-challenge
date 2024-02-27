data "terraform_remote_state" "eks_state" {
  backend = "s3"
  config = {
    bucket = "${local.system_name}-test-llm-terraform-state"
    key    = "vpc-eks.tfstate"
    region = local.aws_region
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks_state.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = data.terraform_remote_state.eks_state.outputs.eks_cluster_name
}