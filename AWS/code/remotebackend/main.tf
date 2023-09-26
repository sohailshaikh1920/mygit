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

resource "aws_eip"  "backendeip1"{
  vpc = "true"
}
