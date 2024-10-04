terraform {
  backend "s3" {
    bucket  = "nw-test-edsoncarlos-terraform-state"
    region  = "us-east-1"
    key     = "ecs-fargate/terraform.tfstate"
    encrypt = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}


