# Policies for K8S Control Plane.
data "aws_iam_policy" "eks_cluster" {
  name = "AmazonEKSClusterPolicy"
}


data "aws_iam_policy" "eks_vpc_controller" {
  name = "AmazonEKSVPCResourceController"
}


data "tls_certificate" "workhorse" {
  url = aws_eks_cluster.workhorse.identity[0].oidc[0].issuer
}


# Policies for K8S Nodes.
data "aws_iam_policy" "eks_worker" {
  name = "AmazonEKSWorkerNodePolicy"
}


data "aws_iam_policy" "eks_cni" {
  name = "AmazonEKS_CNI_Policy"
}


data "aws_iam_policy" "eks_ecr" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}


# Role allowed to view KMS Key used for K8S Secrets.
data "aws_iam_role" "arch" {
  name = "architect"
}
