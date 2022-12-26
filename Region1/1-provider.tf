provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks-cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

data "aws_eks_cluster" "eks-cluster" {
  depends_on = [aws_eks_cluster.eks-cluster]
  name = aws_eks_cluster.eks-cluster.id
}

data "aws_eks_cluster_auth" "eks-cluster" {
  depends_on = [aws_eks_cluster.eks-cluster]
  name = aws_eks_cluster.eks-cluster.id
}