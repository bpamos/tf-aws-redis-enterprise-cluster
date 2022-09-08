terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# AWS region and AWS key pair
provider "aws" {
  region = var.region
  access_key = var.aws_creds[0]
  secret_key = var.aws_creds[1]
}


locals {
    ssh_user         = "ubuntu"
    private_key_path = "~/desktop/keys/bamos-west2-ssh-aws.pem"
}