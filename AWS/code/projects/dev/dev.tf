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
  region = "us-east-1"
  access_key = "AKIAT75DN3MXI36DVANU"
  secret_key = "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"
}

module "devec2" {
  source = "../../modules/ec2"
}
