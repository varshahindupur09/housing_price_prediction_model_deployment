# # Outputs for the EKS cluster
# # outputs.tf
# output "cluster_name" {
#   value = module.eks.cluster_name
# }

# output "cluster_endpoint" {
#   value = module.eks.cluster_endpoint
# }

# output "cluster_security_group_id" {
#   value = module.eks.cluster_security_group_id
# }

# output "node_security_group_id" {
#   value = module.eks.node_security_group_id
# }

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "eks_cluster_endpoint" {
#   description = "EKS Cluster endpoint"
#   value       = module.eks.cluster_endpoint
# }

# output "eks_cluster_name" {
#   description = "EKS Cluster name"
#   value       = module.eks.cluster_name
# }

# output "eks_kubeconfig" {
#   description = "Kubernetes configuration"
#   value = <<EOT
#   apiVersion: v1
#   kind: Config
#   clusters:
#   - cluster:
#       server: ${module.eks.cluster_endpoint}
#       certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
#     name: eks-cluster
#   contexts:
#   - context:
#       cluster: eks-cluster
#       user: eks-user
#     name: eks-context
#   current-context: eks-context
#   users:
#   - name: eks-user
#     user:
#       token: ${data.aws_eks_cluster_auth.eks.token}
#   EOT
#   sensitive = true
# }
