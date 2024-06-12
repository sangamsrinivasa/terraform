# Define the provider (AWS)
provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

# Define the EKS cluster
resource "aws_eks_cluster" "dev_cluster" {
  name     = "dev-cluster"
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.29"

  vpc_config {
    subnet_ids         = ["subnet-1", "subnet-2"]
    security_group_ids = ["sg-id"]
  }
}

# Define the IAM role for EKS
resource "aws_iam_role" "eks_role" {
  name = "my-eks-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the IAM role for EKS
resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

