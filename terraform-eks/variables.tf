# # Input variables (optional)
# # variables.tf
variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "Subnets for EKS Cluster"
  type        = list(string)
}


# variable "region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-east-1"
# }

# variable "cluster_name" {
#   description = "hpp-model-eks-cluster"
#   type        = string
#   default     = "hpp-model-eks-cluster"
# }

# variable "region" {
#   default = "us-east-1"
# }

# variable "cluster_name" {
#   default = "hppmodelapp-eks-cluster"
# }

# variable "vpc_cidr" {
#   default = "10.0.0.0/16"
# }
