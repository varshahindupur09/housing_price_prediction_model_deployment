# # # main.tf
terraform {
  required_version = ">= 1.10"
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

module "vpc" {
  source = "./vpc.tf"
}

module "eks" {
  source  = "./eks.tf"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
}

module "iam" {
  source     = "./iam.tf"
  cluster_id = module.eks.cluster_id
}


# # VPC Module
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 5.19.0"

#   name = "hppmodelapp-eks-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
