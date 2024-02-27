# eks_cluster_id is then used by the platform-deployments stack to know what is the EKS cluster to deploy the apps
output "eks_cluster_name" {
  description = "The name/id of the EKS cluster."
  value       = module.eks.cluster_name
}