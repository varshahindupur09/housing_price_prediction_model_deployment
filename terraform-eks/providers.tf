provider "aws" {
  region  = "us-east-1"
  profile = "varshahindupur"
}

# provider "aws" {
#   region = "us-east-1"
#   assume_role {
#     role_arn = "arn:aws:iam::381491906666:role/hppmodelapp-eks-cluster-role"
#   }
# }

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
}
