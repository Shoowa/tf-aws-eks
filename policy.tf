data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    sid           = "EksAssumeRole"
    actions       = ["sts:AssumeRole"]
    effect        = "Allow"

    principals    {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

  }
}


data "aws_iam_policy_document" "irsa_s3_rw" {
  statement {
    sid           = "EksIrsa"
    actions       = ["sts:AssumeRoleWithWebIdentity"]
    effect        = "Allow"

    principals    {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.workhorse.arn]
    }

    # Requestor authenticated with service account named "s3-rw" in namespace "primary"
    condition     {
      test        = "StringEquals"
      variable    = "${replace(aws_iam_openid_connect_provider.workhorse.url, "https://", "")}:sub" 
      values      = ["system:serviceaccount:primary:s3-rw"]
    }
  }
}


data "aws_iam_policy_document" "s3_rw" {
  statement {
    sid       = "ReadWriteS3"
    actions   = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
      "s3:DeleteObject",
    ]
    effect    = "Allow"
    resources = [local.s3]
  }

  statement {
    sid       = "EncryptS3"
    actions   = [
      "kms:DescribeKey",
      "kms:GenerateDataKey",
    ]
    effect    = "Allow"
    resources = ["*"]

    condition {
      test      = "StringLike"
      variable  = "kms:ViaService"
      values    = ["s3.*.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "eks_minion_assume_role" {
  statement {
    sid           = "EksMinionAssumeRole"
    actions       = ["sts:AssumeRole"]
    effect        = "Allow"

    principals    {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "eks_key" {
  statement {
    sid       = "ArchitectUseKey"
    actions   = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource*",
      "kms:UntagResource*",
      "kms:ScheduleKeyDeletion*",
      "kms:CancelKeyDeletion*",
    ]
    effect    = "Allow"
    resources = ["*"]

    condition {
      test      = "StringEquals"
      variable  = "kms:KeySpec"
      values    = ["SYMMETRIC_DEFAULT"]
    }

    principals    {
      type        = "AWS"
      identifiers = [data.aws_iam_role.arch.arn]
    }
  }
}


data "aws_iam_policy_document" "irsa_aws_node_cni" {
  statement {
    sid           = "EksAwsNodeIrsa"
    actions       = ["sts:AssumeRoleWithWebIdentity"]
    effect        = "Allow"

    principals    {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.workhorse.arn]
    }

    # Requestor authenticated with service account named "aws-node" in namespace "kube-system"
    condition     {
      test        = "StringEquals"
      variable    = "${replace(aws_iam_openid_connect_provider.workhorse.url, "https://", "")}:sub"
      values      = ["system:serviceaccount:kube-system:aws-node"]
    }

    condition     {
      test        = "StringEquals"
      variable    = "${replace(aws_iam_openid_connect_provider.workhorse.url, "https://", "")}:aud"
      values      = ["sts.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "cni_ip6" {
  statement {
    sid       = "EksIp6"
    actions   = [
      "ec2:AssignIpv6Addresses",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes",
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid       = "EksIp6Tags"
    actions   = [
      "ec2:CreateTags",
    ]
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:network-interface/*"]
  }
}


data "aws_iam_policy_document" "irsa_lb_controller" {
  statement {
    sid           = "EksLbController"
    actions       = ["sts:AssumeRoleWithWebIdentity"]
    effect        = "Allow"

    principals    {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.workhorse.arn]
    }

    # Requestor authenticated with service account named "aws-load-balancer-controller" in namespace "kube-system"
    condition     {
      test        = "StringEquals"
      variable    = "${replace(aws_iam_openid_connect_provider.workhorse.url, "https://", "")}:sub"
      values      = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    condition     {
      test        = "StringEquals"
      variable    = "${replace(aws_iam_openid_connect_provider.workhorse.url, "https://", "")}:aud"
      values      = ["sts.amazonaws.com"]
    }
  }
}
