# # # IAM roles and policies
# # # iam.tf

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "hppmodelapp-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::381491906666:user/VarshaHindupur"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "hppmodelapp-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policies" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# IAM Policy for EKS Access (for the user)
resource "aws_iam_policy" "eks_access_policy" {
  name        = "EKSClusterAdminAccess"
  description = "Allows full access to EKS cluster for the user"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to the user
resource "aws_iam_user_policy_attachment" "user_eks_access" {
  user       = "VarshaHindupur"
  policy_arn = aws_iam_policy.eks_access_policy.arn
}


# resource "aws_iam_role" "eks_cluster_role" {
#   # name = "hppmodelapp-eks-cluster-role"
#   name = "hppmodelapp-eks-cluster-cluster-20250314012359529900000002"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       },
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::381491906666:user/VarshaHindupur"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role" "eks_node_role" {
#   name = "hppmodelapp-eks-node-role"
  
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# # ✅ Attach Policies for Worker Nodes
# resource "aws_iam_role_policy_attachment" "eks_node_policies" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "eks_registry_read" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }