terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45.0"
    }
  }
  backend "s3" {
    key    = "tfstate/security_infra.tfstate"
    region = "us-east-2"
  }
  required_version = ">= 0.13.5"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

data "aws_caller_identity" "current" {}
