terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

module "sitec2" {
  source = "../../modules/ec2"
}
