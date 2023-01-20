# tf-aws-eks
Kubernetes on AWS

### Testing
Every instance drafted for testing needs a configured _provider.tf_. Replace the AWS Profile and S3 Bucket name in the template below.

```terraform
// provider.tf
terraform {
  required_version = "~> 1.0"

  required_providers {

    aws         = {
      version   = ">= 4.0"
      source    = "hashicorp/aws"
    }

  }

  backend "s3" {
    profile         = "yourProfile"
    bucket          = "yourBucket"
    key             = "test1/ops/k8s/terraform.tfstate"
    region          = "us-east-2"

    dynamodb_table  = "yourDynamo"
    encrypt         = true
  }

}

provider "aws" {
    shared_config_files       = ["~/.aws/config"]
    shared_credentials_files  = ["~/.aws/credentials"]
    profile                   = "yourProfile"
    region                    = "us-east-2"

    default_tags {
      tags          = {
        Environment = "sandbox"
        Service     = "ops"
        Dept        = "sre"
        test        = true
      }
    }
}
```

### AWS IAM Roles for K8S Service Accounts
This module adopts IRSA for EKS, so that pods can adopt IAM Roles. A _aws_iam_openid_connect_provider_ resource is created in _main.tf_, and a policy named _irsa_lb_controller_ in _data.tf_ is configured to create an OpenID Connect identity provider to enable IRSA.

```terraform
// main.tf
resource "aws_iam_openid_connect_provider" "workhorse" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.workhorse.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.workhorse.identity[0].oidc[0].issuer
}


// policy.tf
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
```

### AWS Load Balancer Controller
Public subnets need the tag `kubernetes.io/role/elb` to permit the AWS Load Balancer Controller to discover the subnets. And the policy for the controller is
drafted in _lb_controller.json_.

### IPv6
This module adopts IPv6 through roles and policies. Pods will receive IPv6 traffic directly from the ALB. Pods will receive IPv4 traffic indirectly through a
NAT Gateway. Some AWS services still receive requests via IPv4, and others can receive requests via IPv6.
