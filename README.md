# tf-aws-eks
Kubernetes on AWS

### Testing
Every instance drafted for testing needs a configured _provider.tf_. Replace the AWS Profile and S3 Bucket name in the template below.

```terraform
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
