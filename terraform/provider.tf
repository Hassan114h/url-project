terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
  }

  backend "s3" {
    bucket       = "hassan-ecs-tf-13445"  # the bucket created below
    key          = "terraform.tfstate"    # path inside the bucket
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true   # enables local lock file
  }
}

provider "aws" {
  region = "eu-west-1"
}




