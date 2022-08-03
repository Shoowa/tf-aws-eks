resource "aws_iam_role" "eks_admin" {
  name                = "eks-admin"
  assume_role_policy  = data.aws_iam_policy_document.eks_assume_role.json
  managed_policy_arns = [
    data.aws_iam_policy.eks_cluster.arn,
    data.aws_iam_policy.eks_vpc_controller.arn
  ]
}


resource "aws_iam_role" "irsa_s3_rw" {
  name                = "irsa-s3-rw"
  assume_role_policy  = data.aws_iam_policy_document.irsa_s3_rw.json

  inline_policy {
    name              = "s3-read-write"
    policy            = data.aws_iam_policy_document.s3_rw.json
  }
}


resource "aws_iam_role" "eks_minion" {
  name                = "eks-minion"
  assume_role_policy  = data.aws_iam_policy_document.eks_minion_assume_role.json
  managed_policy_arns = [
    data.aws_iam_policy.eks_worker.arn,
    data.aws_iam_policy.eks_cni.arn,
    data.aws_iam_policy.eks_ecr.arn,
  ]
}


resource "aws_iam_role" "eks_cni_ip6" {
  name                = "eks-cni-ip6"
  assume_role_policy  = data.aws_iam_policy_document.irsa_aws_node_cni.json

  inline_policy {
    name        = "eks-cni-ip6"
    policy      = data.aws_iam_policy_document.cni_ip6.json
  }
}
