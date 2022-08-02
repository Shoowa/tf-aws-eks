terraform {
  required_version = "~> 1.0"

  required_providers {

    aws         = {
      version   = ">= 4.0"
      source    = "hashicorp/aws"
    }

  }

  backend "s3" {
    profile         = "arch"
    bucket          = "blueprint-us-east-2-production-assymblur"
    key             = "dev/ops/k8s/terraform.tfstate"
    region          = "us-east-2" 
    
    dynamodb_table  = "blueprint-us-east-2-production-assymblur"
    encrypt         = true
  }

}

provider "aws" {
    shared_config_files       = ["~/.aws/config"]
    shared_credentials_files  = ["~/.aws/credentials"]
    profile                   = "arch"
    region                    = "us-east-2"

    default_tags {
      tags          = {
        Environment = "dev"
        Service     = "ops"
        Dept        = "sre"
        test        = true
      }
    }
}
