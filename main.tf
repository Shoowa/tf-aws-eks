resource "aws_cloudwatch_log_group" "workhorse" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}


resource "aws_iam_openid_connect_provider" "workhorse" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.workhorse.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.workhorse.identity[0].oidc[0].issuer
}


resource "aws_kms_key" "workhorse" {
  description           = "Key for ${var.cluster_name} pods."
  enable_key_rotation   = true
  policy                = data.aws_iam_policy_document.eks_key.json
}


resource "aws_kms_grant" "eks-admin" {
  name              = "enable-network-changes"
  key_id            = aws_kms_key.workhorse.id
  grantee_principal = aws_iam_role.eks_admin.arn
  operations        = ["DescribeKey"]
}


resource "aws_eks_cluster" "workhorse" {
  depends_on    = [aws_cloudwatch_log_group.workhorse]

  name          = var.cluster_name
  role_arn      = aws_iam_role.eks_admin.arn

  vpc_config {
    subnet_ids              = var.app_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.safelist
  }

  kubernetes_network_config {
    ip_family = "ipv6"
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.workhorse.arn
    }
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
  ]
}


resource "aws_eks_node_group" "stable" {
  cluster_name    = aws_eks_cluster.workhorse.name
  node_group_name = "stable"
  node_role_arn   = aws_iam_role.eks_minion.arn
  subnet_ids      = aws_eks_cluster.workhorse.vpc_config.0.subnet_ids
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.micro", "t3a.micro"]

  scaling_config {
    min_size      = 3
    max_size      = 7
    desired_size  = 3
  }

  update_config {
    max_unavailable_percentage = 10
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}


resource "aws_eks_node_group" "auction" {
  cluster_name    = aws_eks_cluster.workhorse.name
  node_group_name = "auction"
  node_role_arn   = aws_iam_role.eks_minion.arn
  subnet_ids      = aws_eks_cluster.workhorse.vpc_config.0.subnet_ids
  capacity_type   = "SPOT"
  instance_types  = ["t3.micro", "t3a.micro"]

  scaling_config {
    min_size      = 1
    max_size      = 9
    desired_size  = 1
  }

  update_config {
    max_unavailable_percentage = 20
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  timeouts {
    create = "10m"
    update = "10m"
  }
}
